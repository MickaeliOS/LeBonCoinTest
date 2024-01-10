//
//  ItemTableViewCell.swift
//  LeBonCoinTest
//
//  Created by Mickaël Horn on 10/01/2024.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    // MARK: - UI ELEMENTS
    private let itemImageView = ItemImageView()
    private let categoryLabel = UILabel()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let urgentLabel = UILabel()
    
    // MARK: - INIT
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented.")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let bottomSpace: CGFloat = 5
        let leftSpace: CGFloat = 10
        let rightSpace: CGFloat = 10
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: leftSpace, bottom: bottomSpace, right: rightSpace))
    }
    
    // MARK: - FUNCTIONS
    func configure(imageStringUrl: String?, category: Int, title: String, price: Double, isUrgent: Bool) {
        categoryLabel.text = "Catégorie : \(category)"
        titleLabel.text = title
        priceLabel.text = "Prix : \(formattedPrice(price: price)) €"
        urgentLabel.text = isUrgent ? "Urgent" : ""
        
        if let imageStringUrl = imageStringUrl {
            itemImageView.downloadImageFrom(urlString: imageStringUrl)
        } else {
            itemImageView.image = UIImage(systemName: "photo.fill")
        }
    }
    
    private func setupUI() {
        setupContentView()
        setupUIElements()
    }
    
    private func setupContentView() {
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.cornerRadius = 10
    }
    
    private func setupUIElements() {
        addSubview()
        
        // Font
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        categoryLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        priceLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        urgentLabel.font = UIFont.systemFont(ofSize: 14, weight: .thin)
        
        // Other
        urgentLabel.textColor = .red
        itemImageView.contentMode = .scaleAspectFit
        titleLabel.numberOfLines = 0
        
        activateConstraints()
    }
    
    private func addSubview() {
        [itemImageView, categoryLabel, titleLabel, priceLabel, urgentLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            // Image
            itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            itemImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            itemImageView.widthAnchor.constraint(equalToConstant: 100),
            itemImageView.heightAnchor.constraint(equalToConstant: 100),
            
            // Urgent
            urgentLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            urgentLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 10),
            urgentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: urgentLabel.bottomAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            // Category
            categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            categoryLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 10),
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            // Price
            priceLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 5),
            priceLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 10),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ])
    }
    
    private func formattedPrice(price: Double) -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        
        let number = NSNumber(value: price)
        return formatter.string(from: number)!
    }
}
