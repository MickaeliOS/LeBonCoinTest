//
//  ItemsViewModelTests.swift
//  ItemsViewModelTests
//
//  Created by Mickaël Horn on 11/01/2024.
//

import XCTest
@testable import LeBonCoinTest

final class ItemsViewModelTests: XCTestCase {

    // MARK: - PROPERTIES
    private var sut: ItemsViewModel!
    private var fetchService: FetchService!
    private var expectedResponse: String?
    private var expectedError: String?
    private var session: URLSession! = {
        let configuration: URLSessionConfiguration = {
            let configuration = URLSessionConfiguration.ephemeral
            configuration.protocolClasses = [URLProtocolMock.self]
            return configuration
        }()
        return URLSession(configuration: configuration)
    }()

    // MARK: - SETUP
    override func setUp()  {
        super.setUp()

        fetchService = FetchService(session: session)
        sut = ItemsViewModel(fetchService: fetchService)
        sut.delegate = self
        expectedResponse = nil
        expectedError = nil
    }

    // MARK: - TESTS
    func testGivenCorrectDataAndNoError_WhenGettingItems_ThenItemsAreFetchedCorrectly() async {
        // First, we need to set our URLs.
        guard let itemURL = URL(string: APIUrl.items.rawValue),
              let categoryURL = URL(string: APIUrl.category.rawValue) else {
            XCTFail("URLs are not correctly set.")
            return
        }

        // Then, we tell the Mock what behavior we want by setting the data, response and error.
        URLProtocolMock.testURLs[itemURL] = FakeDataResponseError.correctItemData
        URLProtocolMock.testURLs[categoryURL] = FakeDataResponseError.correctCategoryData
        URLProtocolMock.response = FakeDataResponseError.responseOK
        URLProtocolMock.error = nil

        // Finally, we start the api call and see if all conditions are met.
        await sut.getItems()
        XCTAssertEqual(expectedResponse, "getItemsDidSucceed")
    }

    func testGivenABadURLResponse_WhenGettingItems_ThenResponseErrorOccurs() async {
        guard let itemURL = URL(string: APIUrl.items.rawValue) else {
            XCTFail("URL is not correctly set.")
            return
        }

        URLProtocolMock.testURLs[itemURL] = FakeDataResponseError.correctItemData
        URLProtocolMock.response = FakeDataResponseError.responseKO
        URLProtocolMock.error = nil
        expectedError = "The server returned an unexpected response. Please try again later."

        await sut.getItems()
        XCTAssertEqual(expectedResponse, "getItemsDidFail")
    }

    func testGivenAnError_WhenGettingItems_ThenDownloadFailedErrorOccurs() async {
        URLProtocolMock.error = FakeDataResponseError.mockError
        expectedError = "The download failed, please try again."

        await sut.getItems()
    }

    func testGivenACategoryName_WhenSortingItemsByCategory_ThenItemsAreSortedByCategory() {
        let categoryName = "Loisirs"
        let items = TestHelpers.decodeItems()
        let categories = TestHelpers.decodeCategories()

        sut.items = items
        sut.filteredItems = items
        sut.categories = categories

        sut.filterItemsBy(categoryName: categoryName)
        sut.filteredItems.forEach { item in
            XCTAssertEqual(item.categoryId, 5)
        }
    }

    func testGivenIncorrectCategoryName_WhenSortingItemsByCategory_ThenItemsAreNotSorted() {
        let categoryName = ""
        let items = TestHelpers.decodeItems()

        sut.items = items
        sut.filteredItems = items

        sut.filterItemsBy(categoryName: categoryName)

        // If both collections have the same number of items, it means the filter failed.
        sut.filteredItems.forEach { item in
            XCTAssertEqual(sut.items.count, sut.filteredItems.count)
        }
    }

    func testGivenItems_WhenResetingFilter_ThenFilterIsReseted() {
        sut.items = TestHelpers.decodeItems()

        sut.resetFilter()

        XCTAssertEqual(sut.items, sut.filteredItems)
    }

    //func test               
}

// MARK: - PRIVATE FUNCTIONS
extension ItemsViewModelTests {

}

// MARK: - DELEGATE
extension ItemsViewModelTests: ItemsViewModelDelegate {
    func getItemsDidSucceed() {
        // We make sure the test trigger this method, and not the view's one.
        expectedResponse = "getItemsDidSucceed"

        // These properties should not be empty, we make sure the call completed successfully.
        XCTAssertFalse(sut.items.isEmpty)
        XCTAssertFalse(sut.filteredItems.isEmpty)
        XCTAssertFalse(sut.categories.isEmpty)

        TestHelpers.controlItems(items: sut.items)
        TestHelpers.controlItems(items: sut.filteredItems)
    }

    func getItemsDidFail(error: ErrorMessage) {
        expectedResponse = "getItemsDidFail"

        XCTAssertEqual(error, expectedError)
    }
}
