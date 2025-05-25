//
//  LocationServiceInput.swift
//  CoffeeMap
//
//  Created by Цховребова Яна on 24.05.2025.
//

import CoreLocation

protocol LocationServiceInput: AnyObject {
    func getCurrentLocation() async throws -> CLLocationCoordinate2D
    func refreshLocation() async throws -> CLLocationCoordinate2D
}
