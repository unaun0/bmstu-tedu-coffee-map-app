//
//  LocationService.swift
//  CoffeeMap
//
//  Created by Цховребова Яна on 24.05.2025.
//

import CoreLocation

final class LocationService: NSObject, LocationServiceInput {
    private let locationManager = CLLocationManager()
    private var cachedLocation: CLLocationCoordinate2D?
    private var isRequestInProgress = false
    private var continuation: CheckedContinuation<CLLocationCoordinate2D, Error>?
    private var authContinuation: CheckedContinuation<Void, Error>?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func getCurrentLocation() async throws -> CLLocationCoordinate2D {
        if let location = cachedLocation {
            return location
        }
        return try await requestLocation()
    }
    
    func refreshLocation() async throws -> CLLocationCoordinate2D {
        return try await requestLocation()
    }
    
    private func requestLocation() async throws -> CLLocationCoordinate2D {
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined:
            try await requestAuthorization()
        case .denied, .restricted:
            throw LocationError.accessDenied
        case .authorizedWhenInUse, .authorizedAlways:
            break
        @unknown default:
            throw LocationError.accessDenied
        }
        
        if isRequestInProgress {
            return try await withCheckedThrowingContinuation { continuation in
                DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
                    if let loc = self.cachedLocation {
                        continuation.resume(returning: loc)
                    } else {
                        continuation.resume(throwing: LocationError.unableToGetLocation)
                    }
                }
            }
        }
        
        isRequestInProgress = true
        locationManager.requestLocation()
        
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
        }
    }
    
    private func requestAuthorization() async throws {
        locationManager.requestWhenInUseAuthorization()
        
        try await withCheckedThrowingContinuation { continuation in
            self.authContinuation = continuation
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationService: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            authContinuation?.resume()
        case .denied, .restricted:
            authContinuation?.resume(throwing: LocationError.accessDenied)
        case .notDetermined:
            break
        @unknown default:
            authContinuation?.resume(throwing: LocationError.accessDenied)
        }
        
        authContinuation = nil
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first?.coordinate else {
            continuation?.resume(throwing: LocationError.unableToGetLocation)
            cleanupAfterRequest()
            return
        }
        cachedLocation = location
        continuation?.resume(returning: location)
        cleanupAfterRequest()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        continuation?.resume(throwing: error)
        cleanupAfterRequest()
    }
    
    private func cleanupAfterRequest() {
        continuation = nil
        isRequestInProgress = false
    }
}
