//
//  CoffeeShopDetailViewModel.swift
//  CoffeeMap
//
//  Created by Цховребова Яна on 24.05.2025.
//

import Foundation

struct CoffeeShopDetailViewModel {
    let id: String
    let name: String
    let description: String?
    let rating: String?
    let images: [Data?]
    let address: String
    let phone: String?
    let website: String?
    let workingHours: [String: (startTime: String?, endTime: String?)]
}
