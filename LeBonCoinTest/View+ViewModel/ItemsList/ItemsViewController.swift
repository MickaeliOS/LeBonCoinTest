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
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    private let itemsList: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)

        tableView.separatorStyle = .none
        tableView.register(ItemTableViewCell.self, forCellReuseIdentifier: "ItemTableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()

    // MARK: - PROPERTIES
    private var items: [Item] = []
    private let viewModel = ItemsViewModel()

    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupItemsViewController()
        setupCategoryButton()
        setupTableView()
        getItems()

        viewModel.delegate = self
    }

    // MARK: - FUNCTIONS
    private func setupItemsViewController() {
        view.backgroundColor = .systemBackground
    }

    private func setupCategoryButton() {
        setupUICategoryButon()
        setupCategoryMenu()
    }

    private func setupUICategoryButon() {

        // Ajouter une action
        // categoryButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        // Ajouter le bouton à la vue
        view.addSubview(categoryButton)

        // Contraintes Auto Layout (si utilisé)
        NSLayoutConstraint.activate([
            categoryButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            categoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            categoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            categoryButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupCategoryMenu() {
        let optionClosure = { (action: UIAction) in
            print(action.title)
        }

        categoryButton.menu = UIMenu(children: [
            UIAction(title: "Option1", state: .on, handler: optionClosure),
            UIAction(title: "Option2", handler: optionClosure),
            UIAction(title: "Option3", handler: optionClosure)
        ])

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
}

// MARK: - TABLE VIEW DELEGATE & DATASOURCE
extension ItemsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(140)
    }

    /*func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }*/

    /*func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // 1
        let headerView = UIView()
        // 2
        headerView.backgroundColor = view.backgroundColor
        // 3
        return headerView
    }*/
}

extension ItemsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell", for: indexPath) as? ItemTableViewCell else {
            return UITableViewCell()
        }

        let item = items[indexPath.row]
        cell.configure(imageStringUrl: item.imagesUrl.small,
                       category: item.categoryId,
                       title: item.title,
                       price: item.price,
                       isUrgent: item.isUrgent)

        return cell
    }
}

extension ItemsViewController: ItemsViewModelDelegate {
    func getItemsDidSucceed(items: [Item]) {
        //DispatchQueue.main.async {
                    self.items = items
                    self.itemsList.reloadData()
                //}
    }
    
    func getItemsDidFail(error: ErrorMessage) {
        presentAlert(with: error)
    }
}
