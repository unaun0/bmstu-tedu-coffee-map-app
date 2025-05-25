//
//  ImageLoader.swift
//  CoffeeMap
//
//  Created by Цховребова Яна on 23.05.2025.
//

import Foundation

final class ImageLoader {
    private let networkClient: NetworkClientInput
    
    init(networkClient: NetworkClientInput) {
        self.networkClient = networkClient
    }
}

// MARK: - ImageLoaderInput

extension ImageLoader: ImageLoaderInput {
    func load(from urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw ImageLoaderError.invalidURL
        }
        let request = URLRequest(url: url)
        
        return try await withCheckedThrowingContinuation { continuation in
            networkClient.download(request, progressHandler: nil) { result in
                switch result {
                case .success(let data):
                    continuation.resume(returning: data)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
