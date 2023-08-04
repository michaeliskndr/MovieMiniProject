//
//  SectionTableVIewCell.swift
//  MovieMiniProject
//
//  Created by Michael Iskandar on 04/08/23.
//

import UIKit
import SnapKit
import Then

class SectionTableViewCell: UITableViewCell {
    
    private lazy var titleLabel: UILabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.text = "User Review"
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
        selectionStyle = .none

        contentView.addSubview(titleLabel)
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
}
