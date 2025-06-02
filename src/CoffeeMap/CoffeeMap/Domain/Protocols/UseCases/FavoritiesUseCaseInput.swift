//
//  FavoritiesUseCaseInput.swift
//  CoffeeMap
//
//  Created by Козлов Павел on 02.06.2025.
//

protocol FavoritiesUseCaseInput {
    func fetchCoffeeShops(
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
