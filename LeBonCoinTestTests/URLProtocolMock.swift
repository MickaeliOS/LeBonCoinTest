//
//  URLProtocolMock.swift
//  LeBonCoinTestTests
//
//  Created by Mickaël Horn on 12/01/2024.
//

import Foundation

class URLProtocolMock: URLProtocol {
    // this dictionary maps URLs to test data
    static var testURLs = [URL?: Data]()
    static var response: HTTPURLResponse?
    static var error: Error?

    // say we want to handle all types of request
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    // ignore this method; just send back what we were given
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let error = URLProtocolMock.error  {
            self.client?.urlProtocol(self, didFailWithError: error)
            return
        }

        // if we have a valid URL…
        if let url = request.url {
            // …and if we have test data for that URL…
            if let data = URLProtocolMock.testURLs[url] {
                // …load it immediately.
                self.client?.urlProtocol(self, didLoad: data)
            }
        }

        if let response = URLProtocolMock.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }

        // mark that we've finished
        self.client?.urlProtocolDidFinishLoading(self)
    }

    // this method is required but doesn't need to do anything
    override func stopLoading() { }
}
