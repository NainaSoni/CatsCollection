//
//  CatRequest.swift
//  CatsCollectionApp
//
//  Created by Naina Soni on 11/11/2019.
//  Copyright © 2019 Naina Soni. All rights reserved.
//

import Foundation

enum CATEGORY: Int {
    case any
    case hats = 1
    case space = 2
    case sunglasses = 4
    case boxes = 5
    case sinks = 14
    case clothes = 15
}

enum CatError : Error {
    case noDataAvailable
    case canNotProcessData
}

struct CatRequest {
    
    let API_KEY = "baf9540c-f0a8-4fee-828e-e0d6dbb7e472"
    let resourceRequest: URLRequest

    init(category: CATEGORY) {
     
        var resourceString = "https://api.thecatapi.com/v1/images/search?limit=20&order=DESC"
        if (category != .any) {
            resourceString = "https://api.thecatapi.com/v1/images/search?limit=20&order=DESC&category_ids=\(category.rawValue)"
        }
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        var resourceRequest = URLRequest(url: resourceURL)
        resourceRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        resourceRequest.setValue(API_KEY, forHTTPHeaderField: "x-api-key")
        
        self.resourceRequest = resourceRequest
    }
    
    func getCats(completion: @escaping(Result<[Cat], CatError>) -> Void) {
        
        let dataTask = URLSession.shared.dataTask(with: resourceRequest) {data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let cats: [Cat] = try decoder.decode([Cat].self, from: jsonData)
                completion(.success(cats))
            }catch{
                completion(.failure(.canNotProcessData))
            }
        }
        dataTask.resume()
    }
}
