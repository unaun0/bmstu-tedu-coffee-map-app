//
//  CoffeeShopDetailViewController.swift
//  CoffeeMap
//
//  Created by Цховребова Яна on 24.05.2025.
//

import UIKit

final class CoffeeDetailViewController: UIViewController {
    private var detailViewModel: CoffeeShopDetailViewModel?
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("✕", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        button.tintColor = UIColor(named: "CoffeeText")?
            .withAlphaComponent(0.5)
        button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var scrollFrameView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alpha = 0

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var mainFrame: UIView = {
        let mainFrame = UIView()
        mainFrame.translatesAutoresizingMaskIntoConstraints = false
        return mainFrame
    }()
    
    private lazy var scrollImageView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.layer.cornerRadius = 20
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0

        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private lazy var imagesContentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "CoffeeText")
        label.font = UIFont.boldSystemFont(ofSize: 22.0)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // descriptionFrame
    private lazy var descriptionFrame: UIView = {
        let frameView = UIView()
        frameView.backgroundColor = UIColor(named: "CoffeeSecondary")
        frameView.layer.cornerRadius = 20
        
        frameView.translatesAutoresizingMaskIntoConstraints = false
        return frameView
    }()

    private lazy var descriptionHeaderLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "CoffeeText")
        label.font = UIFont.boldSystemFont(ofSize: 17.0)
        label.text = "Описание"
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "CoffeeText")
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "CoffeeText")
        label.font = UIFont.boldSystemFont(ofSize: 17.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // contactsFrame
    private lazy var contactsFrame: UIView = {
        let frameView = UIView()
        frameView.backgroundColor = UIColor(named: "CoffeeSecondary")
        frameView.layer.cornerRadius = 20
        frameView.translatesAutoresizingMaskIntoConstraints = false
        return frameView
    }()
    
    private lazy var contactsHeaderLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "CoffeeText")
        label.font = UIFont.boldSystemFont(ofSize: 17.0)
        label.text = "Контакты"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var contactsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .leading
        stack.distribution = .fill
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "CoffeeText")
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var phoneLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "CoffeeText")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var websiteLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "CoffeeText")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // timeFrame
    private lazy var timeFrame: UIView = {
        let frameView = UIView()
        frameView.backgroundColor = UIColor(named: "CoffeeSecondary")
        frameView.layer.cornerRadius = 20
        frameView.translatesAutoresizingMaskIntoConstraints = false
        return frameView
    }()
    
    private lazy var timeHeaderLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "CoffeeText")
        label.font = UIFont.boldSystemFont(ofSize: 17.0)
        label.text = "График работы"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var timeIconImage: UIImageView = {
        let imageView = UIImageView()
        
        let colorsConfig = UIImage.SymbolConfiguration(paletteColors: [UIColor(named: "CoffeePrimary")!])
        let sizeConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .bold)
        let timeImage = UIImage(systemName: "clock", withConfiguration: colorsConfig.applying(sizeConfig))
        imageView.image = timeImage
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var timeStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .leading
        stack.distribution = .fill
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .darkGray
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }

    func configure(with viewModel: CoffeeShopDetailViewModel) {
        activityIndicator.startAnimating()

        DispatchQueue.global(qos: .userInitiated).async {
            self.detailViewModel = viewModel
            
            DispatchQueue.main.async {
                self.setDataFromConfigure()
                self.scrollFrameView.alpha = 1
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    private func setupView() {
        view.backgroundColor = UIColor(named: "CoffeeBackground")?
            .withAlphaComponent(0.99)

        view.addSubview(activityIndicator)
        view.addSubview(closeButton)
        view.addSubview(scrollFrameView)
        scrollFrameView.addSubview(mainFrame)
        
        mainFrame.addSubview(scrollImageView)
        scrollImageView.addSubview(imagesContentView)
        mainFrame.addSubview(pageControl)
        mainFrame.addSubview(nameLabel)
        
        mainFrame.addSubview(descriptionFrame)
        descriptionFrame.addSubview(descriptionHeaderLabel)
        descriptionFrame.addSubview(descriptionLabel)
        descriptionFrame.addSubview(ratingLabel)

        mainFrame.addSubview(contactsFrame)
        contactsFrame.addSubview(contactsHeaderLabel)
        contactsFrame.addSubview(contactsStack)
        
        contactsStack.addArrangedSubview(addressLabel)
        contactsStack.addArrangedSubview(phoneLabel)
        contactsStack.addArrangedSubview(websiteLabel)
        
        mainFrame.addSubview(timeFrame)
        timeFrame.addSubview(timeHeaderLabel)
        timeFrame.addSubview(timeIconImage)
        timeFrame.addSubview(timeStack)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            scrollFrameView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 10),
            scrollFrameView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollFrameView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollFrameView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            mainFrame.topAnchor.constraint(equalTo: scrollFrameView.topAnchor),
            mainFrame.leadingAnchor.constraint(equalTo: scrollFrameView.leadingAnchor),
            mainFrame.trailingAnchor.constraint(equalTo: scrollFrameView.trailingAnchor),
            mainFrame.bottomAnchor.constraint(equalTo: scrollFrameView.bottomAnchor),
            mainFrame.widthAnchor.constraint(equalTo: scrollFrameView.widthAnchor),
                        
            scrollImageView.topAnchor.constraint(equalTo: mainFrame.topAnchor),
            scrollImageView.leadingAnchor.constraint(equalTo: mainFrame.leadingAnchor, constant: 15),
            scrollImageView.trailingAnchor.constraint(equalTo: mainFrame.trailingAnchor, constant: -15),
            scrollImageView.heightAnchor.constraint(equalTo: mainFrame.widthAnchor, multiplier: 0.7),
            
            imagesContentView.topAnchor.constraint(equalTo: scrollImageView.topAnchor),
            imagesContentView.leadingAnchor.constraint(equalTo: scrollImageView.leadingAnchor),
            imagesContentView.trailingAnchor.constraint(equalTo: scrollImageView.trailingAnchor),
            imagesContentView.bottomAnchor.constraint(equalTo: scrollImageView.bottomAnchor),
            imagesContentView.heightAnchor.constraint(equalTo: scrollImageView.heightAnchor),

            pageControl.bottomAnchor.constraint(equalTo: scrollImageView.bottomAnchor),
            pageControl.centerXAnchor.constraint(equalTo: mainFrame.centerXAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: scrollImageView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: mainFrame.leadingAnchor, constant: 40),
            nameLabel.trailingAnchor.constraint(equalTo: mainFrame.trailingAnchor, constant: -40)
        ])
        
        // descriptionFrame
        NSLayoutConstraint.activate([
            descriptionFrame.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            descriptionFrame.leadingAnchor.constraint(equalTo: mainFrame.leadingAnchor, constant: 15),
            descriptionFrame.trailingAnchor.constraint(equalTo: mainFrame.trailingAnchor, constant: -15),
            
            descriptionHeaderLabel.topAnchor.constraint(equalTo: descriptionFrame.topAnchor, constant: 15),
            descriptionHeaderLabel.leadingAnchor.constraint(equalTo: descriptionFrame.leadingAnchor, constant: 25),
            
            ratingLabel.topAnchor.constraint(equalTo: descriptionHeaderLabel.topAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: descriptionFrame.trailingAnchor, constant: -25),
            
            descriptionLabel.topAnchor.constraint(equalTo: descriptionHeaderLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: descriptionFrame.leadingAnchor, constant: 25),
            descriptionLabel.trailingAnchor.constraint(equalTo: descriptionFrame.trailingAnchor, constant: -25),
            descriptionLabel.bottomAnchor.constraint(equalTo: descriptionFrame.bottomAnchor, constant: -15)
        ])
        // contactsFrame
        NSLayoutConstraint.activate([
            contactsFrame.topAnchor.constraint(equalTo: descriptionFrame.bottomAnchor, constant: 20),
            contactsFrame.leadingAnchor.constraint(equalTo: mainFrame.leadingAnchor, constant: 15),
            contactsFrame.trailingAnchor.constraint(equalTo: mainFrame.trailingAnchor, constant: -15),
            
            contactsHeaderLabel.topAnchor.constraint(equalTo: contactsFrame.topAnchor, constant: 15),
            contactsHeaderLabel.leadingAnchor.constraint(equalTo: contactsFrame.leadingAnchor, constant: 25),
            
            contactsStack.topAnchor.constraint(equalTo: contactsHeaderLabel.bottomAnchor, constant: 10),
            contactsStack.leadingAnchor.constraint(equalTo: contactsFrame.leadingAnchor, constant: 25),
            contactsStack.trailingAnchor.constraint(equalTo: contactsFrame.trailingAnchor, constant: -25),
            contactsStack.bottomAnchor.constraint(equalTo: contactsFrame.bottomAnchor, constant: -15)
        ])
        // timeFrame
        NSLayoutConstraint.activate([
            timeFrame.topAnchor.constraint(equalTo: contactsFrame.bottomAnchor, constant: 20),
            timeFrame.leadingAnchor.constraint(equalTo: mainFrame.leadingAnchor, constant: 15),
            timeFrame.trailingAnchor.constraint(equalTo: mainFrame.trailingAnchor, constant: -15),
            timeFrame.bottomAnchor.constraint(equalTo: mainFrame.bottomAnchor),
            
            timeHeaderLabel.topAnchor.constraint(equalTo: timeFrame.topAnchor, constant: 15),
            timeHeaderLabel.leadingAnchor.constraint(equalTo: timeFrame.leadingAnchor, constant: 25),
            
            timeIconImage.topAnchor.constraint(equalTo: timeHeaderLabel.bottomAnchor, constant: 10),
            timeIconImage.leadingAnchor.constraint(equalTo: timeFrame.leadingAnchor, constant: 25),
            
            timeStack.topAnchor.constraint(equalTo: timeHeaderLabel.bottomAnchor, constant: 10),
            timeStack.leadingAnchor.constraint(equalTo: timeIconImage.trailingAnchor, constant: 24),
            timeStack.trailingAnchor.constraint(equalTo: timeFrame.trailingAnchor, constant: -25),
            timeStack.bottomAnchor.constraint(equalTo: timeFrame.bottomAnchor, constant: -15)
        ])
    }

    @objc private func closeTapped() {
        dismiss(animated: true)
    }
}

