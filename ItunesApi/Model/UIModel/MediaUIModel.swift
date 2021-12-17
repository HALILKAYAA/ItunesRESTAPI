//
//  MediaUIModel.swift
//  ItunesApi
//
//  Created by Halil Kaya on 21.11.2021.
//  Copyright © 2021 kaya. All rights reserved.
//

import UIKit

/// UI Model of the Media List
public struct MediaUIModel {
    let wrapperType: WrapperType
    let kind: KindType?
    let collectionID: Int?
    let trackID: Int?
    let artistName: String?
    let collectionName: String?
    let trackName: String?
    let artworkUrl: String?
    let releaseDate: String
    let country: String
    var isRead = false
    
    public init(searchResponseModel : SearchResponseModel) {
        self.wrapperType = searchResponseModel.wrapperType
        self.kind = searchResponseModel.kind
        self.trackID = searchResponseModel.trackID
        self.artistName = searchResponseModel.artistName
        self.collectionName = searchResponseModel.collectionName
        self.trackName = searchResponseModel.trackName
        self.artworkUrl = searchResponseModel.artworkUrl100
        self.country = searchResponseModel.country
        self.collectionID = searchResponseModel.collectionID
        
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "MMM dd, yyyy"
        self.releaseDate = formatter.string(from: searchResponseModel.releaseDate)
    }
    /// Gets id of the media
    /// - Returns: id of the media
    func getId() -> Int? {
        var entityId = self.trackID
        if entityId == nil {
            entityId = collectionID
        }
        return entityId
    }
    /// Checks whether media is read or not
    mutating func checkIsRead() {
        guard !isRead else {
            return
        }
        guard let eId = getId() else {
            return
        }
        self.isRead =  DataService.sharedInstance.getIsMediaRead(mediaId: eId)
    }
    
    /// Marks the specified media as read
    mutating func markRead() {
        guard !isRead else{
            return
        }
        
        guard let eId = getId() else {
            return
        }
        DataService.sharedInstance.markMediaRead(mediaId: eId)
        self.isRead = true
    }
    
    /// Marks the specified media as deleted
    func markDeleted() {
        guard let eId = getId() else {
            return
        }
        DataService.sharedInstance.markMediaDeleted(mediaId: eId)
    }
    
    
    /// Checks whether is media deleted or not.
    /// - Returns: Is media deleted or not
    func getIsDeleted() -> Bool {
        guard let eId = getId() else {
            return false
        }
        
        return DataService.sharedInstance.getIsEntityDeleted(mediaId: eId)
        
    }
}
