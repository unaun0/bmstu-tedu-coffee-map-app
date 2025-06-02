//
//  FavoritiesUseCase.swift
//  CoffeeMap
//
//  Created by Козлов Павел on 02.06.2025.
//

import Foundation

final class FavoritiesUseCase {
    private let locationService: LocationServiceInput
    private let apiService: CoffeeShopAPIServiceInput
    private let imageLoader: ImageLoaderInput
    private let distanceService: DistanceServiceInput
    private let repository: CoffeeShopRepositoryInput

    init(
        locationService: LocationServiceInput,
        apiService: CoffeeShopAPIServiceInput,
        imageLoader: ImageLoaderInput,
        distanceService: DistanceServiceInput,
        repository: CoffeeShopRepositoryInput
    ) {
        self.locationService = locationService
        self.apiService = apiService
        self.imageLoader = imageLoader
        self.distanceService = distanceService
        self.repository = repository
    }
}

// MARK: - FavoritiesUseCaseInput

extension FavoritiesUseCase: FavoritiesUseCaseInput {
    func fetchCoffeeShops(
        updateLocation: Bool
    ) async throws -> [CoffeeShopEntity] {
        
        let likedId = try repository.fetchAll().map { $0.id }
        var shops: [CoffeeShopEntity] = []
        for id in likedId {
            shops.append(
                try await apiService.fetchShopDetails(
                    id: id
                )
            )
        }
        let coordinate =
            try await
            (updateLocation
            ? locationService.refreshLocation()
            : locationService.getCurrentLocation())
        
        try await withThrowingTaskGroup(of: (Int, Data?).self) { group in
            for index in shops.indices {
                let shopCoord = convertCoordinateToCLLocationCoordinate2D(
                    Coordinate(
                        latitude: shops[index].location.latitude,
                        longitude: shops[index].location.longitude
                    )
                )
                shops[index].distance = distanceService.calculateDistance(
                    from: coordinate,
                    to: shopCoord
                )
                if (try? repository.find(by: shops[index].id)) != nil {
                    shops[index].isLiked = true
                } else {
                    shops[index].isLiked = false
                }
                guard let firstPhoto = shops[index].photos.first else {
                    continue
                }
                group.addTask {
                    let data = try? await self.imageLoader.load(
                        from: firstPhoto.url)
                    return (index, data)
                }
            }
            for try await (index, data) in group {
                guard let data = data else { continue }
                var photos = shops[index].photos
                var firstPhoto = photos[0]
                firstPhoto.data = data
                photos[0] = firstPhoto
                shops[index].photos = photos
            }
        }
        return shops
    }

    func updateLikeStatus(id: String, isLiked: Bool) async throws {
        if let existingShop = try repository.find(by: id) {
            if !isLiked {
                try repository.delete(existingShop)
            }
        } else {
            if isLiked {
                try repository.save(
                    CoffeeShopRepositoryDTO(
                        id: id,
                        createdAt: .now
                    )
                )
            }
        }
    }
    
    func fetchCoffeeShop(id: String) async throws -> CoffeeShopEntity {
        var shop = try await apiService.fetchShopDetails(id: id)
        shop.photos = try await withThrowingTaskGroup(of: (Int, Data?).self) { group in
            for (index, photo) in shop.photos.enumerated() {
                group.addTask {
                    let data = try? await self.imageLoader.load(from: photo.url)
                    return (index, data)
                }
            }
            var photos = shop.photos
            for try await (index, data) in group {
                if let data = data {
                    var photo = photos[index]
                    photo.data = data
                    photos[index] = photo
                }
            }
            return photos
        }
        return shop
    }
}
