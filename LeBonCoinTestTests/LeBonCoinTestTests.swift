//
//  LeBonCoinTestTests.swift
//  LeBonCoinTestTests
//
//  Created by Mickaël Horn on 11/01/2024.
//

import XCTest
@testable import LeBonCoinTest

final class LeBonCoinTestTests: XCTestCase {

    // MARK: - PROPERTIES
    private var sut: ItemsViewModel!
    private var expectedResponse: String!
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

        let fetchService = FetchService(session: session)
        sut = ItemsViewModel(fetchService: fetchService)
        sut.delegate = self
    }

    // MARK: - TESTS
    func testGivenCorrectDataAndNoError_WhenGettingItems_ThenItemsAreFetchedCorrectly() async {
        // First, we need to set our URLs.
        guard let itemURL = URL(string: APIUrl.items.rawValue),
              let categoryURL = URL(string: APIUrl.category.rawValue) else {
            XCTFail("URLs are not correctly set.")
            return
        }

        // Then, we put the test data.
        URLProtocolMock.testURLs[itemURL] = FakeData.correctItemData
        URLProtocolMock.testURLs[categoryURL] = FakeData.correctCategoryData
        URLProtocolMock.response = FakeData.responseOK

        // Finally, we start the api call and see if all conditions are met.
        await sut.getItems()
        XCTAssertEqual(expectedResponse, "getItemsDidSucceed")
    }

    func testGivenABadURLResponse_WhenGettingItems_ThenAnErrorOccurs() async {
        guard let itemURL = URL(string: APIUrl.items.rawValue) else {
            XCTFail("URL is not correctly set.")
            return
        }

        URLProtocolMock.testURLs[itemURL] = FakeData.correctItemData
        URLProtocolMock.response = FakeData.responseKO

        await sut.getItems()
        XCTAssertEqual(expectedResponse, "getItemsDidFail")
    }

    private func controlItems(items: [Item]) {
        // First, we make sure that we have 4 items.
        XCTAssertEqual(items.count, 4)

        // We wake sure that the items are sorted, as it needs to be in our sut.
        XCTAssertEqual(items[0].id, 1582151024)
        XCTAssertEqual(items[1].id, 1671026575)
        XCTAssertEqual(items[2].id, 1702195622)
        XCTAssertEqual(items[3].id, 1701990438)
    }
}

// MARK: - DELEGATE
extension LeBonCoinTestTests: ItemsViewModelDelegate {
    func getItemsDidSucceed() {
        // We make sure the test trigger this method, and not the view's one.
        expectedResponse = "getItemsDidSucceed"

        // These properties should not be empty, we make sure the call completed successfully.
        XCTAssertFalse(sut.items.isEmpty)
        XCTAssertFalse(sut.filteredItems.isEmpty)
        XCTAssertFalse(sut.categories.isEmpty)

        controlItems(items: sut.items)
        controlItems(items: sut.filteredItems)
    }

    func getItemsDidFail(error: ErrorMessage) {
        expectedResponse = "getItemsDidFail"

        XCTAssertEqual(error, "The server returned an unexpected response. Please try again later.")
    }
}
