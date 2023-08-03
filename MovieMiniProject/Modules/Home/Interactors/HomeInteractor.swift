//
//  HomeInteractor.swift
//  MovieMiniProject
//
//  Created by Michael Iskandar on 03/08/23.
//

import RxSwift

public protocol HomeInteractorProtocol {
    func fetchMovieGenres() -> Single<GenreResponse>
    func fetchMovie(page: Int, genre: Genre) -> Single<MovieResponse>
}

public final class HomeInteractor {
    
    var repository: HomeRepository
    
    public init(repository: HomeRepository) {
        self.repository = repository
    }
}

extension HomeInteractor: HomeInteractorProtocol {
    public func fetchMovieGenres() -> Single<GenreResponse> {
        repository.fetchMovieGenres()
    }
    
    public func fetchMovie(page: Int, genre: Genre) -> Single<MovieResponse> {
        repository.fetchMovie(page: page, genre: genre)
    }
}
