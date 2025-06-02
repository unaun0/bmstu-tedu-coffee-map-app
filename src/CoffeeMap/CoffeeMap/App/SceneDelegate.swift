//
//  SceneDelegate.swift
//  CoffeeMap
//
//  Created by Цховребова Яна on 21.05.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        let repository = CDCoffeeShopRepository()
        let networkClient = NetworkClient()
        let apiService = CoffeeShopAPIService(networkClient: networkClient)
        let imageLoader = ImageLoader(networkClient: networkClient)
        let locationService = LocationService()
        let distanceService = DistanceService()
        
        let allCofeeShopsUseCase = AllCoffeeShopsUseCase(
            locationService: locationService,
            apiService: apiService,
            imageLoader: imageLoader,
            distanceService: distanceService,
            repository: repository
        )
        
        let presenter = AllCoffeeShopsPresenter(
            useCase: allCofeeShopsUseCase)
        let allCoffeeVC = AllCoffeeShopsViewController(
            presenter: presenter)
        presenter.view = allCoffeeVC

        let allCoffeeTab = AllCoffeeTab(
            tag: 0,
            viewController: allCoffeeVC
        )
        
        let favoritiesUseCase = FavoritiesUseCase(
            locationService: locationService,
            apiService: apiService,
            imageLoader: imageLoader,
            distanceService: distanceService,
            repository: repository
        )
        let favoritesPresenter = FavoritesPresenter(
            useCase: favoritiesUseCase)
        let favoritesVC = FavoritesViewController(
            presenter: favoritesPresenter)
        favoritesPresenter.view = favoritesVC
        
        let favoritesTab = FavoritesTab(
            tag: 1,
            viewController: favoritesVC
        )
        
        let coordinator = MainTabBarRouter(tabs: [allCoffeeTab, favoritesTab])
        self.window?.rootViewController = MainTabBarController(coordinator: coordinator)
        self.window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}
