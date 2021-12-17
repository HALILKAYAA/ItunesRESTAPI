//
//  UIStoryboardExtension.swift
//  ItunesApi
//
//  Created by Halil Kaya on 21.11.2021.
//  Copyright © 2021 kaya. All rights reserved.
//

import Foundation
import UIKit

public extension UIStoryboard {

    static var main: UIStoryboard {
        let bundle = Bundle.main
        guard let storyboardName = bundle.object(forInfoDictionaryKey: "UIMainStoryboardFile") as? String else {
            fatalError("No main storyboard set in your app.")
        }
        return  UIStoryboard(name: storyboardName, bundle: bundle)
    }
}

