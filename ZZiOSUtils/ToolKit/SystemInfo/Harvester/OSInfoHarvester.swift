//
//  cpuDevice.swift
//  FunReportSDK
//
//  Created by 11634 on 2024/10/11.
//  Copyright © 2024 Baidu. All rights reserved.
//

import UIKit

protocol OSInfoHarvesting {
    var osBuild: String { get }

    var osVersion: String { get }

    var osType: String { get }

    var kernelVersion: String { get }

    /// Returns device model identifier (e.g. iPhone 13,3)
    var deviceModel: String { get }

    var memorySize: String { get }
}

public class OSInfoHarvester: NSObject {
    private let systemControl = SystemControll()

//    public init() {}
}

extension OSInfoHarvester: OSInfoHarvesting {
    public var osType: String {
        return systemControl.osType ?? "Undefined"
    }

    public var osVersion: String {
        return systemControl.osVersion ?? "Undefined"
    }

    public var osRelease: String {
        return systemControl.osRelease ?? "Undefined"
    }

    public var kernelVersion: String {
        return systemControl.kernelVersion ?? "Undefined"
    }

    public var osBuild: String {
        guard let osBuild = systemControl.osBuild else {
            return "Undefined"
        }
        return "\(osBuild)"
    }

    public var iosVersion: String {
        return systemControl.iosVersion ?? "Undefined"
    }

    public var isFakeSystem: String {
        return "Demo未实现，可以通过版本专有接口来判断是否是真的iOS系统，可以从iOS18开始往前适应几个版本就可以"
    }

    var osName: String {
        return systemControl.osName ?? "Undefined"
    }

    public var deviceModel: String {
        return systemControl.hardwareModel ?? "Undefined"
    }

    public  var memorySize: String {
        guard let memorySize = systemControl.memorySize else {
            return "Undefined"
        }

        return "\(memorySize)"
    }

    public var bootTime: String? {
        var tv = timeval()
        var tvSize = MemoryLayout<timeval>.size
        let err = sysctlbyname("kern.boottime", &tv, &tvSize, nil, 0)
        guard err == 0, tvSize == MemoryLayout<timeval>.size else {
            return nil
        }
        let date = Date(timeIntervalSince1970: Double(tv.tv_sec) + Double(tv.tv_usec) / 1_000_000.0)
        return "\(date)"
    }

//    var safeMode: String? {
//        return systemControl.safeMode
//    }
}
