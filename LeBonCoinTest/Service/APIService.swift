//
//  APIService.swift
//  LeBonCoinTest
//
//  Created by Mickaël Horn on 10/01/2024.
//

import Foundation

protocol APIServiceProtocol {
    func fetchItems() async throws -> [Item]
}

final class APIService: APIServiceProtocol {
    // MARK: - ERROR HANDLING
    enum APIServiceError: Error {
        case invalidUrl
        case downloadFailed

        var errorDescription: String {
            switch self {
            case .invalidUrl:
                return "We're sorry, the URL is invalid."
            case .downloadFailed:
                return "The download failed, please try again."
            }
        }
    }

    // MARK: - PROPERTIES
    private let urlString = "https://raw.githubusercontent.com/leboncoin/paperclip/master/listing.json"
    private let decoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()

    // MARK: - FUNCTIONS
    func fetchItems() async throws -> [Item] {
        guard let url = URL(string: urlString) else {
            throw APIServiceError.invalidUrl
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let itemResponse = try decoder.decode([Item].self, from: data)
            let items = createItems(itemResponse: itemResponse)
            return items
        } catch {
            throw APIServiceError.downloadFailed
        }
    }

    private func createItems(itemResponse: [Item]) -> [Item] {
        var items: [Item] = []

        itemResponse.forEach { item in
            let item = Item(id: item.id,
                            categoryId: item.categoryId,
                            title: item.title,
                            description: item.description,
                            price: item.price,
                            imagesUrl: item.imagesUrl,
                            creationDate: item.creationDate,
                            isUrgent: item.isUrgent)

            items.append(item)
        }

        return items
    }
}
