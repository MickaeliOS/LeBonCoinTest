//
//  ItemDetailsViewController.swift
//  LeBonCoinTest
//
//  Created by Mickaël Horn on 11/01/2024.
//

import UIKit

final class ItemDetailsViewController: UIViewController {

    // MARK: - UI ELEMENTS
    private lazy var headerStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, itemImageView, urgentLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 10
        return stack
    }()

    private lazy var footerStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [descriptionLabel, priceLabel, categoryLabel, dateLabel, idLabel])
        stack.axis = .vertical
        stack.spacing = 5
        return stack
    }()

    private let scrollView = UIScrollView()
    private let containerView = UIView()
    private let descriptionLabel = UILabel()
    private let titleLabel = UILabel()
    private let itemImageView = ItemImageView()
    private let urgentLabel = PaddingLabel()
    private let priceLabel = UILabel()
    private let categoryLabel = UILabel()
    private let dateLabel = UILabel()
    private let idLabel = UILabel()
    private let dividerView = DividerView()

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
        // Font
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        urgentLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        priceLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        categoryLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        dateLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        idLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)

        // Other
        if let item = item, item.isUrgent {
            urgentLabel.backgroundColor = .systemRed
            urgentLabel.layer.masksToBounds = true
            urgentLabel.layer.cornerRadius = 10
            urgentLabel.topInset = 10
            urgentLabel.bottomInset = 10
            urgentLabel.leftInset = 10
            urgentLabel.rightInset = 10
            urgentLabel.textColor = .white
            urgentLabel.textAlignment = .center
        }

        view.backgroundColor = .systemBackground
        priceLabel.textAlignment = .center
        categoryLabel.textAlignment = .center
        dateLabel.textAlignment = .center
        idLabel.textAlignment = .center
        itemImageView.contentMode = .scaleAspectFit
        itemImageView.layer.masksToBounds = true
        itemImageView.layer.cornerRadius = 10
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
    }

    private func setupConstraints() {
        setupScrollViewConstraints()
        setupContainerViewConstraints()
        setupStackViewsConstraints()
    }

    private func setupScrollViewConstraints() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupContainerViewConstraints() {
        scrollView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    private func setupStackViewsConstraints() {
        containerView.addSubview(headerStackView)
        containerView.addSubview(footerStackView)
        containerView.addSubview(dividerView)
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        footerStackView.translatesAutoresizingMaskIntoConstraints = false

        footerStackView.setCustomSpacing(30, after: descriptionLabel)

        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            headerStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            headerStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),

            dividerView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 15),
            dividerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            dividerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),

            footerStackView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 30),
            footerStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            footerStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            footerStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),

            itemImageView.heightAnchor.constraint(equalToConstant: 300),
        ])
    }

    private func setupItem() {
        guard let item else {
            return
        }

        if let imageStringUrl = item.imagesUrl.thumb {
            itemImageView.downloadImageFrom(urlString: imageStringUrl)
        } else {
            itemImageView.image = UIImage(systemName: "photo.fill")
        }

        titleLabel.text = item.title
        urgentLabel.text = item.isUrgent ? " Urgent ! " : ""
        descriptionLabel.text = "\(item.description)"
        priceLabel.text = "Prix : \(item.price.formattedBy2DigitsMax()) €"
        categoryLabel.text = "Catégorie : \(categoryName ?? "Unknown Category.")"
        dateLabel.text = "Date : \(itemManagement.formattedDate(date: item.creationDate))"
        idLabel.text = "ID : \(item.id)"
    }
}
