//
//  UITableView+Loading.swift
//  MovieMiniProject
//
//  Created by Michael Iskandar on 04/08/23.
//

import UIKit

extension UITableView {
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
