//
//  APIError.swift
//  MovieMiniProject
//
//  Created by Michael Iskandar on 03/08/23.
//

import Foundation

public enum APIError: Error {
    case decodeFailed
    case dataFailed
    case networkFailed
    case urlNotFound
    case defaultError
    
    var errorDescription: String {
        switch self {
        case .dataFailed: return "Data tidak ditemukan"
        case .networkFailed: return "Tidak terhubung dengan internet"
        case .decodeFailed: return "Gagal mapping data"
        case .urlNotFound: return "URL tidak ditemukan"
        case .defaultError: return "Error telah terjadi"
        }
    }
}
