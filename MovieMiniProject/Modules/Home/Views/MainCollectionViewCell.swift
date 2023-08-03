//
//  MainCollectionViewCell.swift
//  MovieMiniProject
//
//  Created by Michael Iskandar on 03/08/23.
//

import UIKit
import SnapKit
import Then
import Kingfisher

class MainCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: self)
    
    private lazy var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private let nameLabel = UILabel().then {
        $0.numberOfLines = 3
        $0.font = .systemFont(ofSize: 12, weight: .semibold)
        $0.textColor = .black
        $0.sizeToFit()
    }
    
    private let popularityLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.textColor = .black
        $0.sizeToFit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with item: Movie) {
        nameLabel.text = item.originalTitle
        popularityLabel.text = item.voteAverage == 0.0 ? "⭐️ No vote yet" : "⭐️ \(item.voteAverage)"
        if let url = URL(string: IMDB_IMAGE_PATH + item.posterPath) {
            imageView.kf.setImage(with: url)
        }
    }
}

extension MainCollectionViewCell {
    private func setupUI() {
        self.contentView.backgroundColor = .white
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 0.5
        self.layer.borderColor = .init(gray: 0.6, alpha: 1)
        self.clipsToBounds = true
        
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(popularityLabel)
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.height.equalTo(180)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-8)
        }
        
        popularityLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(nameLabel.snp.leading)
            $0.trailing.equalTo(nameLabel.snp.trailing)
            $0.bottom.greaterThanOrEqualToSuperview().offset(-8).priority(.low)
        }
    }
}
