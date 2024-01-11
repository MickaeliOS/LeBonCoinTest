//
//  ItemsViewModel.swift
//  LeBonCoinTest
//
//  Created by Mickaël Horn on 10/01/2024.
//

import Foundation

final class ItemsViewModel {

    // MARK: - PROPERTIES
    weak var delegate: ItemsViewModelDelegate?
    private let fetchService: FetchServiceProtocol
    private var items: [Item] = []
    var filteredItems: [Item] = []
    var categories: [Category] = []

    // MARK: - INIT
    init(fetchService: FetchServiceProtocol = FetchService()) {
        self.fetchService = fetchService
    }

    // MARK: - FUNCTIONS
    @MainActor
    func getItems() async {
        do {
            let fetchedItems: [Item] = try await fetchService.fetch(url: .items)
            categories = try await fetchService.fetch(url: .category)

            // We need to sort the items by creationDate and if it's urgent or not.
            let sortedItems = sortItemsByUrgencyAndDateDescending(fetchedItems)

            items = sortedItems
            filteredItems = sortedItems

            delegate?.getItemsDidSucceed()
        } catch let error as FetchService.FetchError {
            delegate?.getItemsDidFail(error: error.errorDescription)
        } catch {
            delegate?.getItemsDidFail(error: "Something went wrong.")
        }
    }

    func filterItemsBy(categoryName: String) {
        guard let categoryIndex = categories.firstIndex(where: { $0.name == categoryName }) else {
            return
        }

        let categoryId = categories[categoryIndex].id

        filteredItems = items.filter({ item in
            item.categoryId == categoryId
        })
    }

    func resetFilter() {
        filteredItems = items
    }

    private func sortItemsByUrgencyAndDateDescending(_ items: [Item]) -> [Item] {
        return items.sorted { item1, item2 in
            if item1.isUrgent && !item2.isUrgent {
                return true
            } else if !item1.isUrgent && item2.isUrgent {
                return false
            } else {
                return item1.creationDate > item2.creationDate
            }
        }
    }
}

// MARK: - PROTOCOL
protocol ItemsViewModelDelegate: AnyObject {
    typealias ErrorMessage = String

    func getItemsDidSucceed()
    func getItemsDidFail(error: ErrorMessage)
}
