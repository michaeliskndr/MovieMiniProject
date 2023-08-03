//
//  AppDelegate.swift
//  MovieMiniProject
//
//  Created by Michael Iskandar on 03/08/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initializeWindow()
        return true
    }
}

extension AppDelegate {
    func initializeWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let repository = DefaultHomeRepository()
        let interactor = HomeInteractor(repository: repository)
        let presenter = HomePresenter(interactor: interactor)
        let homeViewController = HomeViewController(presenter: presenter)
        let navigationController = UINavigationController(rootViewController: homeViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

