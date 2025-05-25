//
//  CoffeeShopEntity.swift
//  CoffeeMap
//
//  Created by Цховребова Яна on 23.05.2025.
//

import Foundation

struct CoffeeShopEntity: BaseEntity {
    var id: String
    var name: String
    var address: String
    var description: String?
    var phone: String?
    var website: String?
    var rating: Double?
    var workingHours: [String: WorkingTime]
    var location: Location
    var photos: [(url: String, data: Data?)]
    var distance: Double?
    var isLiked: Bool
    
    struct WorkingTime {
        var startTime: String?
        var endTime: String?
    }
    
    struct Location {
        var latitude: Double
        var longitude: Double
    }
}
