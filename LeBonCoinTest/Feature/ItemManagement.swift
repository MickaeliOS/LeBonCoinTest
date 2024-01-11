//
//  ItemManagement.swift
//  LeBonCoinTest
//
//  Created by Mickaël Horn on 11/01/2024.
//

import Foundation

final class ItemManagement {
    func getCategoryName(categories: [Category], categoryId: Int) -> String {
        let categoryIndex = categories.firstIndex { $0.id == categoryId }

        guard let categoryIndex else {
            return "Unknown Category"
        }

        return categories[categoryIndex].name
    }
}
