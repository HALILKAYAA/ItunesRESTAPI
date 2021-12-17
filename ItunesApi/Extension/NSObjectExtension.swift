//
//  NSObjectExtension.swift
//  ItunesApi
//
//  Created by Halil Kaya on 21.11.2021.
//  Copyright © 2021 kaya. All rights reserved.
//

import Foundation

public extension NSObject {

    var className: String {
        return type(of: self).className
    }

    static var className: String {
        return stringFromClass(aClass: self)
    }
}

public func stringFromClass(aClass: AnyClass) -> String {
    return NSStringFromClass(aClass).components(separatedBy: ".").last!
}
