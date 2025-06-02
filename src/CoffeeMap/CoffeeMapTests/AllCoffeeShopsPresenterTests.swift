//
//  AllCoffeeShopsPresenterTests.swift
//  CoffeeMap
//
//  Created by Цховребова Яна on 03.06.2025.
//

import XCTest
@testable import CoffeeMap

final class AllCoffeeShopsPresenterTests: XCTestCase {

    var presenter: AllCoffeeShopsPresenter!
    var useCaseMock: AllCoffeeShopsUseCaseMock!
    var viewMock: AllCoffeeShopsViewMock!

    override func setUpWithError() throws {
        useCaseMock = AllCoffeeShopsUseCaseMock()
        viewMock = AllCoffeeShopsViewMock()
        presenter = AllCoffeeShopsPresenter(useCase: useCaseMock)
        presenter.view = viewMock
    }

    override func tearDownWithError() throws {
        presenter = nil
        useCaseMock = nil
        viewMock = nil
    }

    func test_viewDidLoad_callsRefreshData_andLoadsFirstPage() async throws {
        let coffeeShop = CoffeeShopEntity.mock(id: "1")
        useCaseMock.fetchCoffeeShopsResult = .success([coffeeShop])
        presenter.viewDidLoad()
        
        try await Task.sleep(nanoseconds: 200_000_000)
        
        XCTAssertEqual(useCaseMock.fetchCoffeeShopsCalledWith?.page, 1)
        XCTAssertTrue(viewMock.showLoadingCalledWith.first == true)
        XCTAssertTrue(viewMock.appendCoffeeShopsCalledWith.first?.first?.id == coffeeShop.id)
        XCTAssertEqual(viewMock.showLoadingCalledWith.last, false)
    }

    func test_loadNextPage_loadsNextPageWhenNotLoadingAndNotAllLoaded() async throws {
        let firstShop = CoffeeShopEntity.mock(id: "1")
        let secondShop = CoffeeShopEntity.mock(id: "2")
        useCaseMock.fetchCoffeeShopsResult = .success([firstShop])
        presenter.viewDidLoad()
        
        try await Task.sleep(nanoseconds: 200_000_000)
        
        useCaseMock.fetchCoffeeShopsResult = .success([secondShop])
        presenter.loadNextPage()
        
        try await Task.sleep(nanoseconds: 200_000_000)

        XCTAssertEqual(useCaseMock.fetchCoffeeShopsCalledWith?.page, 2)
        XCTAssertTrue(viewMock.appendCoffeeShopsCalledWith.count > 1)
        XCTAssertEqual(viewMock.appendCoffeeShopsCalledWith.last?.first?.id, secondShop.id)
    }

    func test_updateLikeStatus_callsUseCase_andHandlesError() async throws {
        let error = NSError(domain: "Test", code: 0)
        useCaseMock.updateLikeStatusError = error
        presenter.updateLikeStatus(id: "id123", isLiked: true)
        
        try await Task.sleep(nanoseconds: 200_000_000)

        XCTAssertEqual(useCaseMock.updateLikeStatusCalledWith?.id, "id123")
        XCTAssertEqual(useCaseMock.updateLikeStatusCalledWith?.isLiked, true)
        XCTAssertEqual(viewMock.showErrorCalledWith.count, 1)
    }

    func test_coffeeShopDetails_success_callsCompletionWithViewModel() throws {
        let shop = CoffeeShopEntity.mock(id: "1", name: "Test Shop", rating: 4.5)
        useCaseMock.fetchCoffeeShopResult = .success(shop)
        let expectation = expectation(description: "Completion called")
        presenter.coffeeShopDetails(id: "1") { result in
            switch result {
            case .success(let viewModel):
                XCTAssertEqual(viewModel.id, shop.id)
                XCTAssertEqual(viewModel.name, shop.name)
                XCTAssertEqual(viewModel.rating, "4.5")
            case .failure:
                XCTFail("Expected success")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func test_coffeeShopDetails_failure_callsCompletionWithError() throws {
        let error = NSError(domain: "Test", code: 1)
        useCaseMock.fetchCoffeeShopResult = .failure(error)
        let expectation = expectation(description: "Completion called")
        presenter.coffeeShopDetails(id: "1") { result in
            switch result {
            case .success:
                XCTFail("Expected failure")
            case .failure(let err as NSError):
                XCTAssertEqual(err.domain, error.domain)
                XCTAssertEqual(err.code, error.code)
            default:
                XCTFail("Unexpected error type")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
}

private extension CoffeeShopEntity {
    static func mock(
        id: String,
        name: String = "Coffee Shop",
        address: String = "Some Address",
        description: String? = "Description",
        phone: String? = nil,
        website: String? = nil,
        rating: Double? = nil,
        workingHours: [String: WorkingTime] = [:],
        location: Location = Location(latitude: 0.0, longitude: 0.0),
        photos: [(url: String, data: Data?)] = [(url: "", data: Data())],
        distance: Double? = nil,
        isLiked: Bool = false
    ) -> CoffeeShopEntity {
        CoffeeShopEntity(
            id: id,
            name: name,
            address: address,
            description: description,
            phone: phone,
            website: website,
            rating: rating,
            workingHours: workingHours,
            location: location,
            photos: photos,
            distance: distance,
            isLiked: isLiked
        )
    }
}
