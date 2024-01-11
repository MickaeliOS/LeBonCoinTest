//
//  ItemImageView.swift
//  LeBonCoinTest
//
//  Created by Mickaël Horn on 10/01/2024.
//

import UIKit

class ItemImageView: UIImageView {

    // MARK: - PROPERTIES
    let imageCache = NSCache<NSString, AnyObject>()

    // MARK: - FUNCTIONS
    func downloadImageFrom(urlString: String) {
        guard let url = URL(string: urlString) else {
            image = UIImage(systemName: "photo.fill")
            return
        }

        // If the image is already cached, we use it.
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
            self.image = cachedImage
        } else {

            // Otherwise, we download it.
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let data = data, error == nil else {
                    self?.image = UIImage(systemName: "photo.fill")
                    return
                }

                DispatchQueue.main.async {
                    guard let imageToCache = UIImage(data: data) else {
                        self?.image = UIImage(systemName: "photo.fill")
                        return
                    }
                    
                    self?.imageCache.setObject(imageToCache, forKey: url.absoluteString as NSString)
                    self?.image = imageToCache
                }
            }.resume()
        }
    }
}
