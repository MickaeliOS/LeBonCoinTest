//
//  ViewController.swift
//  LeBonCoinTest
//
//  Created by Mickaël Horn on 10/01/2024.
//

import UIKit

class ItemsViewController: UIViewController {

    // MARK: - UI ELEMENTS
    private let categoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Category", for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reset Filter", for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let itemsList: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)

        tableView.register(ItemTableViewCell.self, forCellReuseIdentifier: "ItemTableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()

    private lazy var buttonsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [resetButton, categoryButton])
        stack.axis = .horizontal
        stack.spacing = 5
        stack.distribution = .fillEqually
        return stack
    }()

    // MARK: - PROPERTIES
    private let viewModel = ItemsViewModel()
    private let itemManagement = ItemManagement()

    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        getItems()
        setupUI()
        configureResetButton()
        viewModel.delegate = self
    }

    // MARK: - FUNCTIONS
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupButtonsStackView()
        setupTableView()
    }

    private func setupButtonsStackView() {
        view.addSubview(buttonsStackView)
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            buttonsStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),

            resetButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupCategoryMenu() {
        let optionClosure = { [weak self] (action: UIAction) in
            guard let self else { return }
            self.viewModel.filterItemsBy(categoryName: action.title)
            itemsList.reloadData()
        }

        var actions: [UIAction] = []

        viewModel.categories.forEach { category in
            actions.append(UIAction(title: category.name, handler: optionClosure))
        }

        categoryButton.menu = UIMenu(children: actions)
        categoryButton.showsMenuAsPrimaryAction = true
    }

    private func setupTableView() {
        itemsList.delegate = self
        itemsList.dataSource = self

        view.addSubview(itemsList)

        NSLayoutConstraint.activate([
            itemsList.topAnchor.constraint(equalTo: categoryButton.bottomAnchor, constant: 10),
            itemsList.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            itemsList.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            itemsList.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }

    private func getItems() {
        Task {
            await viewModel.getItems()
        }
    }

    private func configureResetButton() {
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
    }

    @objc func resetButtonTapped() {
        viewModel.resetFilter()
        itemsList.reloadData()
    }
}

// MARK: - TABLE VIEW DELEGATE & DATASOURCE
extension ItemsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemDetailsViewController = ItemDetailsViewController()
        itemDetailsViewController.item = viewModel.filteredItems[indexPath.row]
        itemDetailsViewController.categoryName = itemManagement.getCategoryName(categories: viewModel.categories,
                                                                                categoryId: viewModel.filteredItems[indexPath.row].categoryId)

        navigationController?.pushViewController(itemDetailsViewController, animated: true)
    }
}

extension ItemsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell", for: indexPath) as? ItemTableViewCell else {
            return UITableViewCell()
        }

        let item = viewModel.filteredItems[indexPath.row]
        cell.configure(imageStringUrl: item.imagesUrl.thumb,
                       category: itemManagement.getCategoryName(categories: viewModel.categories, categoryId: item.categoryId),
                       title: item.title,
                       price: item.price,
                       isUrgent: item.isUrgent)

        return cell
    }
}

extension ItemsViewController: ItemsViewModelDelegate {
    func getItemsDidSucceed() {
        setupCategoryMenu()
        itemsList.reloadData()
    }

    func getItemsDidFail(error: ErrorMessage) {
        presentAlert(with: error)
    }
}
