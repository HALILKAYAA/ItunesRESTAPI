//
//  iTunesService.swift
//  ItunesApi
//
//  Created by Halil Kaya on 21.11.2021.
//  Copyright © 2021 kaya. All rights reserved.
//

import Foundation

class iTunesService {
    let downloader = APIManager()
    
    func searchMedia(withTerm term: String, limit: Int = Constants.Limits.defaultLimit, filterType : FilterType, completion: @escaping ([MediaUIModel], NetworkError?) -> Void) {
        
        var endpoint = Itunes.search(term: term, media: .all(entity: .allTrack, attribute: .titleTerm))
        
        switch filterType {
        case .song:
            endpoint = Itunes.search(term: term, media: .music(entity: .song, attribute: .songTerm), limit: limit)
        case .movie:
            endpoint = Itunes.search(term: term, media: .movie(entity: .movie, attribute: .movieTerm), limit: limit)
        case .podcast:
            endpoint = Itunes.search(term: term, media: .podcast(entity: .podcast, attribute: .titleTerm))
        case .all:
            endpoint = Itunes.search(term: term, media: .all(entity: .allTrack, attribute: .titleTerm))
        }
        
        performRequestTask(with: endpoint) { result, error in
            guard let result = result else {
                completion([], error)
                return
            }
            guard let results = result.results else {
                completion([], nil)
                return
            }
            var uiModelList : [MediaUIModel] = []
            for resultResponse in results {
                uiModelList.append(MediaUIModel(searchResponseModel: resultResponse))
            }
            completion(uiModelList, nil)
        }
    }

    private func performRequestTask(with endpoint: Routing, completion: @escaping (WrapperResponseModel<SearchResponseModel>?, NetworkError?) -> Void) {
        
        let task = downloader.requestTask(with: endpoint.request) { data, error in
            DispatchQueue.main.async {
                do {
                    let decoder = JSONDecoder()
                    guard let data = data else {
                        completion(nil, nil)
                        return
                    }
                    decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                    let parsedModel = try decoder.decode(WrapperResponseModel<SearchResponseModel>.self, from: data)
                    
                    completion(parsedModel, nil)
        
                } catch  _ {
                    completion(nil, .jsonConversionFailure)
                }
            }
        }
        task.resume()
    }
}
