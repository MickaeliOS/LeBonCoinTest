//
//  ItemDetailsViewController.swift
//  LeBonCoinTest
//
//  Created by Mickaël Horn on 11/01/2024.
//

import UIKit

class ItemDetailsViewController: UIViewController {

    // MARK: - UI ELEMENTS
    private lazy var headerStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, itemImageView, urgentLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 10
        return stack
    }()

    private lazy var footerStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [descriptionTextView, priceLabel, categoryLabel, dateLabel, idLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 15
        return stack
    }()

    private let titleLabel = UILabel()
    private let itemImageView = ItemImageView()
    private let urgentLabel = UILabel()
    private let descriptionTextView = UITextView()
    private let priceLabel = UILabel()
    private let categoryLabel = UILabel()
    private let dateLabel = UILabel()
    private let idLabel = UILabel()

    // MARK: - PROPERTIES
    private let itemManagement = ItemManagement()
    var item: Item?
    var categoryName: String?

    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIElements()
        setupConstraints()
        setupItem()
    }

    // MARK: - FUNCTIONS
    private func setupUIElements() {
        view.backgroundColor = .systemBackground

        // Font
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        urgentLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)

        descriptionTextView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        priceLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        categoryLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        dateLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        idLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)

        // Other
        urgentLabel.textColor = .red

        itemImageView.contentMode = .scaleAspectFit
        itemImageView.layer.masksToBounds = true
        itemImageView.layer.cornerRadius = 10
        itemImageView.backgroundColor = .red

        titleLabel.numberOfLines = 0

//        descriptionLabel.numberOfLines = 0

    }

    private func setupConstraints() {
        view.addSubview(headerStackView)
        view.addSubview(footerStackView)

        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        footerStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            headerStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            headerStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),

            footerStackView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 10),
            footerStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            footerStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            footerStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),

//            itemImageView.widthAnchor.constraint(equalToConstant: 170),
            itemImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    private func setupItem() {
        guard let item else {
            return
        }

        titleLabel.text = item.title
        urgentLabel.text = item.isUrgent ? "Urgent" : ""

        if let imageStringUrl = item.imagesUrl.thumb {
            itemImageView.downloadImageFrom(urlString: imageStringUrl)
        } else {
            itemImageView.image = UIImage(systemName: "photo.fill")
        }

        descriptionTextView.text = "Description : \(item.description)"
        priceLabel.text = "Prix : \(item.price.formattedBy2DigitsMax()) €"
        categoryLabel.text = "Catégorie : \(categoryName ?? "Unknown Category.")"
        dateLabel.text = "Date : \(item.creationDate)"
        idLabel.text = "ID : \(item.id)"
    }
}
