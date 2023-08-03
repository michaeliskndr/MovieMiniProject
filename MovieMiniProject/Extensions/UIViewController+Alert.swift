//
//  UIViewController+Alert.swift
//  MovieMiniProject
//
//  Created by Michael Iskandar on 03/08/23.
//

import UIKit

extension UIViewController {
    func showAlert(_ message: String?) {
        let alertController = UIAlertController(title: "Mohon maaf terjadi kesalahan",
                                                message: message,
                                                preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}
