//
//  ItemTableViewCell.swift
//  LeBonCoinTest
//
//  Created by Mickaël Horn on 10/01/2024.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    // MARK: - UI ELEMENTS
    private lazy var verticalStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [urgentLabel, titleLabel, categoryLabel, priceLabel])
        stack.axis = .vertical
        stack.spacing = 5
        return stack
    }()

    private lazy var horizontalStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [itemImageView, verticalStackView])
        stack.axis = .horizontal
        stack.spacing = 5
        stack.alignment = .center
        stack.distribution = .fillProportionally
        return stack
    }()

    private let itemImageView = ItemImageView()
    private let categoryLabel = UILabel()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let urgentLabel = UILabel()

    // MARK: - INIT
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        setupUIElements()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented.")
    }

    // MARK: - FUNCTIONS
    func configure(imageStringUrl: String?, category: String, title: String, price: Double, isUrgent: Bool) {
        categoryLabel.text = "Catégorie : \(category)"
        titleLabel.text = title
        priceLabel.text = "Prix : \(price.formattedBy2DigitsMax()) €"
        urgentLabel.text = isUrgent ? "Urgent" : ""

        if let imageStringUrl = imageStringUrl {
            itemImageView.downloadImageFrom(urlString: imageStringUrl)
        } else {
            itemImageView.image = UIImage(systemName: "photo.fill")
        }
    }

    private func setupConstraints() {
        contentView.addSubview(horizontalStackView)
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            itemImageView.widthAnchor.constraint(equalToConstant: 100),
            itemImageView.heightAnchor.constraint(equalTo: itemImageView.widthAnchor),
        ])
    }

    private func setupUIElements() {
        // Font
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        categoryLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        priceLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        urgentLabel.font = UIFont.systemFont(ofSize: 14, weight: .thin)

        // Other
        urgentLabel.textColor = .red
        itemImageView.contentMode = .scaleAspectFit
        itemImageView.layer.masksToBounds = true
        itemImageView.layer.cornerRadius = 10
        titleLabel.numberOfLines = 0
    }
}
