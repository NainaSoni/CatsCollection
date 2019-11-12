//
//  CatClient.swift
//  CatsCollectionApp
//
//  Created by Naina Soni on 12/11/2019.
//  Copyright © 2019 Naina Soni. All rights reserved.
//

import Foundation

class CatClient: APIClient {
    static let baseUrl = "https://api.thecatapi.com"

    func fetch(with endpoint: CatEndpoint, completion: @escaping (Either<Photos>) -> Void) {
        let request = endpoint.request
        get(with: request, completion: completion)
    }
}
