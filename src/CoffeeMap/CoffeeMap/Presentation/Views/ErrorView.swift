//
//  ErrorView.swift
//  CoffeeMap
//
//  Created by Цховребова Яна on 02.06.2025.
//

import UIKit

final class ErrorView: UIView {
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = UIColor(named: "CoffeeText")
        return iv
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(
            ofSize: 20,
            weight: .semibold
        )
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor(named: "CoffeeText")
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(
            ofSize: 16,
            weight: .regular
        )
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor(named: "CoffeeText")
        return label
    }()
    
    private let retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Повторить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = UIColor(named: "CoffeePrimary")
        button.setTitleColor(UIColor(named: "CoffeePrimaryText"), for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    var onRetry: (() -> Void)?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        backgroundColor = UIColor(named: "CoffeeBackground")
        retryButton.addTarget(
            self,
            action: #selector(retryTapped),
            for: .touchUpInside
        )
        
        let stackView = UIStackView(
            arrangedSubviews: [
                imageView,
                titleLabel,
                messageLabel,
                retryButton
            ]
        )
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            
            imageView.heightAnchor.constraint(equalToConstant: 80),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            
            retryButton.heightAnchor.constraint(equalToConstant: 44),
            retryButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    // MARK: - Configuration
    
    func configure(with model: ErrorViewModel) {
        titleLabel.text = model.title
        messageLabel.text = model.message
        retryButton.isHidden = !model.canRetry
        
        switch model.type {
        case .network:
            imageView.image = UIImage(systemName: "wifi.slash")
        case .location:
            imageView.image = UIImage(systemName: "location.slash")
        case .generic:
            imageView.image = UIImage(systemName: "exclamationmark.triangle")
        }
    }
    
    // MARK: - Actions
    
    @objc private func retryTapped() {
        onRetry?()
    }
}
