//
//  AllCoffeeShopsPresenter.swift
//  CoffeeMap
//
//  Created by Цховребова Яна on 23.05.2025.
//

import Foundation

final class AllCoffeeShopsPresenter {
    private var currentPage = 1
    private var isLoading = false
    private var allLoaded = false
    private let useCase: AllCoffeeShopsUseCaseInput

    weak var view: AllCoffeeShopsViewProtocol?

    init(
        useCase: AllCoffeeShopsUseCaseInput
    ) {
        self.useCase = useCase
    }
}

// MARK: - AllCoffeeShopsPresenterProtocol

extension AllCoffeeShopsPresenter: AllCoffeeShopsPresenterInput {
    func viewDidLoad() {
        refreshData()
    }

    func refreshData() {
        currentPage = 1
        allLoaded = false
        loadPage(page: currentPage, reset: true)
    }

    func loadNextPage() {
        guard !isLoading, !allLoaded else { return }
        loadPage(page: currentPage, reset: false)
    }

    func updateLikeStatus(id: String, isLiked: Bool) {
        Task { [weak self] in
            do {
                try await self?.useCase.updateLikeStatus(
                    id: id, isLiked: isLiked)
            } catch {
                DispatchQueue.main.async {
                    self?.view?.showError(ErrorMapper.map(error))
                }
            }
        }
    }

    func coffeeShopDetails(
        id: String,
        completion: @escaping (Result<CoffeeShopDetailViewModel, Error>) -> Void
    ) {
        Task {
            do {
                let shop = try await useCase.fetchCoffeeShop(id: id)
                let imageDataArray = shop.photos.map { $0.data }
                let formattedRating = shop.rating.map { String(format: "%.1f", $0) }

                let formattedWorkingHours = shop.workingHours.mapValues {
                    (startTime: $0.startTime, endTime: $0.endTime)
                }

                let viewModel = CoffeeShopDetailViewModel(
                    id: shop.id,
                    name: shop.name,
                    description: shop.description,
                    rating: formattedRating,
                    images: imageDataArray,
                    address: shop.address,
                    phone: shop.phone,
                    website: shop.website,
                    workingHours: formattedWorkingHours
                )

                DispatchQueue.main.async {
                    completion(.success(viewModel))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    private func loadPage(page: Int, reset: Bool) {
        isLoading = true
        DispatchQueue.main.async { [weak self] in
            self?.view?.showLoading(true)
        }
        Task {
            do {
                let newShops = try await useCase.fetchCoffeeShops(
                    page: page,
                    updateLocation: reset
                )
                let viewModels = newShops.map { shop -> CoffeeShopViewModel in
                    let imageData = shop.photos.first?.data
                    let distanceString: String?
                    if let distance = shop.distance {
                        if distance < 1 {
                            distanceString = "\(Int(distance * 1000)) м"
                        } else {
                            distanceString = String(format: "%.1f км", distance)
                        }
                    } else {
                        distanceString = nil
                    }
                    return CoffeeShopViewModel(
                        id: shop.id,
                        image: imageData,
                        name: shop.name,
                        distance: distanceString,
                        description: shop.description,
                        isLiked: shop.isLiked
                    )
                }
                if newShops.isEmpty {
                    allLoaded = true
                } else {
                    currentPage += 1
                }
                DispatchQueue.main.async { [weak self] in
                    self?.view?.appendCoffeeShops(viewModels)
                    self?.view?.showLoading(false)
                    self?.isLoading = false
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    self?.view?.showError(ErrorMapper.map(error))
                    self?.view?.showLoading(false)
                    self?.isLoading = false
                }
            }
        }
    }
}
