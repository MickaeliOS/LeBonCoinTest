//
//  UIImageViewExtension.swift
//  LeBonCoinTest
//
//  Created by Mickaël Horn on 10/01/2024.
//

import UIKit

extension UIImageView {
    private static let cachedImages = NSCache<AnyObject, AnyObject>()

    func load(urlString: String?) {
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            self.image = UIImage(systemName: "questionmark")
            return
        }

        URLSession.shared.dataTask(with: url) { (data, _, _) in
            DispatchQueue.main.async {
                guard let data = data else {
                    self.image = UIImage(systemName: "questionmark")
                    return
                }
                
                self.image = UIImage(data: data)
            }
        }.resume()
    }
}
