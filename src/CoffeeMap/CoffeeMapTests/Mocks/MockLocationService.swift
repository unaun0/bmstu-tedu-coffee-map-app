//
//  MockLocationService.swift
//  CoffeeMap
//
//  Created by Цховребова Яна on 02.06.2025.
//

import CoreLocation

@testable import CoffeeMap

final class MockLocationService: LocationServiceInput {
    var shouldThrow = false
    var coordinate = CLLocationCoordinate2D(latitude: 55.75, longitude: 37.61)

    func getCurrentLocation() async throws -> CLLocationCoordinate2D {
        if shouldThrow { throw NSError(domain: "", code: 1) }
        return coordinate
    }

    func refreshLocation() async throws -> CLLocationCoordinate2D {
        if shouldThrow { throw NSError(domain: "", code: 2) }
        return coordinate
    }
}
