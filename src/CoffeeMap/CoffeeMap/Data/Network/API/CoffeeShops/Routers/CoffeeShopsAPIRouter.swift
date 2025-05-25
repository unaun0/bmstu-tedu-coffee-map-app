//
//  CoffeeShopsAPIRouter.swift
//  CoffeeMap
//
//  Created by Цховребова Яна on 21.05.2025.
//

import Alamofire

enum CoffeeShopsAPIRouter: URLRequestConvertible {
    case getCoffeeShops(page: Int?, lat: Double?, lon: Double?)
    case getCoffeeShop(id: String)
    
    private var baseURL: URL {
        CoffeeShopsAPIConfig.baseURL
    }
    
    private var method: HTTPMethod {
        switch self {
        case .getCoffeeShops, .getCoffeeShop:
            return .get
        }
    }
    
    private var path: String {
        switch self {
        case .getCoffeeShops:
            return "/coffeeshops"
        case .getCoffeeShop(let id):
            return "/coffeeshops/\(id)"
        }
    }
    
    private var parameters: Parameters? {
        switch self {
        case .getCoffeeShops(let page, let lat, let lon):
            var params: Parameters = [:]
            if let page = page {
                params["page"] = page
            }
            if let lat = lat {
                params["lat"] = lat
            }
            if let lon = lon {
                params["lon"] = lon
            }
            return params.isEmpty ? nil : params
        case .getCoffeeShop:
            return nil
        }
    }
    
    private var headers: HTTPHeaders {
        return HTTPHeaders()
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        request.headers = headers
        
        if let params = parameters, method == .get {
            request = try URLEncoding.default.encode(
                request,
                with: params
            )
        }
        
        return request
    }
}
