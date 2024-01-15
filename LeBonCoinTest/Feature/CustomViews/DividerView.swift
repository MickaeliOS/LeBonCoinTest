//
//  DividerView.swift
//  LeBonCoinTest
//
//  Created by Mickaël Horn on 15/01/2024.
//

import UIKit

class DividerView: UIView {
    override init(frame: CGRect) {
            super.init(frame: frame)
            setupLine()
        }

    private func setupLine() {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 1).isActive = true
        backgroundColor = .systemGray
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
