//
//  PhotoRequest.swift
//  CatsCollectionApp
//
//  Created by Ravi R Dixit on 11/28/19.
//  Copyright © 2019 Naina Soni. All rights reserved.
//

import Foundation

struct PhotoRequest
{
    var limit : String
    var order : String
    var category_ids : String
}

extension PhotoRequest {

    func ToURLQueryItem() -> [URLQueryItem]{
        return [
            URLQueryItem(name: "limit", value: self.limit),
            URLQueryItem(name: "order", value: self.order),
            URLQueryItem(name: "category_ids", value:self.category_ids)
        ]
    }
}
