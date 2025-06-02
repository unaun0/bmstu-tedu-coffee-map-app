//
//  AllCoffeeShopsPresenterInput.swift
//  CoffeeMap
//
//  Created by Цховребова Яна on 24.05.2025.
//

protocol AllCoffeeShopsPresenterInput: AnyObject {
    func refreshData()
    func viewDidLoad()
    func loadNextPage()
    func updateLikeStatus(id: String, isLiked: Bool)
    func coffeeShopDetails(
        id: String,
        completion: @escaping (Result<CoffeeShopDetailViewModel, Error>) -> Void
    )
}
