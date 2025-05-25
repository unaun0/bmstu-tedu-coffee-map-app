//
//  DistanceServiceInput.swift
//  CoffeeMap
//
//  Created by Цховребова Яна on 24.05.2025.
//

import CoreLocation

protocol DistanceServiceInput {
    func calculateDistance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double
}
