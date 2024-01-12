//
//  FetchService.swift
//  LeBonCoinTest
//
//  Created by Mickaël Horn on 11/01/2024.
//

import Foundation

final class FetchService {

    // MARK: - PROPERTIES
    var session: URLSession

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
        case badResponse

        var errorDescription: String {
            switch self {
            case .invalidUrl:
                return "We're sorry, the URL is invalid."
            case .badResponse:
                return "The server returned an unexpected response. Please try again later."
            case .downloadFailed:
                return "The download failed, please try again."
            }
        }
    }

    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }

    // MARK: - FUNCTIONS
    func fetch<T: Decodable>(url: APIUrl) async throws -> [T] {
        guard let url = URL(string: url.rawValue) else {
            throw FetchError.invalidUrl
        }

        let (data, response) = try await session.data(from: url)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw FetchError.badResponse
        }

        let decodedData = try decoder.decode([T].self, from: data)
        return decodedData
    }
}
