//
//  DIContainer.swift
//  CoffeeMap
//
//  Created by Цховребова Яна on 03.06.2025.
//

import Swinject

final class DIContainer {
    static let shared = DIContainer()
    
    let container: Container

    private init() {
        container = Container()
        registerDependencies()
    }

    private func registerDependencies() {
        // MARK: - Core
        container.register(NetworkClient.self) { _ in
            NetworkClient()
        }.inObjectScope(.container)

        container.register(ImageLoader.self) { r in
            ImageLoader(networkClient: r.resolve(NetworkClient.self)!)
        }.inObjectScope(.container)

        container.register(LocationService.self) { _ in
            LocationService()
        }.inObjectScope(.container)

        container.register(DistanceService.self) { _ in
            DistanceService()
        }.inObjectScope(.container)

        container.register(CDCoffeeShopRepository.self) { _ in
            CDCoffeeShopRepository()
        }.inObjectScope(.container)

        container.register(CoffeeShopAPIService.self) { r in
            CoffeeShopAPIService(networkClient: r.resolve(NetworkClient.self)!)
        }.inObjectScope(.container)

        // MARK: - UseCases
        
        container.register(AllCoffeeShopsUseCase.self) { r in
            AllCoffeeShopsUseCase(
                locationService: r.resolve(LocationService.self)!,
                apiService: r.resolve(CoffeeShopAPIService.self)!,
                imageLoader: r.resolve(ImageLoader.self)!,
                distanceService: r.resolve(DistanceService.self)!,
                repository: r.resolve(CDCoffeeShopRepository.self)!
            )
        }

        container.register(FavoritiesUseCase.self) { r in
            FavoritiesUseCase(
                locationService: r.resolve(LocationService.self)!,
                apiService: r.resolve(CoffeeShopAPIService.self)!,
                imageLoader: r.resolve(ImageLoader.self)!,
                distanceService: r.resolve(DistanceService.self)!,
                repository: r.resolve(CDCoffeeShopRepository.self)!
            )
        }

        // MARK: - Presenters
        
        container.register(AllCoffeeShopsPresenter.self) { r in
            let presenter = AllCoffeeShopsPresenter(
                useCase: r.resolve(AllCoffeeShopsUseCase.self)!
            )
            return presenter
        }

        container.register(FavoritesPresenter.self) { r in
            let presenter = FavoritesPresenter(
                useCase: r.resolve(FavoritiesUseCase.self)!
            )
            return presenter
        }

        // MARK: - ViewControllers
        
        container.register(AllCoffeeShopsViewController.self) { r in
            let presenter = r.resolve(AllCoffeeShopsPresenter.self)!
            let vc = AllCoffeeShopsViewController(presenter: presenter)
            presenter.view = vc
            return vc
        }

        container.register(FavoritesViewController.self) { r in
            let presenter = r.resolve(FavoritesPresenter.self)!
            let vc = FavoritesViewController(presenter: presenter)
            presenter.view = vc
            return vc
        }
    }
}
