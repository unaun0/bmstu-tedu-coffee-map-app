//
//  TabItem.swift
//  CoffeeMap
//
//  Created by Цховребова Яна on 23.05.2025.
//

import UIKit

protocol TabItem {
    var viewController: UIViewController { get }
    var tabBarItem: UITabBarItem { get }
}