// MARK: - setDataFromConfigure, setTimeInTimeStack

extension CoffeeDetailViewController {
    private func setDataFromConfigure() {
        setScrollImages()
        
        nameLabel.text = detailViewModel?.name ?? ""
        descriptionLabel.text = "     " + (detailViewModel?.description ?? "")

        setImageWithIcon(labelToSet: ratingLabel, imageSystemName: "star.fill", textMessage: detailViewModel?.rating ?? "")
        setImageWithIcon(labelToSet: addressLabel,
                         imageSystemName: "mappin.and.ellipse",
                         textMessage:  "     " + (detailViewModel?.address ?? ""))
        
        setImageWithIcon(labelToSet: phoneLabel,
                         imageSystemName: "phone.fill",
                         textMessage: "     " + (detailViewModel?.phone ?? ""))
        
        setImageWithIcon(labelToSet: websiteLabel,
                         imageSystemName: "network",
                         textMessage: "     " + (detailViewModel?.website ?? ""))
        setTimeInTimeStack()
    }
    
    private func setImageWithIcon(labelToSet: UILabel, imageSystemName: String, textMessage: String) {
        let colorsConfig = UIImage.SymbolConfiguration(paletteColors: [UIColor(named: "CoffeePrimary")!])
        let sizeConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .bold)
        let iconImage = UIImage(systemName: imageSystemName, withConfiguration: colorsConfig.applying(sizeConfig))
        
