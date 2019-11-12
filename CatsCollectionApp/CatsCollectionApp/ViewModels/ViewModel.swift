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
    
    private let client: APIClient
    
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
    
    init(client: APIClient) {
        self.client = client
    }
    
    func fetchPhotos(catId : String) {
        if let client = client as? CatClient {
            self.isLoading = true
            let endpoint = CatEndpoint.photos(limit: "10", order: .DESC, catId: catId)
            client.fetch(with: endpoint) { (either) in
                switch either {
                case .success(let photos):
                    self.photos = photos
                case .error(let error):
                    self.showError?(error)
                }
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
    
    func downloadImage(url: URL, completion: @escaping (_ image: UIImage?, _ error: Error? ) -> Void) {
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage, nil)
        } else {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Couldn't download image: ", error)
                    completion(nil, error)
                }
                else if let data = data, let image = UIImage(data: data) {
                    imageCache.setObject(image, forKey: url.absoluteString as NSString)
                    completion(image, nil)
                } else {
                    completion (nil, error)
                }
            }.resume()
        }
    }
}

