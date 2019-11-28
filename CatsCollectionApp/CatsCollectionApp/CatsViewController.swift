//
//  CatsViewController.swift
//  CatsCollectionApp
//
//  Created by Naina Soni on 07/11/2019.
//  Copyright © 2019 Naina Soni. All rights reserved.
//

import UIKit

enum CATEGORY_ID: String {
    case all = ""
    case hats = "1"
    case space = "2"
    case sunglasses = "4"
    case boxes = "5"
    case sinks = "14"
    case clothes = "15"
}

class CatsViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Properties
    let viewModel = ViewModel(client: AccessorFactory.createPhotoAccessor())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.center=self.view.center;

        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        collectionView?.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        getCats(category: "")
        
    }
    
    func getCats(category : String) -> Void {
        // Init view model
        viewModel.showLoading = {
            if self.viewModel.isLoading {
                self.activityIndicator.startAnimating()
                self.collectionView.alpha = 0.0
            } else {
                self.activityIndicator.stopAnimating()
                self.collectionView.alpha = 1.0
            }
        }
        
        viewModel.showError = { error in
            print(error)
        }
        
        viewModel.reloadData = {
            self.collectionView.reloadData()
        }

        viewModel.fetchPhotos(request: createPhotoRequest(categoryId: category))
    }
}

// MARK: Create photo request
private func createPhotoRequest(categoryId: String) -> PhotoRequest{
    return PhotoRequest(limit: "10", order: "1", category_ids: categoryId)
}


//MARK: - Flow layout delegate

extension CatsViewController : PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let image = viewModel.cellViewModels[indexPath.item].image
        var height = image.size.height
        //CAT API is giving high resolution images, and to properly see pinterest layout we need to reduce the image resolution
        if (height > 600.0) {
            height = 300
        }
        return height
    }
}

//MARK: - Data Sources

extension CatsViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        let image = viewModel.cellViewModels[indexPath.item].image
        cell.imageView.image = image
        return cell
    }
}


extension CatsViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchBarText = searchBar.text else {return}
        viewModel.fetchPhotos(request: createPhotoRequest(categoryId: CatID(text: searchBarText).rawValue))
    }
    
    // API searchByCategory doesn't support text, so we have to convert into categoryid enum
    // Also we can search only below tags with this API
    //can be moved in extension
    func CatID(text : String) -> CATEGORY_ID {

        if (text.caseInsensitiveCompare("hats") == .orderedSame || text.caseInsensitiveCompare("hat") == .orderedSame) {
            return .hats
        }else if (text.caseInsensitiveCompare("space") == .orderedSame) {
            return .space
        }else if (text.caseInsensitiveCompare("sunglasses") == .orderedSame  || text.caseInsensitiveCompare("sunglass") == .orderedSame) {
            return .sunglasses
        }else if (text.caseInsensitiveCompare("boxes") == .orderedSame  || text.caseInsensitiveCompare("box") == .orderedSame) {
            return .boxes
        }else if (text.caseInsensitiveCompare("sinks") == .orderedSame  || text.caseInsensitiveCompare("sink") == .orderedSame) {
            return .sinks
        }else if (text.caseInsensitiveCompare("clothes") == .orderedSame  || text.caseInsensitiveCompare("cloth") == .orderedSame) {
            return .clothes
        }else {
            return .all
        }
    }

    
}
