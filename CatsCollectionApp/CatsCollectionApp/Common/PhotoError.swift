//
//  PhotoError.swift
//  CatsCollectionApp
//
//  Created by Ravi R Dixit on 11/28/19.
//  Copyright © 2019 Naina Soni. All rights reserved.
//

import Foundation

enum PhotoError : Error {
    case generalError(message: String)

    var localizedDescription: String { return "Please contact admin!!!" }
}
