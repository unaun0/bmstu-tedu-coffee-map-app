//
//  CoffeeShopsTableViewCell.swift
//  CoffeeMap
//
//  Created by Цховребова Яна on 23.05.2025.
//

import UIKit

final class CoffeeShopsTableViewCell: UITableViewCell {

    // MARK: - Callback

    var onLikeButtonTapped: ((Bool) -> Void)?

    // MARK: - Subviews

    private let coffeeShopView = CoffeeShopView(
        image: nil,
        name: ""
    )

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup

extension CoffeeShopsTableViewCell {
    fileprivate func setupView() {
        contentView.addSubview(coffeeShopView)
        selectionStyle = .none
        backgroundColor = .clear
    }

    fileprivate func setupConstraints() {
        coffeeShopView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coffeeShopView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Constants.sidePadding
            ),
            coffeeShopView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Constants.sidePadding
            ),
            coffeeShopView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Constants.verticalPadding
            ),
            coffeeShopView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -Constants.verticalPadding
            ),
            coffeeShopView.heightAnchor.constraint(
                greaterThanOrEqualToConstant: Constants.minHeight
            ),
        ])
    }
}

// MARK: - Configuration

extension CoffeeShopsTableViewCell {
    func configure(
        name: String,
        image: UIImage? = nil,
        liked: Bool = false,
        distance: String? = nil,
        description: String? = nil
    ) {
        coffeeShopView.configure(
            image: image,
            name: name,
            description: description,
            distance: distance,
            liked: liked
        )

        coffeeShopView.onLikeButtonTapped = { [weak self] isLiked in
            self?.onLikeButtonTapped?(isLiked)
        }
    }
}

// MARK: - Constants

extension CoffeeShopsTableViewCell {
    fileprivate enum Constants {
        static let sidePadding: CGFloat = 16
        static let verticalPadding: CGFloat = 8
        static let minHeight: CGFloat = 60
    }
}
