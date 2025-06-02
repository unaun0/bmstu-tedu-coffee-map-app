//
//  AllCoffeeShopsUseCaseInput.swift
//  CoffeeMap
//
//  Created by Цховребова Яна on 23.05.2025.
//

protocol AllCoffeeShopsUseCaseInput {
    func fetchCoffeeShops(
        page: Int?,
        updateLocation: Bool
    ) async throws -> [CoffeeShopEntity]
    func updateLikeStatus(
        id: String,
        isLiked: Bool
    ) async throws
    func fetchCoffeeShop(
        id: String
    ) async throws -> CoffeeShopEntity
}
