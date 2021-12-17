//
//  APIManager.swift
//  ItunesApi
//
//  Created by Halil Kaya on 21.11.2021.
//  Copyright © 2021 kaya. All rights reserved.
//

import Foundation

/// Generic API Call Manager
class APIManager {
    typealias RequestCompletionHandler = (Data?, NetworkError?) -> Void
    let session: URLSession
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    convenience init() {
        self.init(configuration: .default)
    }
    /// Generic request method
    /// - Parameters:
    ///   - request: URL Request Object
    ///   - completion: Completion Handler
    /// - Returns: ;URLSessionTask
    func requestTask(with request: URLRequest, completionHandler completion: @escaping RequestCompletionHandler) -> URLSessionDataTask {
        let task = session.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .requestFailed)
                return
            }
            if httpResponse.statusCode == 200 {
                if let data = data {
                    completion(data, nil)
                } else {
                    completion(nil, .invalidData)
                }
            } else {
                completion(nil, .responseUnsuccessful)
            }
        }
        return task
    }
}
