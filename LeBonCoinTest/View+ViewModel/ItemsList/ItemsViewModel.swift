//
//  ItemsViewModel.swift
//  LeBonCoinTest
//
//  Created by Mickaël Horn on 10/01/2024.
//

import Foundation

final class ItemsViewModel {
    weak var delegate: ItemsViewModelDelegate?
    private let apiService: APIServiceProtocol

    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }

    @MainActor
    func getItems() async {
        do {
            let items = try await apiService.fetchItems()
            delegate?.getItemsDidSucceed(items: items)
        } catch let error as APIService.APIServiceError {
            delegate?.getItemsDidFail(error: error.errorDescription)
        } catch {
            delegate?.getItemsDidFail(error: "Something went wrong.")
        }
    }
}

protocol ItemsViewModelDelegate: AnyObject {
    typealias ErrorMessage = String

    func getItemsDidSucceed(items: [Item])
    func getItemsDidFail(error: ErrorMessage)
}
