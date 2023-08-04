//
//  HomeRouter.swift
//  MovieMiniProject
//
//  Created by Michael Iskandar on 04/08/23.
//

import UIKit

public protocol HomeRouterProtocol {
    func routeToMovieDetail(id: Int)
}

class HomeRouter: HomeRouterProtocol {
    
    var baseViewController: UIViewController?
        
    func routeToMovieDetail(id: Int) {
        let repository = DefaultMovieDetailRepository()
        let interactor = MovieDetailInteractor(repository: repository)
        let presenter = MovieDetailPresenter(movieId: id, interactor: interactor)
        
        let vc = MovieDetailViewController()
        vc.presenter = presenter
        baseViewController?.navigationController?.pushViewController(vc, animated: true)
    }
}


