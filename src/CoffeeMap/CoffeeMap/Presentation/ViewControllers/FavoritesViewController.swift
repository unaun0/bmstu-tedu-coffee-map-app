//
//  FavoritesViewController.swift
//  CoffeeMap
//
//  Created by Козлов Павел on 02.06.2025.
//

import UIKit

protocol FavoritesViewProtocol: AnyObject {
    func showLoading(_ isLoading: Bool)
    func showError(_ error: ErrorViewModel)
    func appendCoffeeShops(_ shops: [CoffeeShopViewModel])
}

final class FavoritesViewController: UIViewController {
    // MARK: - Properties
    private let presenter: FavoritesPresenterInput
    private var coffeeShops: [CoffeeShopViewModel] = []
    
    // MARK: - UI Components
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(named: "CoffeeBackground")
        tableView.separatorStyle = .none
        tableView.register(
            CoffeeShopsTableViewCell.self,
            forCellReuseIdentifier: "CoffeeShopCell"
        )
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.refreshControl = refreshControl
        return tableView
    }()
    private let refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.tintColor = UIColor(named: "CoffeeText")
        return control
    }()
    private let emptyStateView: EmptyStateView = {
        let view = EmptyStateView()
        view.configure(
            image: UIImage(systemName: "heart.slash"),
            title: "Нет избранных кофеен",
            subtitle: "Добавляйте кофейни, нажимая на ♡ в списке"
        )
        return view
    }()
    private lazy var errorView: ErrorView = {
        let view = ErrorView()
        view.isHidden = true
        view.onRetry = { [weak self] in
            self?.errorView.isHidden = true
            self?.tableView.isHidden = false
            self?.coffeeShops.removeAll()
            self?.tableView.reloadData()
            self?.presenter.viewDidLoad()
        }
        return view
    }()
    
    // MARK: - Initialization
    init(presenter: FavoritesPresenterInput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupActions()
        presenter.viewDidLoad()
    }

    // MARK: - Setup
    private func setupView() {
        title = "Избранное"
        view.backgroundColor = UIColor(named: "CoffeeBackground")
        view.addSubview(tableView)
        view.addSubview(emptyStateView)
        view.addSubview(errorView)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "CoffeeBackground")
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor(named: "CoffeeText") ?? .label
        ]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        errorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            errorView.topAnchor.constraint(equalTo: view.topAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupActions() {
        refreshControl.addTarget(
            self,
            action: #selector(didPullToRefresh),
            for: .valueChanged
        )
    }
    
    // MARK: - Actions
    @objc private func didPullToRefresh() {
        emptyStateView.isHidden = false
        print("didPullToRefreshdidPullToRefreshdidPullToRefreshdidPullToRefresh")
        coffeeShops.removeAll()
        tableView.reloadData()
        presenter.viewDidLoad()
    }
}

// MARK: - FavoritesViewProtocol
extension FavoritesViewController: FavoritesViewProtocol {
    func appendCoffeeShops(_ shops: [CoffeeShopViewModel]) {
        let startIndex = coffeeShops.count
        coffeeShops.append(contentsOf: shops)
        let indexPaths = (startIndex..<coffeeShops.count).map {
            IndexPath(row: $0, section: 0)
        }
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    func showLoading(_ isLoading: Bool) {
        isLoading ? refreshControl.beginRefreshing() : refreshControl.endRefreshing()
    }
    
    func showError(_ error: ErrorViewModel) {
        refreshControl.endRefreshing()
        errorView.configure(with: error)
        errorView.isHidden = false
        tableView.isHidden = true
    }
}

// MARK: - UITableViewDataSource
extension FavoritesViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        coffeeShops.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "CoffeeShopCell",
                for: indexPath
            ) as? CoffeeShopsTableViewCell
        else {
            return UITableViewCell()
        }
        
        let shop = coffeeShops[indexPath.row]
        cell.configure(
            name: shop.name,
            image: {
                if let data = shop.image, let uiImage = UIImage(data: data) {
                    return uiImage
                } else {
                    return UIImage(named: "AppIcon")
                }
            }(),
            liked: shop.isLiked,
            distance: shop.distance,
            description: shop.description
        )
        
        cell.onLikeButtonTapped = { [weak self] isLiked in
            guard let self = self else { return }
            self.coffeeShops[indexPath.row].isLiked = isLiked
            self.presenter.updateLikeStatus(
                id: self.coffeeShops[indexPath.row].id, isLiked: isLiked)
        }
        
        if emptyStateView.isHidden == false {
            emptyStateView.isHidden = true
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension FavoritesViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let modalVC = CoffeeDetailViewController()
        modalVC.modalPresentationStyle = .pageSheet
        modalVC.modalTransitionStyle = .coverVertical
        self.present(modalVC, animated: true)
        
        presenter.coffeeShopDetails(id: coffeeShops[indexPath.row].id) {
            [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let viewModel):
                modalVC.configure(with: viewModel)

            case .failure:
                modalVC.dismiss(animated: true)
                self.showError(
                    ErrorViewModel(
                        type: .generic,
                        title: "Ошибка",
                        message: "Не удалось загрузить детали кофейни",
                        canRetry: true
                    )
                )
            }
        }
    }
}
