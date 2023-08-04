//
//  MovieHeaderTableViewCell.swift
//  MovieMiniProject
//
//  Created by Michael Iskandar on 04/08/23.
//

import UIKit
import SnapKit
import Then
import Kingfisher

class MovieHeaderTableViewCell: UITableViewCell {
    
    private let posterImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
    }
    
    private let nameLabel = UILabel().then {
        $0.numberOfLines = 3
        $0.font = .systemFont(ofSize: 24, weight: .semibold)
        $0.textColor = .black
        $0.sizeToFit()
    }
    
    private let popularityLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 12, weight: .semibold)
        $0.textColor = .systemGray
        $0.sizeToFit()
    }
    
    private let releaseDateLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 12, weight: .medium)
        $0.textColor = .systemGray2
        $0.sizeToFit()
    }
    
    private let overviewLabel = UILabel().then {
        $0.numberOfLines = 4
        $0.font = .systemFont(ofSize: 12, weight: .medium)
        $0.textColor = .systemGray3
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
    
    func configure(with item: Movie) {
        nameLabel.text = item.originalTitle
        popularityLabel.text = item.voteAverage == 0.0 ? "⭐️ No vote yet" : "⭐️ \(item.voteAverage)"
        if let url = URL(string: IMDB_IMAGE_PATH + item.posterPath) {
            posterImageView.kf.setImage(with: url)
        }
        releaseDateLabel.text = item.releaseDate
        overviewLabel.text = item.overview
    }
}

extension MovieHeaderTableViewCell {
    private func setupUI() {
        contentView.backgroundColor = .white
        selectionStyle = .none
        
        contentView.addSubview(posterImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(popularityLabel)
        contentView.addSubview(releaseDateLabel)
        contentView.addSubview(overviewLabel)
    }
    
    private func setupConstraints() {
        posterImageView.snp.makeConstraints { make in
            make.width.equalTo(120)
            make.height.equalTo(180)
            make.leading.top.equalToSuperview().offset(16)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView)
            make.leading.equalTo(posterImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        popularityLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(16)
            make.leading.equalTo(nameLabel)
        }
        
        releaseDateLabel.snp.makeConstraints { make in
            make.top.equalTo(popularityLabel.snp.bottom).offset(8)
            make.leading.equalTo(popularityLabel)
        }
        
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(releaseDateLabel.snp.bottom).offset(16)
            make.leading.equalTo(releaseDateLabel)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(contentView.snp.bottom).offset(-24)
        }
    }
}
