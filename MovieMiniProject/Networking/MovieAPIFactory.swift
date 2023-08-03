//
//  MovieAPIFactory.swift
//  MovieMiniProject
//
//  Created by Michael Iskandar on 03/08/23.
//

import Foundation
import Alamofire

public enum MovieAPI: APIConfig {
    case getMovieGenres
    case getMoviesByGenre(page: Int, genre: Int)
    case getMovieReviews(id: Int)
    case getMovieDetail(id: Int)
    case getMovieTrailer(id: Int)
    
    public var path: String {
        switch self {
        case .getMoviesByGenre:
            return "/discover/movie"
        case .getMovieGenres:
            return "/genre/movie/list"
        case .getMovieReviews(let id):
            return "/movie/\(id)/reviews"
        case .getMovieDetail(let id):
            return "movie/\(id)"
        case .getMovieTrailer(let id):
            return "/movie/\(id)/videos"
        }
    }
    
    public var parameters: Parameters? {
        switch self {
        case .getMoviesByGenre(let page, let genre):
            return [
                "region": "id",
                "page": page,
                "with_genres": genre
            ]
        default: return nil
        }
    }
}
