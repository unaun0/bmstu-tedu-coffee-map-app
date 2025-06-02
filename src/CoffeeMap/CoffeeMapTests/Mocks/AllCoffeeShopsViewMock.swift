//
//  AllCoffeeShopsViewMock.swift
//  CoffeeMap
//
//  Created by Цховребова Яна on 03.06.2025.
//

import Foundation

@testable import CoffeeMap

final class AllCoffeeShopsViewMock: AllCoffeeShopsViewProtocol {
    private(set) var showLoadingCalledWith: [Bool] = []
    private(set) var showErrorCalledWith: [ErrorViewModel] = []
    private(set) var appendCoffeeShopsCalledWith: [[CoffeeShopViewModel]] = []

    func showLoading(_ isLoading: Bool) {
        showLoadingCalledWith.append(isLoading)
    }

    func showError(_ error: ErrorViewModel) {
        showErrorCalledWith.append(error)
    }

    func appendCoffeeShops(_ shops: [CoffeeShopViewModel]) {
        appendCoffeeShopsCalledWith.append(shops)
    }
}
