//
//  Cat.swift
//  CatsCollectionApp
//
//  Created by Naina Soni on 11/11/2019.
//  Copyright © 2019 Naina Soni. All rights reserved.
//

import Foundation

struct Cat:Decodable {
    var id: String
    var url : String
    var width: Int
    var height : Int
    var categories : [Category]?
}

struct Category:Decodable {
    var id : Int
    var name : String
}
