//
//  CatsViewController.swift
//  CatsCollectionApp
//
//  Created by Naina Soni on 07/11/2019.
//  Copyright © 2019 Naina Soni. All rights reserved.
//

import UIKit

class CatsViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Properties
    var listOfCats = [Cat]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        collectionView?.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        getCats(category: "")
    }
    
    func getCats(category : String) -> Void {
        let catRequest = CatRequest(category: searchByCategory(text: category))
        catRequest.getCats{[weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let cats):
                self?.listOfCats = cats
            }
        }
    }
}

//MARK: - Flow layout delegate

extension CatsViewController : PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        var height : CGFloat = CGFloat(listOfCats[indexPath.item].height)
        
        //API is giving high resolution images, and to properly see pinterest layout we need to reduce the image resolution
        if (height > 600.0) {
            height = 300
        }
        return CGFloat(height)
    }
}

//MARK: - Data Sources

extension CatsViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfCats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        let cat = listOfCats[indexPath.item]
        cell.imageView.downloaded(from: cat.url)
        return cell
    }
}


extension CatsViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchBarText = searchBar.text else {return}
        getCats(category: searchBarText)
    }
    
    // API searchByCategory doesn't support text, so we have to convert into categoryid enum
    // Also we can search only below tags with this API
    func searchByCategory(text : String) -> CATEGORY {
        
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
        }else
        {
            return .any
        }
    }
}
