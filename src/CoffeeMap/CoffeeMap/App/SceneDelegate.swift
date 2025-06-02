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

        let container = DIContainer.shared.container

        guard
            let allCoffeeVC = container.resolve(AllCoffeeShopsViewController.self),
            let favoritesVC = container.resolve(FavoritesViewController.self)
        else {
            fatalError("DIContainer: Failed to resolve ViewControllers")
        }

        let allCoffeeTab = AllCoffeeTab(tag: 0, viewController: allCoffeeVC)
        let favoritesTab = FavoritesTab(tag: 1, viewController: favoritesVC)

        let coordinator = MainTabBarRouter(tabs: [allCoffeeTab, favoritesTab])
        self.window?.rootViewController = MainTabBarController(
            coordinator: coordinator
        )
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
