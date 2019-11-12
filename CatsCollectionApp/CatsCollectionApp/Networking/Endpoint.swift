//
//  Endpoint.swift
//  CatsCollectionApp
//
//  Created by Naina Soni on 12/11/2019.
//  Copyright © 2019 Naina Soni. All rights reserved.
//

import Foundation

protocol Endpoint {
    var baseUrl: String { get }
    var path: String { get }
    var urlParameters: [URLQueryItem] { get }
}

extension Endpoint {
        
    var urlComponent: URLComponents {
        var urlComponent = URLComponents(string: baseUrl)
        urlComponent?.path = path
        urlComponent?.queryItems = urlParameters
        return urlComponent!
    }

    var request: URLRequest {
        var request = URLRequest(url: urlComponent.url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField:"Content-Type")
        request.setValue("baf9540c-f0a8-4fee-828e-e0d6dbb7e472", forHTTPHeaderField:"x-api-key")
        return request
    }
}

enum Order: String {
    case DESC, AESC
}

enum CatEndpoint: Endpoint {
    case photos(limit: String, order: Order, catId: String)
    
    var baseUrl: String {
        return CatClient.baseUrl
    }

    var path: String {
        switch self {
        case .photos:
            return "/v1/images/search"
        }
    }

    var urlParameters: [URLQueryItem] {
        switch self {
        case .photos(let limit, let order, let catId):
            return [
                URLQueryItem(name: "limit", value: limit),
                URLQueryItem(name: "order", value: order.rawValue),
                URLQueryItem(name: "category_ids", value:catId)
            ]
        }
        
    }
}


