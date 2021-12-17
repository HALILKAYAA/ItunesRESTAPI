//
//  KindType.swift
//  ItunesApi
//
//  Created by Halil Kaya on 21.11.2021.
//  Copyright © 2021 kaya. All rights reserved.
//

import Foundation

public enum KindType: String, Codable {
    case book, album, pdf, podcast, song, artist
    case coached_audio = "coached-audio"
    case feature_movie = "feature-movie"
    case interactive_booklet = "interactive-booklet"
    case music_video = "music-video"
    case podcast_episode = "podcast-episode"
    case software_package = "software-package"
    case tv_episode = "tv-episode"
    case unknown
    
    public init(from decoder: Decoder) throws {
        self = try KindType(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
       }
}



