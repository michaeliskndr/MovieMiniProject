//
//  APIClient.swift
//  MovieMiniProject
//
//  Created by Michael Iskandar on 03/08/23.
//

import Alamofire
import RxSwift
import Foundation

public final class APIClient {
    static func request<T: Codable>(api: URLRequestConvertible, forModel model: T.Type) -> Single<T> {
        return Single<T>.create { observer -> Disposable in
            let manager = Session.default
            let request = manager.request(api)
            request.validate()
                .response { response in
                    switch response.response?.statusCode {
                    case .some(200..<300):
                        if let data = response.data {
                            do {
                                let result = try JSONDecoder().decode(model.self, from: data)
                                observer(.success(result))
                            } catch let error {
                                print(error)
                                observer(.failure(APIError.decodeFailed))
                            }
                        } else {
                            observer(.failure(APIError.dataFailed))
                        }
                    case .some(400..<500):
                        observer(.failure(APIError.networkFailed))
                    default:
                        observer(.failure(APIError.networkFailed))
                    }
                }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
