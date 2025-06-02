//
//  FavoritesTab.swift
//  CoffeeMap
//
//  Created by Цховребова Яна on 23.05.2025.
//

import UIKit

struct FavoritesTab {
    private let tag: Int
    
    private weak var viewControllerRef: FavoritesViewController?
    
    init(tag: Int, viewController: FavoritesViewController) {
        self.tag = tag
        self.viewControllerRef = viewController
    }
}

// MARK: - TabItem

extension FavoritesTab: TabItem {
    var viewController: UIViewController {
        guard let vc = viewControllerRef else {
            return UIViewController()
        }
        return UINavigationController(rootViewController: vc)
    }

    var tabBarItem: UITabBarItem {
        UITabBarItem(
            title: FavoritesTab.Constants.title,
            image: FavoritesTab.Constants.image,
            tag: tag
        )
    }
}

// MARK: - Constants

private extension FavoritesTab {
    enum Constants {
        static let title = "Избранные"
        static let image = UIImage(systemName: "heart")
    }
}
