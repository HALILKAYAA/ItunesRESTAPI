//
//  FilterType.swift
//  ItunesApi
//
//  Created by Halil Kaya on 21.11.2021.
//  Copyright © 2021 kaya. All rights reserved.
//

import Foundation

public enum FilterType: Int {
    case song, movie, podcast, all
}

extension FilterType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .song:
            return "filter.type.song".localized
        case .movie:
            return "filter.type.movie".localized
        case .podcast:
            return "filter.type.podcast".localized
        case .all:
            return "filter.type.all".localized
        }
    }
}
