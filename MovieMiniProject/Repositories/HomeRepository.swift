//
//  HomeRepository.swift
//  MovieMiniProject
//
//  Created by Michael Iskandar on 03/08/23.
//

import RxSwift

public protocol HomeRepository {
    func fetchMovieGenres() -> Single<GenreResponse>
    func fetchMovie(page: Int, genre: Genre) -> Single<MovieResponse>
}

struct DefaultHomeRepository: HomeRepository {
    func fetchMovieGenres() -> Single<GenreResponse> {
        return APIClient.request(api: MovieAPI.getMovieGenres, forModel: GenreResponse.self)
    }
    
    func fetchMovie(page: Int, genre: Genre) -> RxSwift.Single<MovieResponse> {
        return APIClient.request(api: MovieAPI.getMoviesByGenre(page: page, genre: genre.id),
                                 forModel: MovieResponse.self)
    }
}
