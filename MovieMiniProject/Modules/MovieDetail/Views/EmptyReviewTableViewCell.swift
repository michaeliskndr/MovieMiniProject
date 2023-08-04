//
//  EmptyReviewTableViewCell.swift
//  MovieMiniProject
//
//  Created by Michael Iskandar on 04/08/23.
//

import UIKit
import SnapKit
import Then

class EmptyTableViewCell: UITableViewCell {
    
    private let descriptionLabel: UILabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.text = "No User Review Yet"
    }
    
    private let emptyImageView: UIImageView = UIImageView().then {
        $0.image = .init(systemName: "xmark.square.fill")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .systemGray
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(emptyImageView)
    }
    
    private func setupConstraints() {
        emptyImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(60)
            make.top.equalToSuperview().offset(24)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyImageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-24)
        }
    }
}
