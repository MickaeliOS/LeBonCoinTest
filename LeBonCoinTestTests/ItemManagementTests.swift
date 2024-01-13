//
//  ItemManagementTests.swift
//  LeBonCoinTestTests
//
//  Created by Mickaël Horn on 13/01/2024.
//

import XCTest
@testable import LeBonCoinTest

final class ItemManagementTests: XCTestCase {
    private var sut: ItemManagement!

    override func setUp() {
        sut = ItemManagement()
    }

    func testGivenCategoriesListAndID_WhenGettingCategoryName_ThenCategoryNameIsReturned() {
        let categories = TestHelpers.decodeCategories()
        let categoryID = 1

        let categoryName = sut.getCategoryName(categories: categories, categoryId: categoryID)

        XCTAssertEqual(categoryName, "Véhicule")
    }

    func testGivenBadCategoryID_WhenGettingCategoryName_ThenUnknowCategoryIsReturned() {
        let categories = TestHelpers.decodeCategories()
        let categoryID = 100

        let categoryName = sut.getCategoryName(categories: categories, categoryId: categoryID)

        XCTAssertEqual(categoryName, "Unknown Category")
    }

    func testGivenADate_WhenFormattingDateToString_ThenStringDateIsReturned() {
        // January 1st 2020, 00:00:00 UTC
        let date = Date(timeIntervalSince1970: 1577836800)

        let formattedDateString = sut.formattedDate(date: date)

        // Vérifier le résultat
        XCTAssertEqual(formattedDateString, "01-01-2020")
    }

}
