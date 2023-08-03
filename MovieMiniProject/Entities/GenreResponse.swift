//
//  GenreResponse.swift
//  MovieMiniProject
//
//  Created by Michael Iskandar on 03/08/23.
//

import Foundation

// MARK: - GenreResponse
public struct GenreResponse: Codable {
    let genres: [Genre]
}

// MARK: - Genre
public struct Genre: Codable {
    let id: Int
    let name: String
}
