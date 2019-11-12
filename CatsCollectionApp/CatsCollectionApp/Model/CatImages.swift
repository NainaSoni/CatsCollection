//
//  CatImages.swift
//  CatsCollectionApp
//
//  Created by Naina Soni on 12/11/2019.
//  Copyright © 2019 Naina Soni. All rights reserved.
//

import Foundation

typealias Photos = [Photo]

struct Photo: Codable {
    let id: String
    let url: URL
    let width: Int
    let height : Int
}
