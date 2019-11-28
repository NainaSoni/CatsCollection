//
//  ViewModel.swift
//  CatsCollectionApp
//
//  Created by Naina Soni on 12/11/2019.
//  Copyright © 2019 Naina Soni. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

struct CellViewModel {
    let image: UIImage
}

class ViewModel {
    // MARK: Properties

    private let _accessor: PhotoAccessorProtocol

    private var photos: Photos = [] {
        didSet {
            self.fetchPhoto()
        }
    }
    
    var cellViewModels: [CellViewModel] = []
    
    // MARK: UI
    
    var isLoading: Bool = false {
        didSet {
            showLoading?()
        }
    }
    var showLoading: (() -> Void)?
    var reloadData: (() -> Void)?
    var showError: ((Error) -> Void)?
    
    init(client: PhotoAccessorProtocol) {
        self._accessor = client
    }
    
    func fetchPhotos(request: PhotoRequest) {

        self.isLoading = true
        _accessor.getPhotos(request: request) { (result) in
            if(result != nil){
                self.photos = result!
            }else{
                self.showError?(PhotoError.generalError(message: "Something is not right in fetchPhotos function"))
                debugPrint("Error occured")
            }
        }
    }
    
    private func fetchPhoto() {
        self.cellViewModels = []
        let group = DispatchGroup()
        self.photos.forEach { (photo) in
            DispatchQueue.global(qos: .background).async(group: group) {
                group.enter()
                self.downloadImage(url: photo.url) { (image, error) in
                    if error != nil {
                        group.leave()
                    }
                    else if let image = image {
                        self.cellViewModels.append(CellViewModel(image: image))
                        group.leave()
                    }
                }
            }
        }
        group.notify(queue: .main) {
            self.isLoading = false
            self.reloadData?()
        }
    }

    private func downloadImage(url: URL, completion: @escaping (_ image: UIImage?, _ error: Error? ) -> Void) {
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage, nil)
        } else {

            let request = DownloadRequest(contentUrl: url)
            _accessor.downloadPhoto(request: request) { (data) in
                if let data = data, let image = UIImage(data: data) {
                    imageCache.setObject(image, forKey: url.absoluteString as NSString)
                    completion(image, nil)
                } else {
                    completion (nil, PhotoError.generalError(message: "Something is not right in downloadImage function"))
                }
            }
        }
    }
}

