//
//  MovieResponse.swift
//  MovieMiniProject
//
//  Created by Michael Iskandar on 03/08/23.
//

import Foundation

//MARK: - MovieResponse
public struct MovieResponse: Codable, Hashable {
    var page: Int
    var results: [Movie]
    var totalPages: Int
    var totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
    
    public init(page: Int, results: [Movie], totalPages: Int, totalResults: Int) {
        self.page = page
        self.results = results
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
}

// MARK: - Movie
public struct Movie: Codable, Hashable {
    var id: Int
    var originalTitle: String
    var popularity: Double
    var voteAverage: Double
    var posterPath: String
    var title: String
    var overview: String
    var releaseDate: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case originalTitle = "original_title"
        case popularity
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
        case title
        case overview
        case releaseDate = "release_date"
    }
    
    public init(id: Int,
                originalTitle: String,
                popularity: Double,
                voteAverage: Double,
                posterPath: String,
                title: String,
                overview: String,
                releaseDate: String) {
        self.id = id
        self.originalTitle = originalTitle
        self.popularity = popularity
        self.voteAverage = voteAverage
        self.posterPath = posterPath
        self.title = title
        self.overview = overview
        self.releaseDate = releaseDate
    }
}
