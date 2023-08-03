//
//  MovieResponse.swift
//  MovieMiniProject
//
//  Created by Michael Iskandar on 03/08/23.
//

import Foundation

//MARK: - MovieResponse
public class MovieResponse: Codable {
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
public class Movie: Codable {
    var id: Int
    var originalTitle: String
    var popularity: Double
    var voteAverage: Double
    var posterPath: String
    var title: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case originalTitle = "original_title"
        case popularity
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
        case title
    }
    
    public init(id: Int,
                originalTitle: String,
                popularity: Double,
                voteAverage: Double,
                posterPath: String,
                title: String) {
        self.id = id
        self.originalTitle = originalTitle
        self.popularity = popularity
        self.voteAverage = voteAverage
        self.posterPath = posterPath
        self.title = title
    }
}

// MARK: - MovieCategory
public enum MovieCategory: Int, CaseIterable {
    case upcoming
    case toprated
    case popular
    case nowPlaying
    
    var description: String {
        switch self {
        case .upcoming: return "Upcoming"
        case .toprated: return "Top Rated"
        case .popular: return "Popular"
        case .nowPlaying: return "Now Playing"
        }
    }
}
