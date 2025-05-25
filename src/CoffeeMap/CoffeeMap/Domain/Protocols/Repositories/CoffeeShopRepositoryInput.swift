//
//  CoffeeShopRepositoryInput.swift
//  CoffeeMap
//
//  Created by Цховребова Яна on 25.05.2025.
//

protocol CoffeeShopRepositoryInput {
    func fetchAll() throws -> [CoffeeShopRepositoryDTO]
    func save(_ shop: CoffeeShopRepositoryDTO) throws
    func delete(_ shop: CoffeeShopRepositoryDTO) throws
    func find(by id: String) throws -> CoffeeShopRepositoryDTO?
}
