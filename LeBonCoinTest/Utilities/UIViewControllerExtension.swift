//
//  UIViewControllerExtension.swift
//  LeBonCoinTest
//
//  Created by Mickaël Horn on 10/01/2024.
//

import UIKit

extension UIViewController {
    func presentAlert(with error: String) {
        let alert: UIAlertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
