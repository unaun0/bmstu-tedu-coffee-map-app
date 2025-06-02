//
//  AllCoffeeShopsUseCaseMock.swift
//  CoffeeMap
//
//  Created by Цховребова Яна on 03.06.2025.
//

import Foundation

@testable import CoffeeMap

final class AllCoffeeShopsUseCaseMock: AllCoffeeShopsUseCaseInput {
    var fetchCoffeeShopsResult: Result<[CoffeeShopEntity], Error> = .success([])
    var updateLikeStatusError: Error? = nil
    var fetchCoffeeShopResult: Result<CoffeeShopEntity, Error>!

    private(set) var fetchCoffeeShopsCalledWith: (page: Int?, updateLocation: Bool)?
    private(set) var updateLikeStatusCalledWith: (id: String, isLiked: Bool)?
    private(set) var fetchCoffeeShopCalledWith: String?
    
    func fetchCoffeeShops(page: Int?, updateLocation: Bool) async throws -> [CoffeeShopEntity] {
        fetchCoffeeShopsCalledWith = (page, updateLocation)
        switch fetchCoffeeShopsResult {
        case .success(let shops):
            return shops
        case .failure(let error):
            throw error
        }
    }
    
    func updateLikeStatus(id: String, isLiked: Bool) async throws {
        updateLikeStatusCalledWith = (id, isLiked)
        if let error = updateLikeStatusError {
            throw error
        }
    }
    
    func fetchCoffeeShop(id: String) async throws -> CoffeeShopEntity {
        fetchCoffeeShopCalledWith = id
        switch fetchCoffeeShopResult {
        case .success(let shop):
            return shop
        case .failure(let error):
            throw error
        case .none:
            fatalError("fetchCoffeeShopResult must be set before calling fetchCoffeeShop")
        }
    }
}
