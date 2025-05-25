//
//  NetworkClientInput.swift
//  CoffeeMap
//
//  Created by Цховребова Яна on 21.05.2025.
//

import Foundation
import Alamofire

protocol NetworkClientInput: AnyObject {
    func request<T: Decodable>(
        _ route: URLRequestConvertible,
        completion: @escaping (Result<T, NetworkClientError>) -> Void
    )
    
    func download(
        _ request: URLRequestConvertible,
        progressHandler: ((Double) -> Void)?,
        completion: @escaping (Result<Data, NetworkClientError>) -> Void
    )
}
