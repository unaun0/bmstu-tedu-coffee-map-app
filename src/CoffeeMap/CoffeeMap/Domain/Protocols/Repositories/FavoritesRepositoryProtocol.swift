//
//  FavoritesRepositoryProtocol.swift
//  CoffeeMap
//
//  Created by Эмиль Шамшетдинов on 02.06.2025.
//

protocol FavoritesRepositoryProtocol {
    func getFavorites() -> [String]
    func addFavorite(id: String)
    func removeFavorite(id: String)
    func isFavorite(id: String) -> Bool
}
