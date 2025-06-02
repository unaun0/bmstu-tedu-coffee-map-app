//
//   MockAPIService.swift
//  CoffeeMap
//
//  Created by Цховребова Яна on 02.06.2025.
//

import Foundation

@testable import CoffeeMap

final class MockAPIService: CoffeeShopAPIServiceInput {

    // MARK: - Mocked Properties

    var coffeeShops: [CoffeeMap.CoffeeShopEntity] = []
    var detailShop: CoffeeMap.CoffeeShopEntity?
    var shouldThrow = false

    // MARK: - CoffeeShopAPIServiceInput

    func fetchShops(
        lat: Double?,
        lon: Double?,
        page: Int?
    ) async throws -> [CoffeeMap.CoffeeShopEntity] {
        if shouldThrow {
            throw NSError(
                domain: "MockAPIServiceError", code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Failed to fetch shops"]
            )
        }
        return coffeeShops
    }

    func fetchShopDetails(id: String) async throws -> CoffeeMap.CoffeeShopEntity {
        if shouldThrow {
            throw NSError(
                domain: "MockAPIServiceError", code: 2,
                userInfo: [
                    NSLocalizedDescriptionKey: "Failed to fetch shop details"
                ]
            )
        }
        guard let shop = detailShop else {
            throw NSError(
                domain: "MockAPIServiceError", code: 404,
                userInfo: [NSLocalizedDescriptionKey: "Shop not found"]
            )
        }
        return shop
    }
}
