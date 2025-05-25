//
//  CoffeeShopDetailViewController.swift
//  CoffeeMap
//
//  Created by Цховребова Яна on 24.05.2025.
//

import UIKit

final class CoffeeDetailViewController: UIViewController {
    private let closeButton = UIButton(type: .system)
    private var detailViewModel: CoffeeShopDetailViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func configure(with viewModel: CoffeeShopDetailViewModel) {
        self.detailViewModel = viewModel
    }
    
    private func setupView() {
        view.backgroundColor = UIColor(named: "CoffeeBackground")?
            .withAlphaComponent(0.99)

        // Кнопка закрытия с крестиком
        closeButton.setTitle("✕", for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(
            ofSize: 28, weight: .bold)
        closeButton.tintColor = UIColor(named: "CoffeeText")?
            .withAlphaComponent(0.5)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(
            self, action: #selector(closeTapped), for: .touchUpInside)
        view.addSubview(closeButton)

        // Констрейнты
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
        ])
    }

    @objc private func closeTapped() {
        dismiss(animated: true)
    }
}
