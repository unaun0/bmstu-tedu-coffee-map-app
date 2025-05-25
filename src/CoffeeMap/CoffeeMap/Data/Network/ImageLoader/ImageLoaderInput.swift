//
//   ImageLoaderInput.swift
//  CoffeeMap
//
//  Created by Цховребова Яна on 23.05.2025.
//

import Foundation

protocol ImageLoaderInput {
    func load(from urlString: String) async throws -> Data
}

