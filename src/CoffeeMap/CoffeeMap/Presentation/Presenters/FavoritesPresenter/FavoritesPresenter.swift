//
//  FavoritesPresenter.swift
//  CoffeeMap
//
//  Created by Козлов Павел on 02.06.2025.
//
import UIKit

final class FavoritesPresenter {
    weak var view: FavoritesViewProtocol?
    private var currentPage = 1
    private var isLoading = false
    private var allLoaded = false
    private let useCase: FavoritiesUseCaseInput

    init(
        useCase: FavoritiesUseCaseInput
    ) {
        self.useCase = useCase
    }
}

// MARK: - FavoritesPresenterInput

extension FavoritesPresenter: FavoritesPresenterInput {
    func updateLikeStatus(id: String, isLiked: Bool) {
        Task { [weak self] in
            do {
                try await self?.useCase.updateLikeStatus(
                    id: id, isLiked: isLiked)
            } catch {
                DispatchQueue.main.async {
                    self?.view?.showError(error)
                }
            }
        }
    }
    
    func viewDidLoad() {
        refreshData()
    }
    
    func toggleFavorite(id: String) {
        print("toggleFavorite(id: String)")
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
    
    func coffeeShopDetails(
        id: String,
        completion: @escaping (CoffeeShopDetailViewModel?) -> Void
    ) {
        Task {
            do {
                let shop = try await useCase.fetchCoffeeShop(id: id)
                let imageDataArray = shop.photos.map { $0.data }
                let formattedRating =
                    shop.rating != nil
                    ? String(format: "%.1f", shop.rating ?? 0.0)
                    : nil

                let formattedWorkingHours = shop.workingHours.mapValues {
                    workingTime in
                    (
                        startTime: workingTime.startTime,
                        endTime: workingTime.endTime
                    )
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
                    completion(viewModel)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}

// MARK: - loadPage

extension FavoritesPresenter {
    private func loadPage(page: Int, reset: Bool) {
        isLoading = true
        DispatchQueue.main.async { [weak self] in
            self?.view?.showLoading(true)
        }
        
        Task {
            do {
                let newShops = try await useCase.fetchCoffeeShops(
                    updateLocation: reset)
                if newShops.isEmpty {
                    allLoaded = true
                } else {
                    currentPage += 1
                }
                let viewModels = newShops.map { shop -> CoffeeShopViewModel in
                    let imageData = shop.photos.first?.data
                    let distanceString: String?
                    if let distance = shop.distance {
                        if distance < 1 {
                            let meters = Int(distance * 1000)
                            distanceString = "\(meters) м"
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

                DispatchQueue.main.async { [weak self] in
                    self?.view?.appendCoffeeShops(viewModels)
                    self?.view?.showLoading(false)
                    self?.isLoading = false
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    self?.view?.showError(error)
                    self?.view?.showLoading(false)
                    self?.isLoading = false
                }
            }
        }
    }
}




//final class FavoritesPresenter: FavoritesPresenterInput {
//    // MARK: - Properties
//    weak var view: FavoritesPresenterOutput?
//    private let repository: FavoritesRepositoryProtocol
//    private let apiService: CoffeeShopAPIServiceInput
//    private let imageLoader: ImageLoader
//    private var currentPage = 1
//    private var isLoading = false
//    private let useCase: FavoritiesUseCaseInput
//
//    // MARK: - Initialization
//    init(
//        repository: FavoritesRepositoryProtocol = FavoritesRepository.shared,
//        apiService: CoffeeShopAPIServiceInput,
//        imageLoader: ImageLoader,
//        useCase: FavoritiesUseCaseInput
//    ) {
//        self.repository = repository
//        self.apiService = apiService
//        self.imageLoader = imageLoader
//        self.useCase = useCase
//    }
//    
//    // MARK: - Public Methods
//    func viewDidLoad() {
//        currentPage = 1
//        loadFavorites(page: currentPage)
//    }
//    
//    func loadNextPage() {
//        guard !isLoading else { return }
//        currentPage += 1
//        loadFavorites(page: currentPage)
//    }
//    
//    func toggleFavorite(id: String) {
//        repository.isFavorite(id: id)
//            ? repository.removeFavorite(id: id)
//            : repository.addFavorite(id: id)
//        
//        view?.updateLikeStatus(id: id, isLiked: repository.isFavorite(id: id))
//    }
//    
////    func coffeeShopDetails(
////        id: String,
////        completion: @escaping (CoffeeShopDetailViewModel?) -> Void
////    ) {
////        Task {
////            do {
////                let shop = try await useCase.fetchCoffeeShop(id: id)
////                let imageDataArray = shop.photos.map { $0.data }
////                let formattedRating =
////                    shop.rating != nil
////                    ? String(format: "%.1f", shop.rating ?? 0.0)
////                    : nil
////
////                let formattedWorkingHours = shop.workingHours.mapValues {
////                    workingTime in
////                    (
////                        startTime: workingTime.startTime,
////                        endTime: workingTime.endTime
////                    )
////                }
////
////                let viewModel = CoffeeShopDetailViewModel(
////                    id: shop.id,
////                    name: shop.name,
////                    description: shop.description,
////                    rating: formattedRating,
////                    images: imageDataArray,
////                    address: shop.address,
////                    phone: shop.phone,
////                    website: shop.website,
////                    workingHours: formattedWorkingHours
////                )
////
////                DispatchQueue.main.async {
////                    completion(viewModel)
////                }
////            } catch {
////                DispatchQueue.main.async {
////                    completion(nil)
////                }
////            }
////        }
////    }
//    
//    // MARK: - Private Methods
//    
//    private func loadFavorites(page: Int)
//    
//    
//    
//    
////    private func loadFavorites(page: Int) {
////        guard !isLoading else { return }
////        
////        isLoading = true
////        view?.showLoading(true)
////        
////        Task {
////            do {
////                let favorites = repository.getFavorites()
////                let shops = try await apiService.fetchShops(lat: nil, lon: nil, page: page)
////                let favoriteShops = shops.filter { favorites.contains($0.id) }
////                
////                // Параллельная загрузка изображений
//////                async let imageLoads = favoriteShops.concurrentMap { shop in
//////                    (shop.id, try? await self.imageLoader.loadImage(from: shop.imageURL))
//////                }
////                async let imageLoads = favoriteShops.concurrentMap { shop in
////                    (shop.id, try? await self.imageLoader.load(from: shop.photos.first?.url))
////                }
////                
////                
////                let loadedImages = await imageLoads
////                let imagesDict = Dictionary(uniqueKeysWithValues: loadedImages)
////                
////                let viewModels = favoriteShops.map { shop in
////                    shop.toViewModel(
////                        image: imagesDict[shop.id] ?? nil,
////                        isLiked: true
////                    )
////                }
////                
////                DispatchQueue.main.async { [weak self] in
////                    guard let self = self else { return }
////                    self.isLoading = false
////                    self.view?.showLoading(false)
////                    
////                    if page == 1 {
////                        self.view?.displayCoffeeShops(viewModels)
////                    } else {
////                        self.view?.appendCoffeeShops(viewModels)
////                    }
////                }
////            } catch {
////                DispatchQueue.main.async { [weak self] in
////                    self?.isLoading = false
////                    self?.view?.showLoading(false)
////                    self?.view?.showError(error)
////                    print("Error loading favorites: \(error)")
////                }
////            }
////        }
////    }
//}
//
//// Вспомогательное расширение для параллельных операций
//extension Sequence {
//    func concurrentMap<T>(
//        _ transform: @escaping (Element) async throws -> T
//    ) async rethrows -> [T] {
//        let tasks = map { element in
//            Task {
//                try await transform(element)
//            }
//        }
//        
//        return try await tasks.asyncMap { task in
//            try await task.value
//        }
//    }
//    
//    private func asyncMap<T>(
//        _ transform: (Element) async throws -> T
//    ) async rethrows -> [T] {
//        var result = [T]()
//        for element in self {
//            try await result.append(transform(element))
//        }
//        return result
//    }
//}
