//
//  AccessorFactory.swift
//  CatsCollectionApp
//
//  Created by Ravi R Dixit on 11/28/19.
//  Copyright © 2019 Naina Soni. All rights reserved.
//

import Foundation

struct AccessorFactory {

     static func createPhotoAccessor() -> PhotoAccessorProtocol{
        return PhotoAccessor()
    }
}
