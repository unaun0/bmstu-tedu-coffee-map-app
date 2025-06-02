//
//  AllCoffeeShopsViewController.swift
//  CoffeeMap
//
//  Created by Цховребова Яна on 23.05.2025.
//

import UIKit

protocol AllCoffeeShopsViewProtocol: AnyObject {
    func showLoading(_ isLoading: Bool)
    func showError(_ error: ErrorViewModel)
    func appendCoffeeShops(_ shops: [CoffeeShopViewModel])
}

final class AllCoffeeShopsViewController: UIViewController {

    // MARK: - Properties

    private let presenter: AllCoffeeShopsPresenterInput
    private var coffeeShops: [CoffeeShopViewModel] = []
    private var isFirstLoad = true

    // MARK: - Subviews

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.refreshControl = refreshControl
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            CoffeeShopsTableViewCell.self,
            forCellReuseIdentifier: "CoffeeShopCell"
        )
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        return tableView
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
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.color = UIColor(named: "CoffeeText") ?? .gray
        return indicator
    }()

    private let refreshControl = UIRefreshControl()

    // MARK: - Init

    init(presenter: AllCoffeeShopsPresenterInput) {
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
        presenter.viewDidLoad()
    }
}

// MARK: - Setup UI

extension AllCoffeeShopsViewController {
    private func setupView() {
        title = "Все кофейни"
        view.backgroundColor = UIColor(named: "CoffeeBackground")

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "CoffeeBackground")
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor(
                named: "CoffeeText"
            ) ?? .label
        ]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        refreshControl.addTarget(
            self,
            action: #selector(didPullToRefresh),
            for: .valueChanged
        )
        view.addSubview(tableView)
        view.addSubview(errorView)
        view.addSubview(activityIndicator)

        activityIndicator.startAnimating()
    }

    private func setupConstraints() {
        setupActivityIndicatorConstraints()
        setupTableConstraints()
        setupErrorViewConstraints()
    }

    private func setupTableConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func setupErrorViewConstraints() {
        errorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorView.topAnchor.constraint(equalTo: view.topAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func setupActivityIndicatorConstraints() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(
                equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(
                equalTo: view.centerYAnchor),
        ])
    }

}

// MARK: - Actions

extension AllCoffeeShopsViewController {
    @objc fileprivate func didPullToRefresh() {
        coffeeShops.removeAll()
        tableView.reloadData()
        presenter.viewDidLoad()
    }
}

// MARK: - AllCoffeeShopsViewProtocol

extension AllCoffeeShopsViewController: AllCoffeeShopsViewProtocol {
    func showLoading(_ isLoading: Bool) {
        if isFirstLoad {
            if !isLoading {
                activityIndicator.stopAnimating()
                isFirstLoad = false
            }
        } else {
            if isLoading {
                refreshControl.beginRefreshing()
            } else {
                refreshControl.endRefreshing()
            }
        }
    }

    func showError(_ error: ErrorViewModel) {
        refreshControl.endRefreshing()
        errorView.configure(with: error)
        errorView.isHidden = false
        tableView.isHidden = true
    }

    func appendCoffeeShops(_ shops: [CoffeeShopViewModel]) {
        let startIndex = coffeeShops.count
        coffeeShops.append(contentsOf: shops)
        let indexPaths = (startIndex..<coffeeShops.count).map {
            IndexPath(row: $0, section: 0)
        }
        tableView.insertRows(at: indexPaths, with: .fade)
    }
}

// MARK: - UITableViewDataSource

extension AllCoffeeShopsViewController: UITableViewDataSource {
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

        return cell
    }
}

// MARK: - UITableViewDelegate

extension AllCoffeeShopsViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > scrollView.contentSize.height
            - scrollView.frame.size.height
        {
            presenter.loadNextPage()
        }
    }

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
