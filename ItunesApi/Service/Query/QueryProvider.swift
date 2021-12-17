//
//  QueryProvider.swift
//  ItunesApi
//
//  Created by Halil Kaya on 21.11.2021.
//  Copyright © 2021 kaya. All rights reserved.
//

import Foundation

protocol QueryProvider {
    var queryItem: URLQueryItem { get }
}
