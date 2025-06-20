//
//  NSObject+Ex.swift
//  PictureLive
//
//  Created by Ja on 2023/9/4.
//

import Foundation

public extension NSObject {
    class func reuseIdentity() -> String {
        return NSStringFromClass(self.classForCoder())
    }
}
