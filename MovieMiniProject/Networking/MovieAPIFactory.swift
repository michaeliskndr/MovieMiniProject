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
    
    public var path: String {
        switch self {
        case .getMoviesByGenre:
            return "/discover/movie"
        case .getMovieGenres:
            return "/genre/movie/list"
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