        let attributedString = NSMutableAttributedString(string: "", attributes: [:])

        let imageAttachment = NSTextAttachment()
        imageAttachment.image = iconImage

        let imageString = NSAttributedString(attachment: imageAttachment)
        attributedString.append(imageString)
        attributedString.append(NSAttributedString(string: textMessage))

        labelToSet.attributedText = attributedString
    }
    
    private func setTimeInTimeStack() {
        let daysQueue = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
        let tm = detailViewModel?.workingHours
        for key in daysQueue {
            guard let value = tm?[key] else { continue }
            
            let timeLabel = UILabel()
            timeLabel.textColor = UIColor(named: "CoffeeText")
            timeLabel.text = "\(key) \(value.startTime ?? "")-\(value.endTime ?? "")"
            
            timeLabel.translatesAutoresizingMaskIntoConstraints = false
            timeStack.addArrangedSubview(timeLabel)
        }
    }
}

// MARK: - UIScrollViewDelegate

extension CoffeeDetailViewController: UIScrollViewDelegate {
    private func setScrollImages() {
        let detCount = detailViewModel?.images.count ?? 0
        pageControl.numberOfPages = detCount

        for index in 0..<detCount {
            let image = UIImage(data: (detailViewModel?.images[index])!)
            
            let imageView = UIImageView(image: image)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            imagesContentView.addSubview(imageView)
            
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: scrollImageView.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: scrollImageView.bottomAnchor),
                imageView.widthAnchor.constraint(equalTo: scrollImageView.widthAnchor),
                imageView.heightAnchor.constraint(equalTo: scrollImageView.heightAnchor),
                
                imageView.topAnchor.constraint(equalTo: imagesContentView.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: imagesContentView.bottomAnchor),
                imageView.widthAnchor.constraint(equalTo: scrollImageView.widthAnchor),

                index == 0 ?
                imageView.leadingAnchor.constraint(equalTo: imagesContentView.leadingAnchor) :
                    imageView.leadingAnchor.constraint(equalTo: imagesContentView.subviews[index-1].trailingAnchor)
            ])
            
        }
        
        if let lastImageView = imagesContentView.subviews.last {
           NSLayoutConstraint.activate([
               lastImageView.trailingAnchor.constraint(equalTo: imagesContentView.trailingAnchor)
           ])
       }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / (mainFrame.frame.width - 30))
        pageControl.currentPage = Int(pageIndex)
    }
}
