//
//  CoffeeShopView.swift
//  CoffeeMap
//
//  Created by Цховребова Яна on 23.05.2025.
//

import UIKit

final class CoffeeShopView: UIView {
    
    // MARK: - Subviews
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.imageViewCornerRadius
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Constants.nameLabelFontSize)
        label.textColor = Constants.textColor
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()

    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(
            UIImage(
                systemName: "heart",
                withConfiguration: Constants.heartSymbolConfig
            ),
            for: .normal
        )
        button.tintColor = Constants.textColor
        button.addTarget(
            self,
            action: #selector(likeButtonTapped),
            for: .touchUpInside
        )
        return button
    }()
    
    private lazy var topStackView: UIStackView = {
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        spacer.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        let stack = UIStackView(arrangedSubviews: [nameLabel, spacer, likeButton])
        stack.spacing = Constants.topStackSpacing
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.descriptionLabelFontSize)
        label.textColor = Constants.textColor?.withAlphaComponent(Constants.descriptionLabelTextColorAplha)
        label.numberOfLines = Constants.descriptionLabelNumberOfLines
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.distanceLabelFontSize)
        label.textColor = Constants.textColor?.withAlphaComponent(Constants.distanceLabelTextColorAplha)
        label.numberOfLines = Constants.distanceLabelNumberOfLines
        label.textAlignment = .right
        return label
    }()
    
    private let rightContainerView = UIView()

    // MARK: - Properties
    
    private var isLiked: Bool = false
    
    var onLikeButtonTapped: ((Bool) -> Void)?

    // MARK: - Init

    init(
        image: UIImage?,
        name: String,
        rating: String? = nil,
        distance: String? = nil,
        description: String? = nil
    ) {
        super.init(frame: .zero)
        setupView()
        setupConstraints()
        configure(image: image, name: name, description: description, distance: distance)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup

extension CoffeeShopView {
    private func setupView() {
        backgroundColor = Constants.backgroundColor?.withAlphaComponent(Constants.backgroundColorAplha)
        layer.cornerRadius = Constants.cornerRadius
        clipsToBounds = true

        addSubview(imageView)
        addSubview(rightContainerView)

        rightContainerView.addSubview(topStackView)
        rightContainerView.addSubview(descriptionLabel)
        rightContainerView.addSubview(distanceLabel)
    }
}

// MARK: - Setup Constraints

private extension CoffeeShopView {
    func setupConstraints() {
        setupImageViewConstraints()
        setupRightContainerViewConstraints()
        setupTopStackViewConstraints()
        setupDescriptionLabelConstraints()
        setupDistanceLabelConstraints()
    }

    func setupImageViewConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.sidePadding),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.sidePadding),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.sidePadding),
            imageView.widthAnchor.constraint(equalToConstant: Constants.imageSize),
            imageView.heightAnchor.constraint(equalToConstant: Constants.imageSize)
        ])
    }

    func setupRightContainerViewConstraints() {
        rightContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rightContainerView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: Constants.sidePadding),
            rightContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.sidePadding),
            rightContainerView.topAnchor.constraint(equalTo: imageView.topAnchor),
            rightContainerView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor)
        ])
    }

    func setupTopStackViewConstraints() {
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topStackView.leadingAnchor.constraint(equalTo: rightContainerView.leadingAnchor),
            topStackView.trailingAnchor.constraint(equalTo: rightContainerView.trailingAnchor),
            topStackView.topAnchor.constraint(equalTo: rightContainerView.topAnchor),
            topStackView.heightAnchor.constraint(equalToConstant: Constants.topStackViewHeight)
        ])
    }

    func setupDescriptionLabelConstraints() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: rightContainerView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: rightContainerView.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: Constants.spacingBetweenTopAndDescription),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: distanceLabel.topAnchor, constant: -Constants.spacingBetweenDescriptionAndDistance)
        ])
    }

    func setupDistanceLabelConstraints() {
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            distanceLabel.trailingAnchor.constraint(equalTo: rightContainerView.trailingAnchor),
            distanceLabel.bottomAnchor.constraint(equalTo: rightContainerView.bottomAnchor)
        ])
    }
}

// MARK: - Configure

extension CoffeeShopView {
    func configure(
        image: UIImage? = nil,
        name: String,
        description: String? = nil,
        distance: String? = nil,
        liked: Bool = false
    ) {
        imageView.image = image
        nameLabel.text = name
        
        isLiked = liked
        updateLikeButtonAppearance()
        
        if let distance = distance, !distance.isEmpty {
            distanceLabel.text = distance
            distanceLabel.isHidden = false
        } else {
            distanceLabel.isHidden = true
        }

        if let description = description, !description.isEmpty {
            descriptionLabel.text = description
            descriptionLabel.isHidden = false
        } else {
            descriptionLabel.isHidden = true
        }
    }
}

// MARK: - Actions

extension CoffeeShopView {
    @objc private func likeButtonTapped() {
        isLiked.toggle()
        updateLikeButtonAppearance()
        onLikeButtonTapped?(isLiked)
    }

    private func updateLikeButtonAppearance() {
        likeButton.setImage(
            UIImage(
                systemName: isLiked ? "heart.fill" : "heart",
                withConfiguration: Constants.heartSymbolConfig
            ),
            for: .normal
        )
        likeButton.tintColor = isLiked ? .systemRed : Constants.textColor
    }
}

// MARK: - Constants

extension CoffeeShopView {
    private enum Constants {
        // MARK: - View
        static let textColor = UIColor(named: "CoffeeText")
        static let backgroundColor = UIColor(named: "CoffeeHighlight")
        static let backgroundColorAplha: CGFloat = 0.2
        static let cornerRadius: CGFloat = 15.0

        // MARK: - imageView
        static let imageViewCornerRadius: CGFloat = 15.0

        // MARK: - nameLabel
        static let nameLabelFontSize: CGFloat = 20.0
        static let nameLabelNumberOfLines: Int = 1

        // MARK: - likeButtonLabel
        static let heartSymbolPointSize: CGFloat = 20
        static let heartSymbolWeight: UIImage.SymbolWeight = .medium
        static let heartSymbolConfig = UIImage.SymbolConfiguration(
            pointSize: heartSymbolPointSize,
            weight: heartSymbolWeight
        )

        // MARK: - topStackView
        static let topStackSpacing: CGFloat = 8

        // MARK: - descriptionLabel
        static let descriptionLabelFontSize: CGFloat = 12.0
        static let descriptionLabelTextColorAplha: CGFloat = 0.7
        static let descriptionLabelNumberOfLines: Int = 5

        // MARK: - distanceLabel
        static let distanceLabelFontSize: CGFloat = 14.0
        static let distanceLabelTextColorAplha: CGFloat = 0.9
        static let distanceLabelNumberOfLines: Int = 1

        // MARK: - Layout constraints
        static let sidePadding: CGFloat = 12
        static let topStackViewHeight: CGFloat = 20
        static let spacingBetweenTopAndDescription: CGFloat = 8
        static let spacingBetweenDescriptionAndDistance: CGFloat = 4
        static let imageSize: CGFloat = UIScreen.main.bounds.width / 3
    }
}

