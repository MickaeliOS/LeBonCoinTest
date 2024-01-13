//
//  TestHelpers.swift
//  LeBonCoinTestTests
//
//  Created by Mickaël Horn on 13/01/2024.
//

import XCTest
@testable import LeBonCoinTest

final class TestHelpers: XCTestCase {
    static func controlItems(items: [Item]) {
        // First, we make sure that we have 4 items.
        XCTAssertEqual(items.count, 4)

        // We wake sure that the items are sorted, as it needs to be in our sut.
        XCTAssertEqual(items[0].id, 1582151024)
        XCTAssertEqual(items[1].id, 1671026575)
        XCTAssertEqual(items[2].id, 1702195622)
        XCTAssertEqual(items[3].id, 1701990438)
    }

    static func decodeItems() -> [Item] {
        let decoder = {
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .iso8601
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            return jsonDecoder
        }()

        let itemsData = FakeDataResponseError.correctItemData
        let decodedItems = try? decoder.decode([Item].self, from: itemsData)

        guard let decodedItems else {
            XCTFail("Error during decoding process.")
            return ([])
        }

        return decodedItems
    }

    static func decodeCategories() -> [ItemCategory] {
        let decoder = {
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .iso8601
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            return jsonDecoder
        }()

        let categoriesData = FakeDataResponseError.correctCategoryData
        let decodedCategories = try? decoder.decode([ItemCategory].self, from: categoriesData)

        guard let decodedCategories else {
            XCTFail("Error during decoding process.")
            return ([])
        }

        return decodedCategories
    }
}
