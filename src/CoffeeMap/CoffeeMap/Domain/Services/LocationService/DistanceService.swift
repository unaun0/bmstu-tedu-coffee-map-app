//
//  DistanceService.swift
//  CoffeeMap
//
//  Created by Цховребова Яна on 24.05.2025.
//

import CoreLocation

final class DistanceService: DistanceServiceInput {
    func calculateDistance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double {
        let start = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let end = CLLocation(latitude: to.latitude, longitude: to.longitude)
        let distanceInMeters = start.distance(from: end)
        
        return distanceInMeters / 1000.0
    }
}
