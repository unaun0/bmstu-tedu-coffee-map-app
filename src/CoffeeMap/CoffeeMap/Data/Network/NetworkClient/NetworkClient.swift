//
//  NetworkClient.swift
//  CoffeeMap
//
//  Created by Цховребова Яна on 21.05.2025.
//

import Alamofire

final class NetworkClient {
    private let session: Session

    // MARK: - Init
    
    init(session: Session = .default) {
        self.session = session
    }
}

// MARK: - NetworkClientInput

extension NetworkClient: NetworkClientInput {
    func request<T: Decodable>(
        _ route: URLRequestConvertible,
        completion: @escaping (Result<T, NetworkClientError>) -> Void
    ) {
        session.request(route)
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    if let decodingError = error.asAFError?.underlyingError
                        as? DecodingError
                    {
                        completion(.failure(.decodingError(decodingError)))
                    } else {
                        completion(.failure(.networkError(error)))
                    }
                }
            }
    }

    func download(
        _ request: URLRequestConvertible,
        progressHandler: ((Double) -> Void)? = nil,
        completion: @escaping (Result<Data, NetworkClientError>) -> Void
    ) {
        session.download(request)
            .downloadProgress { progress in
                progressHandler?(progress.fractionCompleted)
            }
            .responseData { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(
                        .failure(
                            .networkError(error)
                        )
                    )
                }
            }
    }
}
