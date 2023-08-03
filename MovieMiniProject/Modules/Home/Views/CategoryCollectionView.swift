//
//  CategoryCollectionView.swift
//  MovieMiniProject
//
//  Created by Michael Iskandar on 03/08/23.
//

import UIKit
import SnapKit
import Then

class CategoryCollectionView: UICollectionView {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        self.showsHorizontalScrollIndicator = false
        self.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.itemSize = UICollectionViewFlowLayout.automaticSize
            layout.estimatedItemSize = .init(width: 200, height: 50)
            layout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 20)
        }
    }
    
}
