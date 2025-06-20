//
//  DeviceInfo.swift
//  JYToolKit
//
//  Created by 赵振宇 on 2024/3/7.
//

import Foundation
import CoreTelephony
import AppTrackingTransparency
import AdSupport
import UIKit


public struct DeviceInfo {
    /// 获取iPhone名称
    public static func phoneName() -> String {
        return UIDevice.current.name
    }
    
    /// 获取电池电量
    public static func batteryLevel() -> Float {
        return UIDevice.current.batteryLevel
    }
    
    /// 当前系统名称
    public static func systemName() -> String {
        return UIDevice.current.systemName
    }
    
    /// 当前系统版本号
    public static func systemVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
    /// 通用唯一识别码UUID
    public static func uuid() -> String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }
    
   
    
    
    /// 如果想要判断设备是ipad，要用如下方法
    public static func isIpad() -> Bool {
        let deviceType = UIDevice.current.model
        
        switch deviceType {
            //        case "iPhone", "iPod touch":
            //            return false
        case "iPad":
            return true
        default:
            return false
        }
    }
    
    /// 获取当前设备IP
    public static func deviceIPAdress() -> String? {
        var addresses = [String]()
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while (ptr != nil) {
                let flags = Int32(ptr!.pointee.ifa_flags)
                var addr = ptr!.pointee.ifa_addr.pointee
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String(validatingUTF8:hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        return addresses.first
    }
    
    /// 获取总内存大小
    public static func totalMemorySize() -> UInt64 {
        return ProcessInfo.processInfo.physicalMemory
    }
    
    /// 获取电池当前的状态，共有4种状态
    public static func batteryState() -> String {
        let device = UIDevice.current
        switch device.batteryState {
            //        case .unknown:
            //            return "UnKnow"
        case .unplugged:
            return "Unplugged"
        case .charging:
            return "Charging"
        case .full:
            return "Full"
        default:
            return ""
        }
        
    }
    
    /// 语言环境
    public static let locale: String? = {
        return Locale.preferredLanguages.first
    }()
    
    ///  语言简码
    public static let language: String = {
        var appleLang = locale ?? ""
        if (appleLang.count > 2) {
            appleLang = String(appleLang.prefix(2))
        }
        return appleLang
    }()
    
    /// 语言代码 BCP 47 format
    public static let languageCode: String = {
        
        var com = locale?.components(separatedBy: "-") ?? []
        if (com.count >= 2){
            com.removeLast()
        }
        return com.joined(separator: "-")
        
    }()
    
    ///运营商
    public static func op() -> String? {
        var tempName: String?
        let info = CTTelephonyNetworkInfo()
        if let carrierProviders = info.serviceSubscriberCellularProviders {
            for item in carrierProviders.values {
                if item.mobileNetworkCode != nil {
                    tempName = item.carrierName
                }
            }
        }
        return tempName
    }
    
    ///bundleID
    public static let pkg: String? = {
        return Bundle.main.bundleIdentifier
    }()
    
    ///本地国家
    public static let country: String? = {
        return Locale.current.regionCode
    }()
    
    /// 厂商
    public static let brand: String = {
        return "apple"
    }()
    
    /// 是否是中文
    public static func isChineseLanguage() -> Bool {
        let local = Locale(identifier: locale ?? "")
        let languageCode = local.languageCode
        return languageCode == "zh"
    }
    
    ///  是否是中国地区
    public static func isChineseRegion() -> Bool {
        return self.country == "CN"
    }
    
    /// 是否是欧盟国
    public static func isGDPR() -> Bool {
        let GDPRCountryArr = ["AT", "BE", "BG", "HR", "CY", "CZ", "DK", "EE", "FI", "FR", "DE", "GR", "HU", "IE", "IT", "LV", "LT", "LU", "MT", "NL", "PL", "PT", "RO", "SK", "SI", "ES", "SE", "GB", "GF", "PF", "TF", "YT", "RE", "CH", "IS", "LI", "NO"]
        let currentCountry = country ?? ""
        
        return GDPRCountryArr.contains(currentCountry)
    }
    
    /// 获取上层VC
    public static func currentVC() -> UIViewController {
        var vc: UIViewController?
        var window: UIWindow! = UIApplication.shared.windows.first
        if window?.windowLevel != .normal {
            let windows = UIApplication.shared.windows
            for tmpWin in windows {
                if tmpWin.windowLevel == .normal {
                    window = tmpWin
                    break
                }
                
            }
        }
        
        vc = window!.rootViewController
        while (vc?.presentedViewController != nil) {
            vc = vc?.presentedViewController
        }
        
        if let tab = vc as? UITabBarController {
            vc = tab.selectedViewController
        }
        
        if let nav = vc as? UINavigationController {
            vc = nav.visibleViewController
        }
        
        return vc ?? UIViewController()
        
    }
    
    /// 获取IDFA
    public static func idfa() -> String {
        var idfa = ""
        ATTrackingManager.requestTrackingAuthorization { status in
            if status == .authorized {
                idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            }
        }
        
        return idfa
    }
    
    public static func idfaWithCallBack(_ callback: @escaping (_ idfa: String) -> Void) {
        let status = ATTrackingManager.trackingAuthorizationStatus
        switch status {
        case .denied:
            callback("")
            break
        case .authorized:
            callback(ASIdentifierManager.shared().advertisingIdentifier.uuidString)
            break
            
        case .notDetermined:
            ATTrackingManager.requestTrackingAuthorization { authorizationStatus in
                if authorizationStatus == .authorized {
                    callback(ASIdentifierManager.shared().advertisingIdentifier.uuidString)
                } else {
                    callback("")
                }
            }
            break
            
        default:
            callback("")
        }
        
    }
    
    /// 获取当前的keyWindow
    public static var keyWindow: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.filter { $0.isKeyWindow }.first
        } else {
            return UIApplication.shared.keyWindow
        }
    }
    
    /// 获取屏幕的方向
    public static var screenOrientation: UIInterfaceOrientation {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.windowScene?.interfaceOrientation ?? .landscapeLeft
        } else {
            return UIApplication.shared.statusBarOrientation
        }
    }
    
   
    
    
    /// 获取设备版本号
    public static func deviceName() -> String {
        // 需要#import "sys/utsname.h"
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine as Any)
        let deviceString = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(_ identifier: String) -> String {
           switch identifier {
           case "iPhone3,1", "iPhone3,2", "iPhone3,3": return "iPhone 4"
           case "iPhone4,1": return "iPhone 4s"
           case "iPhone5,1": return "iPhone 5"
           case "iPhone5,2": return "iPhone 5 (GSM+CDMA)"
           case "iPhone5,3": return "iPhone 5c (GSM)"
           case "iPhone5,4": return "iPhone 5c (GSM+CDMA)"
           case "iPhone6,1": return "iPhone 5s (GSM)"
           case "iPhone6,2": return "iPhone 5s (GSM+CDMA)"
           case "iPhone7,2": return "iPhone 6"
           case "iPhone7,1": return "iPhone 6 Plus"
           case "iPhone8,1":return "iPhone 6s"
           case "iPhone8,2": return "iPhone 6s Plus"
           case "iPhone8,4": return "iPhone SE"
           case "iPhone9,1", "iPhone9,3": return "iPhone 7"
           case "iPhone9,2", "iPhone9,4": return "iPhone 7 Plus"
           case "iPhone10,1", "iPhone10,4": return "iPhone 8"
           case "iPhone10,2", "iPhone10,5": return "iPhone 8 Plus"
           case "iPhone10,3", "iPhone10,6": return "iPhone X"
           case "iPhone11,2": return "iPhone XS"
           case "iPhone11,4", "iPhone11,6": return "iPhone XS Max"
           case "iPhone11,8": return "iPhone XR"
           case "iPhone12,1": return "iPhone 11"
           case "iPhone12,3": return "iPhone 11 Pro"
           case "iPhone12,5": return "iPhone 11 Pro Max"
           case "iPhone12,8": return "iPhone SE (2nd generation)"
           case "iPhone13,1": return "iPhone 12 mini"
           case "iPhone13,2": return "iPhone 12"
           case "iPhone13,3": return "iPhone 12 Pro"
           case "iPhone13,4": return "iPhone 12 Pro Max"
           case "iPhone14,4": return "iPhone 13 mini"
           case "iPhone14,5": return "iPhone 13"
           case "iPhone14,2": return "iPhone 13 Pro"
           case "iPhone14,3": return "iPhone 13 Pro Max"
           case "iPhone14,6": return "iPhone SE (3rd generation)"
           case "iPhone14,7": return "iPhone 14"
           case "iPhone14,8": return "iPhone 14 Plus"
           case "iPhone15,2": return "iPhone 14 Pro"
           case "iPhone15,3": return "iPhone 14 Pro Max"
           case "iPhone15,4": return "iPhone 15"
           case "iPhone15,5": return "iPhone 15 Plus"
           case "iPhone16,1": return "iPhone 15 Pro"
           case "iPhone16,2": return "iPhone 15 Pro Max"
               
               //------------------------------iPod Touch------------------------
           case "iPod1,1": return "iPod Touch 1G"
           case "iPod2,1": return "iPod Touch 2G"
           case "iPod3,1": return "iPod Touch 3G"
           case "iPod4,1": return "iPod Touch 4G"
           case "iPod5,1": return "iPod Touch (5 Gen)"
           case "iPod7,1": return "iPod Touch6"
           case "iPod9,1": return "iPod Touch (7 Gen)"
               //------------------------------iPad--------------------------
           case "iPad1,1": return "iPad"
           case "iPad1,2": return "iPad 3G"
           case "iPad2,1": return "iPad 2 (WiFi)"
           case "iPad2,2", "iPad2,4": return "iPad 2"
           case "iPad2,3": return "iPad 2 (CDMA)"
           case "iPad2,5": return "iPad Mini (WiFi)"
           case "iPad2,6": return "iPad Mini"
           case "iPad2,7": return "iPad Mini (GSM+CDMA)"
               
           case "iPad3,1": return "iPad 3 (WiFi)"
           case "iPad3,2": return "iPad 3 (GSM+CDMA)"
           case "iPad3,3": return "iPad 3"
           case "iPad3,4": return "iPad 4 (WiFi)"
           case "iPad3,5": return "iPad 4"
           case "iPad3,6": return "iPad 4 (GSM+CDMA)"
               
           case "iPad4,1": return "iPad Air (WiFi)"
           case "iPad4,2": return "iPad Air (Cellular)"
           case "iPad4,4": return "iPad Mini 2 (WiFi)"
           case "iPad4,5": return "iPad Mini 2 (Cellular)"
           case "iPad4,6": return "iPad Mini 2"
           case "iPad4,7", "iPad4,8", "iPad4,9": return "iPad Mini 3"
           case "iPad5,1": return "iPad Mini 4 (WiFi)"
           case "iPad5,2": return "iPad Mini 4 (LTE)"
           case "iPad5,3", "iPad5,4": return "iPad Air 2"
           case "iPad6,3", "iPad6,4": return "iPad Pro 9.7"
           case "iPad6,7", "iPad6,8": return "iPad Pro 12.9"
           case "iPad6,11", "iPad6,12": return "iPad 5"
           case "iPad7,1", "iPad7,2": return "iPad Pro 12.9-inch 2"
           case "iPad7,3", "iPad7,4": return "iPad Pro 10.5-inch"
           case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4": return "iPad Pro (11-inch)"
           case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8": return "iPad Pro (12.9-inch) (3rd generation)"
           case "iPad8,9", "iPad8,10": return "iPad Pro (11-inch) (2nd generation)"
           case "iPad8,11", "iPad8,12": return "iPad Pro (12.9-inch) (4th generation)"
           case "iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7": return "iPad Pro (11-inch) (3rd generation)"
           case "iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11": return "iPad Pro (12.9-inch) (5th generation)"
           case "iPad11,1", "iPad11,2": return "iPad mini (5th generation)"
               
           case "iPad14,1", "iPad14,2": return "iPad mini (6th generation)"
               //------------------------------Simulator--------------------------
           case "i386", "x86_64": return "Simulator"
               
           default:    return identifier
           }
           
       }
        
        return mapToDevice(deviceString)
        
    }
    
    
}

