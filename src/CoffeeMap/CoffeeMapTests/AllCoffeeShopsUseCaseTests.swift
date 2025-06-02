//
//  AllCoffeeShopsUseCaseTests.swift
//  CoffeeMap
//
//  Created by Цховребова Яна on 03.06.2025.
//

import XCTest

@testable import CoffeeMap

final class AllCoffeeShopsUseCaseTests: XCTestCase {
    var useCase: AllCoffeeShopsUseCase!
    var mockLocation: MockLocationService!
    var mockAPI: MockAPIService!
    var mockImageLoader: MockImageLoader!
    var mockDistance: MockDistanceService!
    var mockRepository: MockRepository!

    override func setUpWithError() throws {
        mockLocation = MockLocationService()
        mockAPI = MockAPIService()
        mockImageLoader = MockImageLoader()
        mockDistance = MockDistanceService()
        mockRepository = MockRepository()

        useCase = AllCoffeeShopsUseCase(
            locationService: mockLocation,
            apiService: mockAPI,
            imageLoader: mockImageLoader,
            distanceService: mockDistance,
            repository: mockRepository
        )
    }

    override func tearDownWithError() throws {
        useCase = nil
        mockLocation = nil
        mockAPI = nil
        mockImageLoader = nil
        mockDistance = nil
        mockRepository = nil
    }

    func testFetchCoffeeShops_success() async throws {
        let shop = CoffeeMap.CoffeeShopEntity(
            id: "1",
            name: "Test Cafe",
            address: "123 Main St",
            description: nil,
            phone: nil,
            website: nil,
            rating: 4.5,
            workingHours: [:],
            location: CoffeeMap.CoffeeShopEntity.Location(latitude: 55.75, longitude: 37.61),
            photos: [("url", nil)],
            distance: nil,
            isLiked: false
        )
        mockAPI.coffeeShops = [shop]

        let result = try await useCase.fetchCoffeeShops(page: nil, updateLocation: false)
        
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].id, "1")
        XCTAssertEqual(result[0].distance, 123.45)
        XCTAssertEqual(result[0].photos[0].data, Data("test".utf8))
    }

    func testFetchCoffeeShops_locationFailure() async {
        mockLocation.shouldThrow = true
        do {
            _ = try await useCase.fetchCoffeeShops(page: nil, updateLocation: true)
            XCTFail("Expected to throw")
        } catch {
            XCTAssertTrue(true)
        }
    }

    func testFetchCoffeeShops_apiFailure() async {
        mockAPI.shouldThrow = true
        do {
            _ = try await useCase.fetchCoffeeShops(page: nil, updateLocation: false)
            XCTFail("Expected to throw")
        } catch {
            XCTAssertTrue(true)
        }
    }

    func testFetchCoffeeShop_apiFailure() async {
        mockAPI.shouldThrow = true
        do {
            _ = try await useCase.fetchCoffeeShop(id: "1")
            XCTFail("Expected to throw")
        } catch {
            XCTAssertTrue(true)
        }
    }

    func testUpdateLikeStatus_addsShop() async throws {
        try await useCase.updateLikeStatus(id: "1", isLiked: true)
        let saved = try mockRepository.find(by: "1")
        XCTAssertNotNil(saved)
    }

    func testUpdateLikeStatus_addsExistingShopAgain() async throws {
        let dto = CoffeeShopRepositoryDTO(id: "1", createdAt: .now)
        try mockRepository.save(dto)
        try await useCase.updateLikeStatus(id: "1", isLiked: true)
        let saved = try mockRepository.find(by: "1")
        XCTAssertNotNil(saved)
    }

    func testUpdateLikeStatus_removesShop() async throws {
        let dto = CoffeeShopRepositoryDTO(id: "1", createdAt: .now)
        try mockRepository.save(dto)
        try await useCase.updateLikeStatus(id: "1", isLiked: false)
        let deleted = try mockRepository.find(by: "1")
        XCTAssertNil(deleted)
    }

    func testUpdateLikeStatus_removeNonExistent() async throws {
        try await useCase.updateLikeStatus(id: "1", isLiked: false)
        let result = try mockRepository.find(by: "1")
        XCTAssertNil(result)
    }
}

extension CoffeeShopEntity {
    static func mockWithPhoto(id: String) -> CoffeeShopEntity {
        return CoffeeShopEntity(
            id: id,
            name: "Mock Shop",
            address: "Some Address",
            description: "Desc",
            phone: "0000000000",
            website: "mock.com",
            rating: 4.0,
            workingHours: [:],
            location: Location(latitude: 0.0, longitude: 0.0),
            photos: [(url: "url", data: nil)],
            distance: nil,
            isLiked: false
        )
    }
}
