//
//  CoffeeShopAPIServiceInput.swift
//  CoffeeMap
//
//  Created by Цховребова Яна on 23.05.2025.
//

protocol CoffeeShopAPIServiceInput {
    func fetchShops(
        lat: Double?,
        lon: Double?,
        page: Int?
    ) async throws -> [CoffeeShopEntity]
    func fetchShopDetails(
        id: String
    ) async throws -> CoffeeShopEntity
}
