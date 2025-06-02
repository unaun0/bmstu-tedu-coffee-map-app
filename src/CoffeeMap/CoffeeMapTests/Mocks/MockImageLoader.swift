//
//  MockImageLoader.swift
//  CoffeeMap
//
//  Created by Цховребова Яна on 02.06.2025.
//

import Foundation

@testable import CoffeeMap

final class MockImageLoader: ImageLoaderInput {
    func load(from urlString: String) async throws -> Data {
        return Data("test".utf8)
    }
}
