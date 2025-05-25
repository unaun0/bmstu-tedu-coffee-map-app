//
//  MainTabBarRouter.swift
//  CoffeeMap
//
//  Created by Цховребова Яна on 23.05.2025.
//

import UIKit

final class MainTabBarRouter {
    private let tabs: [TabItem]

    init(tabs: [TabItem]) {
        self.tabs = tabs
    }
}

// MARK: - TabBarCoordinatorInput

extension MainTabBarRouter: TabBarRouterInput {
    var viewControllers: [UIViewController] {
        tabs.map {
            let vc = $0.viewController
            vc.tabBarItem = $0.tabBarItem
            return vc
        }
    }
}
