//
//  AppInfo.swift
//  ToolKit
//
//  Created by 11111 on 2024/12/4.
//

import UIKit

/*
 app 相关配置信息
 */
public class AppInfo: NSObject {
    /// 获取app名称
    public static func appName() -> String {
        let infoDictionary = Bundle.main.infoDictionary!
        let appDisplayName = infoDictionary["CFBundleDisplayName"] //程序名称
        return appDisplayName as? String ?? ""
    }
    
    /// 获取app版本号
    public static func appVerion() -> String {
        let infoDictionary = Bundle.main.infoDictionary!
        let version = infoDictionary["CFBundleShortVersionString"]
        return version as? String ?? ""
    }
    
    /// 应用Build版本名
    public static func buildVersion() -> String {
        let infoDictionary = Bundle.main.infoDictionary!
        let buildVersion = infoDictionary["CFBundleVersion"]
        return buildVersion as? String ?? ""
    }
    
    // MARK: 应用icon名
    public static let icon: String = {
        if let icons = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
           let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
           let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
           let lastIcon = iconFiles.last {
            return lastIcon
        }
        return ""
    }()
    
    /// app商店链接
    @discardableResult
    public static func appSroreUrlWithID(_ appleID: String) -> String {
        return "itms-apps://itunes.apple.com/app/id\(appleID)?mt=8"
    }
    
    /// app详情链接
    @discardableResult
    public static func appDetailUrlWithID(_ appleID: String) -> String {
        let detailUrl = "http://itunes.apple.com/cn/lookup?id=\(appleID)"
        return detailUrl
    }
    
    /// 评分App链接
    @discardableResult
    public static func rateAppUrlWithID(_ appleID: String) -> String {
        return "itms-apps://itunes.apple.com/app/id\(appleID)?action=write-review"
    }
}
