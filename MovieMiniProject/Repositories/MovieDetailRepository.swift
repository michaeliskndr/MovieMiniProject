//
//  MovieDetailRepository.swift
//  MovieMiniProject
//
//  Created by Michael Iskandar on 03/08/23.
//

import RxSwift

public protocol MovieDetailRepository {
    func fetchMovieDetail(id: Int) -> Single<Movie>
    func fetchMovieReviews(id: Int) -> Single<ReviewResponse>
}

struct DefaultMovieDetailRepository: MovieDetailRepository {
    func fetchMovieDetail(id: Int) -> Single<Movie> {
        return APIClient.request(api: MovieAPI.getMovieDetail(id: id), forModel: Movie.self)
    }
    
    func fetchMovieReviews(id: Int) -> Single<ReviewResponse> {
        return APIClient.request(api: MovieAPI.getMovieReviews(id: id), forModel: ReviewResponse.self)
    }
}
