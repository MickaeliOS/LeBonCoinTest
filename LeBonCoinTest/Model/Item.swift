//
//  Item.swift
//  LeBonCoinTest
//
//  Created by Mickaël Horn on 10/01/2024.
//

import Foundation

// MARK: - ITEM
struct Item: Codable {
    let id: Int
    let categoryId: Int
    let title: String
    let description: String
    let price: Double
    let imagesUrl: ImageURL
    let creationDate: Date
    let isUrgent: Bool
}

// MARK: - IMAGEURL
struct ImageURL: Codable {
    let small: String?
    let thumb: String?
}

// MARK: - PROTOCOL
extension Item: Equatable {
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.id == rhs.id
    }
}
