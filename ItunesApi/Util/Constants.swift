//
//  Constants.swift
//  ItunesApi
//
//  Created by Halil Kaya on 21.11.2021.
//  Copyright © 2021 kaya. All rights reserved.
//

import Foundation
import UIKit

class Constants{
    
    struct Network {
    }
    struct Service {
        //
        //Base URL can be inside of the Info.plist file in case of CI and Multi Target Purposes.
        //
        static let baseUrl = "https://itunes.apple.com"
        static let search = "/search"
        static let lookup = "/lookup"
    }
    struct Limits {
        static let defaultLimit = 100
    }
    struct Data {
        static let dataModelName = "iTunesDataModel"
        struct MediaSetting {
            static let name = "MediaSetting"
            static let key_id = "mediaId"
            static let key_isRead = "isViewedByUser"
            static let key_isDeleted = "isDeletedByUser"
        }
    }
    public struct Colors {
        public static let LightRed       = UIColor(red: 0.00, green: 0.80, blue: 0.75, alpha: 1.00)
        public static let DarkSlateBlue70  = UIColor(red: 0.70, green: 0.16, blue: 0.10, alpha: 1.00)
        static let activityIndicatorBackground = UIColor.black.withAlphaComponent(0.3)
    }
    public struct Images {
        static let CellItemPlaceholder = UIImage(named: "MusicPlaceholder")
        static let navIconFilter = UIImage(named: "nav_filter_icon")
        static let navIconTrash = UIImage(named: "trash_icon")
    }
    public struct Fonts {
        static let toolbar = UIFont.systemFont(ofSize: 14)
    }
    struct MediaList {
        struct Dimensions {
            static let cellPerRowInLandscape : CGFloat = 2
            static let cellHeight : CGFloat = 60
            static let cellWidthGap : CGFloat = 20
            static let cellInterspacing : CGFloat = 10
        }
        struct Time {
            static let searchThrottle:  TimeInterval = 0.9
            static let deleteWait : TimeInterval = 1.7
        }
    }
    struct ToolBar {
        struct Dimensions {
            static let height : CGFloat = 44
        }
    }
}
