//
//  PhotoAccessor.swift
//  CatsCollectionApp
//
//  Created by Ravi R Dixit on 11/28/19.
//  Copyright © 2019 Naina Soni. All rights reserved.
//

import Foundation

protocol PhotoAccessorProtocol {

    func getPhotos(request: PhotoRequest, completionHandler: @escaping(_ result: [Photo]?) -> Void)
    func downloadPhoto(request: DownloadRequest, completionHandler: @escaping(_ result: Data?) -> Void)
}

struct PhotoAccessor : PhotoAccessorProtocol {

    private let httpClient : HttpClientProtocol = HttpClient()

    func downloadPhoto(request: DownloadRequest, completionHandler: @escaping (Data?) -> Void) {

        httpClient.getData(with: request.contentUrl) { (result) in
            _=completionHandler(result)
        }
    }

    func getPhotos(request: PhotoRequest, completionHandler: @escaping(_ result: [Photo]?) -> Void) {
        httpClient.getData(with: request, resultType: [Photo].self) { (result) in
            _=completionHandler(result)
        }
    }
}
