//
//  FavoritesTab.swift
//  CoffeeMap
//
//  Created by Цховребова Яна on 23.05.2025.
//

import UIKit

struct FavoritesTab {
    private let tag: Int

    init(tag: Int) {
        self.tag = tag
    }
}

// MARK: - TabItem

extension FavoritesTab: TabItem {
    var viewController: UIViewController {
        UINavigationController(
            rootViewController: FavoritesViewController()
        )
    }

    var tabBarItem: UITabBarItem {
        UITabBarItem(
            title: Constants.title,
            image: Constants.image,
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
