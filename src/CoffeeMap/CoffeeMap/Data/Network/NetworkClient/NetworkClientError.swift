//
//  NetworkClientError.swift
//  CoffeeMap
//
//  Created by Цховребова Яна on 21.05.2025.
//

import Foundation

enum NetworkClientError: Error {
    case networkError(Error)
    case decodingError(DecodingError)
}
