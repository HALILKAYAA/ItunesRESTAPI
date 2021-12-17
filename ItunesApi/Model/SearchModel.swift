//
//  SearchModel.swift
//  ItunesApi
//
//  Created by Sehmus GOKCE on 12.05.2020.
//  Copyright © 2020 Sehmus GOKCE. All rights reserved.
//

import Foundation

struct SearchResponseModel: Codable {
    let wrapperType: WrapperType
    let kind: String?
    let artistID: Int
    let collectionID: Int?
    let trackID: Int?
    let artistName: String
    let collectionName: String?
    let trackName: String
    let collectionCensoredName: String?
    let trackCensoredName: String
    let artistViewURL: String
    let collectionViewURL: String?
    let trackViewURL: String
    let previewURL: String
    let artworkUrl30, artworkUrl60, artworkUrl100: String?
    let collectionPrice, trackPrice: Double
    let releaseDate: String
    let collectionExplicitness, trackExplicitness: String
    let discCount, discNumber, trackCount, trackNumber: Int?
    let trackTimeMillis: Int
    let country: String
    let currency: String
    let primaryGenreName: String

    enum CodingKeys: String, CodingKey {
        case wrapperType, kind
        case artistID = "artistId"
        case collectionID = "collectionId"
        case trackID = "trackId"
        case artistName, collectionName, trackName, collectionCensoredName, trackCensoredName
        case artistViewURL = "artistViewUrl"
        case collectionViewURL = "collectionViewUrl"
        case trackViewURL = "trackViewUrl"
        case previewURL = "previewUrl"
        case artworkUrl30, artworkUrl60, artworkUrl100, collectionPrice, trackPrice, releaseDate, collectionExplicitness, trackExplicitness, discCount, discNumber, trackCount, trackNumber, trackTimeMillis, country, currency, primaryGenreName
    }
}
