//
//  FavoritesPresenterInput.swift
//  CoffeeMap
//
//  Created by Козлов Павел on 02.06.2025.
//

protocol FavoritesPresenterInput: AnyObject {
    func viewDidLoad()
    func refreshData()
    func toggleFavorite(id: String)
    func loadNextPage()
    func updateLikeStatus(id: String, isLiked: Bool)

    
    func coffeeShopDetails(
        id: String,
        completion: @escaping (CoffeeShopDetailViewModel?) -> Void
    )
}
