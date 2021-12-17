//
//  WrapperResponseModel.swift
//  ItunesApi
//
//  Created by Halil Kaya on 21.11.2021.
//  Copyright © 2021 kaya. All rights reserved.
//

import Foundation


/// Wrapper response model
struct WrapperResponseModel<T: Codable>: Codable {
    let resultCount: Int?
    let results: [T]?
    
    enum CodinKeys: String, CodingKey {
        case resultCount = "resultCount"
        case results = "results"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodinKeys.self)
        resultCount = try values.decodeIfPresent(Int.self, forKey: .resultCount)
        results = try values.decodeIfPresent([T].self, forKey: .results)
    }
}
