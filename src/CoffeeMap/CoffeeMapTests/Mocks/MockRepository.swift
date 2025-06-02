//
//  MockRepository.swift
//  CoffeeMap
//
//  Created by Цховребова Яна on 02.06.2025.
//

@testable import CoffeeMap

final class MockRepository: CoffeeShopRepositoryInput {
    var storedShops: [String: CoffeeShopRepositoryDTO] = [:]

    func fetchAll() throws -> [CoffeeShopRepositoryDTO] {
        return Array(storedShops.values)
    }

    func save(_ shop: CoffeeShopRepositoryDTO) throws {
        storedShops[shop.id] = shop
    }

    func delete(_ shop: CoffeeShopRepositoryDTO) throws {
        storedShops.removeValue(forKey: shop.id)
    }

    func find(by id: String) throws -> CoffeeShopRepositoryDTO? {
        return storedShops[id]
    }
}
