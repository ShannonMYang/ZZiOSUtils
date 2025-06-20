//
//  HardwareInfoHarvesting.swift
//  FunReportSDK
//
//  Created by 11634 on 2024/10/16.
//  Copyright © 2024 Baidu. All rights reserved.
//

import AVFoundation
import CoreTelephony
import Foundation
import UIKit

protocol HardwareInfoHarvesting {
    /// Returns high-level device type (e.g. iPhone)
    var deviceType: String { get }

    /// Returns physical resolution (in pixels) for the current device
    var displayResolution: CGSize { get }

    /// Returns device model identifier (e.g. iPhone 13,3)
    var deviceModel: String { get }
}

public class HardwareInfoHarvester: NSObject {
    private let device = UIDevice()
    private let screen = UIScreen()
    private let systemControl = SystemControll()

//    init(_ device: UIDevice, screen: UIScreen, systemControl: SystemControll) {
//        self.device = device
//        self.screen = screen
//        self.systemControl = systemControl
//    }

//     convenience init() {
//        self.init()
//    }
}

extension HardwareInfoHarvester: HardwareInfoHarvesting {
    public var deviceType: String {
        return device.model
    }

    public var deviceIdentifier: String {
        return Deviice.current.identifier
    }

    public var deviceCompleteName: String {
        return Deviice.current.completeName
    }

    public var deviceYear: String {
        return "\(Deviice.current.year)"
    }

    public var displayResolution: CGSize {
        let nativeBounds = screen.nativeBounds
        return CGSize(width: nativeBounds.width, height: nativeBounds.height)
    }

    public var deviceModel: String {
        return systemControl.hardwareModel ?? "Undefined"
    }

    public var memorySize: String {
        guard let memorySize = systemControl.memorySize else {
            return "Undefined"
        }

        return "\(memorySize)"
    }

    public var physicalMemory: String {
        guard let physicalMemory = systemControl.physicalMemory else {
            return "Undefined"
        }
        return "\(physicalMemory)"
    }

    public var cpuCount: String {
        return "\(ProcessInfo.processInfo.processorCount)"
    }

    public var cpuFrequency: String {
        guard let cpuFrequency = systemControl.cpuFrequency else {
            return "Undefined"
        }
        return "\(cpuFrequency)"
    }

    public var hardwareMachine: String {
        return systemControl.hardwareMachine ?? "Undefined"
    }

    public var totalDiskSpaceInMB: String {
        return UIDevice.current.totalDiskSpaceInMB
    }

    public var totalDiskSpaceInGB: String {
        let info = CTTelephonyNetworkInfo()
        if let dataServiceIdentifier = info.dataServiceIdentifier {
            print(dataServiceIdentifier)
        }
        return UIDevice.current.totalDiskSpaceInGB
    }

    public var isCharging: String {
        UIDevice.current.isBatteryMonitoringEnabled = true
        if UIDevice.current.batteryState == .charging {
            return "是"
        }
        UIDevice.current.isBatteryMonitoringEnabled = false
        return "否"
    }
}

extension UIDevice {
    func MBFormatter(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = ByteCountFormatter.Units.useMB
        formatter.countStyle = ByteCountFormatter.CountStyle.decimal
        formatter.includesUnit = false
        return formatter.string(fromByteCount: bytes) as String
    }

    // MARK: Get String Value

    var totalDiskSpaceInGB: String {
        return ByteCountFormatter.string(fromByteCount: totalDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.decimal)
    }

    var freeDiskSpaceInGB: String {
        return ByteCountFormatter.string(fromByteCount: freeDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.decimal)
    }

    var usedDiskSpaceInGB: String {
        return ByteCountFormatter.string(fromByteCount: usedDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.decimal)
    }

    var totalDiskSpaceInMB: String {
        return MBFormatter(totalDiskSpaceInBytes)
    }

    var freeDiskSpaceInMB: String {
        return MBFormatter(freeDiskSpaceInBytes)
    }

    var usedDiskSpaceInMB: String {
        return MBFormatter(usedDiskSpaceInBytes)
    }

    // MARK: Get raw value

    var totalDiskSpaceInBytes: Int64 {
        guard let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String),
              let space = (systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.int64Value else { return 0 }
        return space
    }

    /*
     Total available capacity in bytes for "Important" resources, including space expected to be cleared by purging non-essential and cached resources. "Important" means something that the user or application clearly expects to be present on the local system, but is ultimately replaceable. This would include items that the user has explicitly requested via the UI, and resources that an application requires in order to provide functionality.
     Examples: A video that the user has explicitly requested to watch but has not yet finished watching or an audio file that the user has requested to download.
     This value should not be used in determining if there is room for an irreplaceable resource. In the case of irreplaceable resources, always attempt to save the resource regardless of available capacity and handle failure as gracefully as possible.
     */
    var freeDiskSpaceInBytes: Int64 {
        if #available(iOS 11.0, *) {
            if let space = try? URL(fileURLWithPath: NSHomeDirectory() as String).resourceValues(forKeys: [URLResourceKey.volumeAvailableCapacityForImportantUsageKey]).volumeAvailableCapacityForImportantUsage {
                return space
            } else {
                return 0
            }
        } else {
            if let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String),
               let freeSpace = (systemAttributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.int64Value
            {
                return freeSpace
            } else {
                return 0
            }
        }
    }

    var usedDiskSpaceInBytes: Int64 {
        return totalDiskSpaceInBytes - freeDiskSpaceInBytes
    }
}
