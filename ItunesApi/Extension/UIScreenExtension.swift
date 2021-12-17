//
//  UIScreenExtension.swift
//  ItunesApi
//
//  Created by Halil Kaya on 21.11.2021.
//  Copyright © 2021 kaya. All rights reserved.
//

import Foundation
import UIKit

public extension UIScreen {
    
    static func screenSize() -> CGSize {
        return CGSize(width: screenWidth, height: screenHeight)
    }

    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.size.width
    }

    static var screenHeight: CGFloat {
        return UIScreen.main.bounds.size.height
    }

}
