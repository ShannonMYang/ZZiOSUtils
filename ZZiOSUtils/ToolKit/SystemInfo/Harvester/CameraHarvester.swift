//
//  CameraHarvester.swift
//  FunReportSDK
//
//  Created by 11634 on 2024/10/11.
//  Copyright © 2024 Baidu. All rights reserved.
//

import AVFoundation
import UIKit

enum cameraInfoType {
    case fps
    case iso
    case picFrame
}

public class CameraHarvester: NSObject {
    public var fps: String = getCameraInfo(type: .fps)
    public var iso: String = getCameraInfo(type: .iso)
    public var picFrame: String = getCameraInfo(type: .picFrame)

    public var cameraInfo: String {
        let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInTelephotoCamera, .builtInUltraWideCamera, .builtInDualCamera, .builtInDualWideCamera, .builtInTripleCamera, .builtInTrueDepthCamera], mediaType: .video, position: .back)

        let sessionFont = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInTelephotoCamera, .builtInUltraWideCamera, .builtInDualCamera, .builtInDualWideCamera, .builtInTripleCamera, .builtInTrueDepthCamera], mediaType: .video, position: .front)

        var cameraInfo = ""
        var devices = session.devices
        devices.append(contentsOf: sessionFont.devices)

        for device in devices {
            var maxDimensions = CMVideoDimensions(width: 0, height: 0)
            var maxFrameRate: Float64 = 0
            var minISO: Float = 999999
            var maxISO: Float = 0
            for format in device.formats {
                let dimensions = format.highResolutionStillImageDimensions
                if dimensions.width * dimensions.height > maxDimensions.width * maxDimensions.height {
                    maxDimensions = dimensions
                }
                if format.minISO < minISO {
                    minISO = format.minISO
                }
                if format.maxISO > maxISO {
                    maxISO = format.maxISO
                }
                for range in format.videoSupportedFrameRateRanges {
                    if range.maxFrameRate > maxFrameRate {
                        maxFrameRate = range.maxFrameRate
                    }
                }
            }
            let deviceInfo = "镜头位置 = \(device.localizedName):\n图片尺寸(\(maxDimensions.width) x \(maxDimensions.height))\n最大\(maxFrameRate)fps\nISO范围(\(minISO) ~ \(maxISO))\n\n"
            cameraInfo = "\(cameraInfo)\(deviceInfo)"
        }
        return cameraInfo
    }
}

func getCameraInfo(type: cameraInfoType) -> String {
    let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .unspecified)

    var cameraInfo = ""
    var devices = session.devices

    var fps = ""
    var iso = ""
    var picFrame = ""
    
    let modelNameString = Deviice.current.model

    for device in devices {
        var maxDimensions = CMVideoDimensions(width: 0, height: 0)
        var maxFrameRate: Float64 = 0
        var minISO: Float = 999999
        var maxISO: Float = 0
        for format in device.formats {
            let dimensions = format.highResolutionStillImageDimensions
            if dimensions.width * dimensions.height > maxDimensions.width * maxDimensions.height {
                maxDimensions = dimensions
            }
            if format.minISO < minISO {
                minISO = format.minISO
            }
            if format.maxISO > maxISO {
                maxISO = format.maxISO
            }
            for range in format.videoSupportedFrameRateRanges {
                if range.maxFrameRate > maxFrameRate {
                    maxFrameRate = range.maxFrameRate
                }
            }
        }
        // fps
        if device.position == .front {
            let frontFps = "front = \(maxFrameRate)"
            fps = "\(fps)\(frontFps)"
        } else if device.position == .back {
            let backFps = "back = \(maxFrameRate),"
            fps = "\(fps)\(backFps)"
        }
        // iso
        if device.position == .front {
            let frontIso = "front = \(minISO) ~ \(maxISO)"
            iso = "\(iso)\(frontIso)"
        } else if device.position == .back {
            let backIso = "back = \(minISO) ~ \(maxISO),"
            iso = "\(iso)\(backIso)"
        }
        // pic size
        if device.position == .front {
            let frontInfo = "front = \(maxDimensions.width) x \(maxDimensions.height)"
            picFrame = "\(picFrame)\(frontInfo)"
        } else if device.position == .back {
            let backFrame = "back = \(maxDimensions.width) x \(maxDimensions.height),"
            picFrame = "\(picFrame)\(backFrame)"
        }
        
        let deviceInfo = "镜头位置 = \(device.localizedName):\n图片尺寸(\(maxDimensions.width) x \(maxDimensions.height))\n最大\(maxFrameRate)fps\nISO范围(\(minISO) ~ \(maxISO))\n\n"
        cameraInfo = "\(cameraInfo)\(deviceInfo)"
    }
    if type == .fps {
        return fps
    } else if type == .iso {
        return iso
    } else if type == .picFrame {
        return picFrame
    } else {
        return cameraInfo
    }
}
