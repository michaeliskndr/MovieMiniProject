//
//  AppDelegate.swift
//  MovieMiniProject
//
//  Created by Michael Iskandar on 03/08/23.
//

import UIKit
import netfox

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        #if DEBUG
        NFX.sharedInstance().start()
        #endif
        initializeWindow()
        return true
    }
}

extension AppDelegate {
    func initializeWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let homeViewController = HomeViewController()
        
        let router = HomeRouter()
        router.baseViewController = homeViewController
        
        let repository = DefaultHomeRepository()
        let interactor = HomeInteractor(repository: repository)
        let presenter = HomePresenter(interactor: interactor, router: router)
        
        homeViewController.presenter = presenter
        let navigationController = UINavigationController(rootViewController: homeViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

