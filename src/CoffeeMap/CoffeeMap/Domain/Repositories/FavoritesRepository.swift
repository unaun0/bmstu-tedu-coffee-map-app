//
//  FavoritesRepository.swift
//  CoffeeMap
//
//  Created by Эмиль Шамшетдинов on 02.06.2025.
//

import Foundation

final class FavoritesRepository: FavoritesRepositoryProtocol {
    static let shared = FavoritesRepository()
    private let userDefaults = UserDefaults.standard
    private let key = "favoriteCoffeeShops"
    
    func getFavorites() -> [String] {
        userDefaults.stringArray(forKey: key) ?? []
    }
    
    func addFavorite(id: String) {
        var favorites = getFavorites()
        guard !favorites.contains(id) else { return }
        favorites.append(id)
        userDefaults.set(favorites, forKey: key)
    }
    
    func removeFavorite(id: String) {
        var favorites = getFavorites()
        favorites.removeAll { $0 == id }
        userDefaults.set(favorites, forKey: key)
    }
    
    func isFavorite(id: String) -> Bool {
        getFavorites().contains(id)
    }
}

extension FavoritesRepository {
    func toggleFavorite(id: String) {
        isFavorite(id: id) ? removeFavorite(id: id) : addFavorite(id: id)
    }
}
