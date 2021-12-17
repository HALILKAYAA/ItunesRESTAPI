//
//  QueryEntity.swift
//  ItunesApi
//
//  Created by Halil Kaya on 21.11.2021.
//  Copyright © 2021 kaya. All rights reserved.
//

import Foundation

protocol QueryEntity: QueryProvider {
    var entityName: String { get }
}

extension QueryEntity {
    var queryItem: URLQueryItem {
        return URLQueryItem(name: "entity", value: entityName)
    }
}

enum MovieEntity: String, QueryEntity {
    case movieArtist
    case movie
    
    var entityName: String {
        return self.rawValue
    }
}

enum PodcastEntity: String, QueryEntity {
    case podcastAuthor
    case podcast
    
    var entityName: String {
        return self.rawValue
    }
}

enum MusicEntity: String, QueryEntity {
    case musicArtist
    case musicTrack
    case album
    case musicVideo
    case mix
    case song
    
    var entityName: String {
        return self.rawValue
    }
}

enum MusicVideoEntity: String, QueryEntity {
    case musicArtist
    case musicVideo
    
    var entityName: String {
        return self.rawValue
    }
}

enum AudiobookEntity: String, QueryEntity {
    case audiobookAuthor
    case audiobook
    
    var entityName: String {
        return self.rawValue
    }
}

enum ShortFilmEntity: String, QueryEntity {
    case shortFilmArtist
    case shortFilm
    
    var entityName: String {
        return self.rawValue
    }
}

enum TVShowEntity: String, QueryEntity {
    case tvEpisode
    case tvSeason
    
    var entityName: String {
        return self.rawValue
    }
}

enum SoftwareEntity: String, QueryEntity {
    case software
    case iPadSoftware
    case macSoftware
    
    var entityName: String {
        return self.rawValue
    }
}

enum EbookEntity: String, QueryEntity {
    case ebook
    
    var entityName: String {
        return self.rawValue
    }
}

enum AllEntity: String, QueryEntity {
    case movie
    case album
    case allArtist
    case podcast
    case musicVideo
    case mix
    case audiobook
    case tvSeason
    case allTrack
    
    var entityName: String {
        return self.rawValue
    }
}
