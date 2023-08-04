//
//  MovieDetailInteractor.swift
//  MovieMiniProject
//
//  Created by Michael Iskandar on 04/08/23.
//

import RxSwift

public protocol MovieDetailInteractorProtocol {
    func fetchMovieDetail(id: Int) -> Single<Movie>
    func fetchMovieReviews(id: Int, page: Int) -> Single<ReviewResponse>
}

public final class MovieDetailInteractor {
    
    var repository: MovieDetailRepository
    
    init(repository: MovieDetailRepository) {
        self.repository = repository
    }
}

extension MovieDetailInteractor: MovieDetailInteractorProtocol {
    public func fetchMovieDetail(id: Int) -> Single<Movie> {
        repository.fetchMovieDetail(id: id)
    }
    
    public func fetchMovieReviews(id: Int, page: Int) -> Single<ReviewResponse> {
        repository.fetchMovieReviews(id: id, page: page)
    }
}
