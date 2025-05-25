//
//  CoordinateMapper.swift
//  CoffeeMap
//
//  Created by Цховребова Яна on 24.05.2025.
//

import CoreLocation

typealias Coordinate = (latitude: Double, longitude: Double)

func convertCLLocationCoordinate2DToCoordinate(_ location: CLLocationCoordinate2D) -> Coordinate {
    return (latitude: location.latitude, longitude: location.longitude)
}

func convertCoordinateToCLLocationCoordinate2D(_ coordinate: Coordinate) -> CLLocationCoordinate2D {
    return CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
}
