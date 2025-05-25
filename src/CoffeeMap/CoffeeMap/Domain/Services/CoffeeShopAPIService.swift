//
//  CoffeeShopAPIService.swift
//  CoffeeMap
//
//  Created by Цховребова Яна on 23.05.2025.
//

import Foundation

final class CoffeeShopAPIService {
    private let networkClient: NetworkClientInput
    
    init(networkClient: NetworkClientInput) {
        self.networkClient = networkClient
    }
}

// MARK: - CoffeeShopAPIServiceInput

extension CoffeeShopAPIService: CoffeeShopAPIServiceInput {
    func fetchShops(
        lat: Double?,
        lon: Double?,
        page: Int?
    ) async throws -> [CoffeeShopEntity] {
        try await withCheckedThrowingContinuation { continuation in
            networkClient.request(
                CoffeeShopsAPIRouter.getCoffeeShops(
                    page: page,
                    lat: lat,
                    lon: lon
                )
            ) { (result: Result<[CoffeeShopsAPIResponseDTO], NetworkClientError>) in
                switch result {
                case .success(let dtos):
                    continuation.resume(
                        returning: dtos.map { $0.toEntity() }
                    )
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func fetchShopDetails(id: String) async throws -> CoffeeShopEntity {
        try await withCheckedThrowingContinuation { continuation in
            networkClient.request(
                CoffeeShopsAPIRouter.getCoffeeShop(id: id)
            ) { (result: Result<CoffeeShopsAPIResponseDTO, NetworkClientError>) in
                switch result {
                case .success(let dto):
                    continuation.resume(returning: dto.toEntity())
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
