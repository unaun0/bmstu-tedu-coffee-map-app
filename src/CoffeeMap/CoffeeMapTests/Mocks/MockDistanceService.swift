//
//  MockDistanceService.swift
//  CoffeeMap
//
//  Created by Цховребова Яна on 02.06.2025.
//

import CoreLocation

@testable import CoffeeMap

final class MockDistanceService: DistanceServiceInput {
    func calculateDistance(
        from: CLLocationCoordinate2D,
        to: CLLocationCoordinate2D
    ) -> Double {
        return 123.45
    }
}
