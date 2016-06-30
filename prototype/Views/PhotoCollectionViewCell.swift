//
//  PhotoCollectionViewCell.swift
//  GlacierScenics
//
//  Created by Todd Kramer on 1/30/16.
//  Copyright © 2016 Todd Kramer. All rights reserved.
//

import UIKit
import Alamofire

class PhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var captionLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    var request: Request?
    var glacierScenic: GlacierScenic!

    func configure(glacierScenic: GlacierScenic) {
        self.glacierScenic = glacierScenic
        reset()
        loadImage()
    }

    func reset() {
        imageView.image = UIImage(named: "placeholderImage")
        request?.cancel()
        captionLabel.hidden = true
        priceLabel.hidden = true
    }

    func loadImage() {
        if let image = PhotosDataManager.sharedManager.cachedImage(glacierScenic.photoURLString) {
            populateCell(image)
            return
        }
        downloadImage()
    }

    func downloadImage() {
        //loadingIndicator.startAnimating()
        let urlString = glacierScenic.photoURLString
        request = PhotosDataManager.sharedManager.getNetworkImage(urlString) { image in
            self.populateCell(image)
        }
    }

    func populateCell(image: UIImage) {
        //loadingIndicator.stopAnimating()
        imageView.image = image
        captionLabel.text = glacierScenic.name
        captionLabel.hidden = false
        priceLabel.text = glacierScenic.price
        priceLabel.hidden = false
    }

}
