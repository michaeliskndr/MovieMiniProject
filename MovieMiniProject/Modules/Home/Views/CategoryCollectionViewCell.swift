//
//  CategoryCollectionViewCell.swift
//  MovieMiniProject
//
//  Created by Michael Iskandar on 03/08/23.
//

import UIKit
import SnapKit
import Then

class CategoryCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: self)
    
    private let categoryLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.textAlignment = .center
        $0.lineBreakMode = .byWordWrapping
        $0.font = .systemFont(ofSize: 12, weight: .bold)
        $0.sizeToFit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    override var isSelected: Bool {
        didSet {
            self.layer.borderColor = isSelected ? UIColor.black.cgColor : UIColor.gray.withAlphaComponent(0.6).cgColor
            self.categoryLabel.textColor = isSelected ? UIColor.black : UIColor.gray.withAlphaComponent(0.6)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with item: Genre) {
        categoryLabel.text = item.name
    }
}

extension CategoryCollectionViewCell {
    private func setupUI() {
        self.contentView.backgroundColor = .white
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 0.8
        self.layer.borderColor = UIColor.gray.withAlphaComponent(0.6).cgColor
        self.categoryLabel.textColor = UIColor.gray.withAlphaComponent(0.6)
        self.clipsToBounds = true
        
        contentView.addSubview(categoryLabel)
    }
    
    private func setupConstraints() {
        categoryLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview().offset(-8)
            $0.trailing.equalToSuperview().offset(-8)
        }
    }
}
