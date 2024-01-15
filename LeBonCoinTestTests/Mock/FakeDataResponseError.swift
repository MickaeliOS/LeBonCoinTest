//
//  FakeDataResponseError.swift
//  LeBonCoinTestTests
//
//  Created by Mickaël Horn on 12/01/2024.
//

import Foundation

final class FakeDataResponseError {
    // MARK: - DATA
    static var correctItemData: Data {
        let bundle = Bundle(for: FakeDataResponseError.self)
        let url = bundle.url(forResource: "Item", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }

    static var correctCategoryData: Data {
        let bundle = Bundle(for: FakeDataResponseError.self)
        let url = bundle.url(forResource: "Categories", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }

    // MARK: - RESPONSE
    static let responseOK = HTTPURLResponse(url: URL(string: "https://responseOK.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    static let responseKO = HTTPURLResponse(url: URL(string: "https://responseKO.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)!

    // MARK: - ERROR
    final class MockError: Error {}
    static let mockError = MockError()
}
