//
//  UICollectionView.swift
//  MovieMiniProject
//
//  Created by Michael Iskandar on 03/08/23.
//

import UIKit

extension UICollectionView {
    func toggleLoading(_ isLoading: Bool) {
        if isLoading {
            let activityIndicatorView = UIActivityIndicatorView()
            activityIndicatorView.startAnimating()
            self.backgroundView = activityIndicatorView
        } else {
            self.backgroundView = nil
        }
    }
}
