//
//  ViewController.swift
//  CoffeeMap
//
//  Created by Цховребова Яна on 21.05.2025.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    // MARK: - Properties
    
    private let coordinator: TabBarRouterInput
    
    // MARK: - Init
    
    init(coordinator: TabBarRouterInput) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = coordinator.viewControllers
        setupView()
    }
}

// MARK: - Appearance Configuration

private extension MainTabBarController {
    func setupView() {
        view.backgroundColor = Constants.backgroundColor
        tabBar.tintColor = Constants.tintColor
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Constants.backgroundColor
        appearance.shadowColor = Constants.shadowColor?.withAlphaComponent(0.5)
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}

// MARK: - Constants

private extension MainTabBarController {
    enum Constants {
        static let tintColor = UIColor(named: "CoffeeText")
        static let shadowColor = UIColor(named: "CoffeeText")
        static let backgroundColor = UIColor(named: "CoffeeBackground")
    }
}
