//
//  AllCoffeeTab.swift
//  CoffeeMap
//
//  Created by Цховребова Яна on 23.05.2025.
//

import UIKit

import UIKit

struct AllCoffeeTab {
    private let tag: Int
    private weak var viewControllerRef: AllCoffeeShopsViewController?

    init(tag: Int, viewController: AllCoffeeShopsViewController) {
        self.tag = tag
        self.viewControllerRef = viewController
    }
}

// MARK: - TabItem

extension AllCoffeeTab: TabItem {
    var viewController: UIViewController {
        guard let vc = viewControllerRef else {
            return UIViewController()
        }
        return UINavigationController(rootViewController: vc)
    }

    var tabBarItem: UITabBarItem {
        UITabBarItem(
            title: AllCoffeeTab.Constants.title,
            image: AllCoffeeTab.Constants.image,
            tag: tag
        )
    }
}

// MARK: - Constants

private extension AllCoffeeTab {
    static let Constants = (
        title: "Все кофейни",
        image: UIImage(systemName: "cup.and.saucer")
    )
}
