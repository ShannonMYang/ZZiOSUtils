//
//  SystemControl.swift
//  FingerprintJS
//
//  Created by Petr Palata on 08.03.2022.
//

import Foundation
import UIKit

@objcMembers
class SystemControll {
    var subsystem = HardwareSubsystem()
    var kernelSubsystem = KernelSubsystem()
}

extension SystemControll {
    var hardwareModel: String? {
        return subsystem.model
//        return try? getSystemValue(.hardwareModel)
    }

    var hardwareMachine: String? {
        return subsystem.machine
//        return try? getSystemValue(.hardwareMachine)
    }

    var osRelease: String? {
        return kernelSubsystem.osRelease
//        return try? getSystemValue(.osRelease)
    }

    var osType: String? {
        return kernelSubsystem.osType
//        return try? getSystemValue(.osType)
    }

    var osVersion: String? {
        return kernelSubsystem.osVersion
//        return try? getSystemValue(.osVersion)
    }

    var kernelVersion: String? {
        return kernelSubsystem.kernelVersion
//        return try? getSystemValue(.kernelVersion)
    }

    var osBuild: Int32? {
        return kernelSubsystem.osBuild
//        return try? getSystemValue(.osBuild)
    }

    var memorySize: Int64? {
        return subsystem.memorySize
//        return try? getSystemValue(.memSize)
    }

    var physicalMemory: Int32? {
        return subsystem.physicalMemory
//        return try? getSystemValue(.physicalMemory)
    }

    var cpuCount: Int32? {
        return subsystem.cpuCount
//        return try? getSystemValue(.cpuCount)
    }

    var cpuFrequency: Int32? {
        return subsystem.cpuFrequency
//        return try? getSystemValue(.cpuFrequency)
    }

    var iosVersion: String? {
        return UIDevice.current.systemVersion
    }

    var osName: String? {
        return UIDevice.current.systemName
    }

//    var safeMode: String? {
//        return try? getSystemValue(.safeMode)
//    }
}
