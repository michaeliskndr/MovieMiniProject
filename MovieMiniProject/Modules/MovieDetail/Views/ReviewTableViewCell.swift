//
//  ReviewTableViewCell.swift
//  MovieMiniProject
//
//  Created by Michael Iskandar on 04/08/23.
//

import UIKit
import SnapKit
import Then
import Kingfisher

class ReviewTableViewCell: UITableViewCell {
    
    private let avatarImageView = UIImageView().then {
        $0.snp.makeConstraints { make in
            make.size.equalTo(60)
        }
        $0.tintColor = .systemGray
        $0.layer.cornerRadius = 30
        $0.clipsToBounds = true
    }
    
    private let nameLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.sizeToFit()
    }
    
    private let reviewLabel = UILabel().then {
        $0.numberOfLines = 8
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.sizeToFit()
    }
    
    private let ratingLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.textColor = .black
        $0.sizeToFit()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(with item: Review) {
        let isNameEmpty = item.authorDetails.name.isEmpty
        nameLabel.text = isNameEmpty ? "Guest" : item.authorDetails.name
        ratingLabel.text = item.authorDetails.rating ?? 0 == 0 ? "⭐️ No vote yet" : "⭐️ \(item.authorDetails.rating ?? 0)"
        if let avatarPath = item.authorDetails.avatarPath,
           let url = URL(string: IMDB_IMAGE_PATH + avatarPath) {
            avatarImageView.kf.setImage(with: url, placeholder: UIImage.init(systemName: "person.circle.fill"))
        } else {
            avatarImageView.image = .init(systemName: "person.circle.fill")
        }
        reviewLabel.text = item.content
    }
}

extension ReviewTableViewCell {
    private func setupUI() {
        self.contentView.backgroundColor = .white
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(reviewLabel)
        contentView.addSubview(ratingLabel)
    }
    
    private func setupConstraints() {
        avatarImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(8)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.trailing).offset(4)
            make.centerY.equalTo(nameLabel)
            make.trailing.greaterThanOrEqualToSuperview().offset(-16)
        }
        
        reviewLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
}
