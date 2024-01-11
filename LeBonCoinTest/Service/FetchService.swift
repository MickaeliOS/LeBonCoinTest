//
//  FetchService.swift
//  LeBonCoinTest
//
//  Created by Mickaël Horn on 11/01/2024.
//

import Foundation

protocol FetchServiceProtocol {
    func fetch<T: Decodable>(url: APIUrl) async throws -> [T]
}

final class FetchService: FetchServiceProtocol {

    // MARK: - PROPERTIES
    private let decoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()

    // MARK: - ERROR HANDLING
    enum FetchError: Error {
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

    // MARK: - FUNCTIONS
    func fetch<T: Decodable>(url: APIUrl) async throws -> [T] {
        guard let url = URL(string: url.rawValue) else {
            throw FetchError.invalidUrl
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedData = try decoder.decode([T].self, from: data)
            return decodedData
        } catch {
            throw FetchError.downloadFailed
        }
    }
}
