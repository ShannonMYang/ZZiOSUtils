//
//  ScreenHarvester.swift
//  FunReportSDK
//
//  Created by 11634 on 2024/10/11.
//  Copyright © 2024 Baidu. All rights reserved.
//

import UIKit

public class ScreenHarvester: NSObject {
    private let device: UIDevice
    private let screen: UIScreen
    
    init(device: UIDevice, screen: UIScreen) {
        self.device = device
        self.screen = screen
    }
    
    override public convenience init() {
        self.init(device: UIDevice.current, screen: UIScreen.main)
    }
    
    public var displayResolution: CGSize {
        let nativeBounds = screen.nativeBounds
        return CGSize(width: nativeBounds.width, height: nativeBounds.height)
    }
    
    public var nativeScale: String {
        let nativeBounds = screen.nativeScale
        return "\(nativeBounds)"
    }
    
    public var maximumFramesPerSecond: String {
        let value = screen.maximumFramesPerSecond
        return "\(value)Hz"
    }
    
    public var currentEDRHeadroom: String {
        if #available(iOS 16.0, *) {
            let value = screen.currentEDRHeadroom
            return "\(value)"
        } else {
            return "N/A"
            // Fallback on earlier versions
        }
    }
    
    public var potentialEDRHeadroom: String {
        if #available(iOS 16.0, *) {
            let value = screen.potentialEDRHeadroom
            return "\(value)"
        } else {
            return "N/A"
            // Fallback on earlier versions
        }
    }
}
