//
//  APIConfig.swift
//  MovieMiniProject
//
//  Created by Michael Iskandar on 03/08/23.
//

import Alamofire
import Foundation

public protocol APIConfig: URLRequestConvertible {
    var baseURL: String { get }
    var headers: HTTPHeaders { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
    var parameterEncoding: ParameterEncoding { get }
}

extension APIConfig {
    public var baseURL: String {
        return "https://api.themoviedb.org/3"
    }
    
    public var headers: HTTPHeaders {
        return HTTPHeaders([
            HTTPHeader(name: "Authorization", value: "Bearer \(API_KEY)"),
            HTTPHeader(name: "Content-Type", value: "application/json")
        ])
    }
    
    public var method: HTTPMethod {
        return .get
    }
    
    public var parameters: Parameters? {
        nil
    }
    
    public var parameterEncoding: ParameterEncoding {
        return Alamofire.URLEncoding.default
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = baseURL + path
        let urlRequest = try URLRequest(url: url, method: method, headers: headers)
        return try parameterEncoding.encode(urlRequest, with: parameters)
    }
}
