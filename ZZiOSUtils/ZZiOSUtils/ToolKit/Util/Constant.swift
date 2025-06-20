//
//  Constant.swift
//  PictureLive
//
//  Created by Qi on 2021/1/27.
//
import UIKit

/// 判断是否为刘海机型
public let IS_IPHONE_X: Bool = {
    return SAFE_AREA_BOTTOM == 0 ? false : true
}()

/// 判断是不是小机型
public let isSmallDevice: Bool = {
    return UIDevice.current.userInterfaceIdiom == .phone && UIScreen.main.bounds.size.height <= 667.0
}()

public let isBigScreen: Bool = UIScreen.main.bounds.height >= 812 ? true : false


/// 顶部安全区域的高度
public let SAFE_AREA_TOP: CGFloat = {
    if #available(iOS 11.0, *) {
        if let window = UIApplication.shared.delegate?.window ?? nil {
            return window.safeAreaInsets.top
        } else {
            return 0.0
        }
    } else {
        return 0.0
    }
}()

/// 底部安全距离高度
public let SAFE_AREA_BOTTOM: CGFloat = {
    if #available(iOS 11.0, *) {
        if let window = UIApplication.shared.delegate?.window ?? nil {
            return window.safeAreaInsets.bottom
        } else {
            return 0.0
        }
    } else {
        return 0.0
    }
}()

/// 状态栏高度
public let StatusBarHeight: CGFloat = {
    let scene = UIApplication.shared.connectedScenes.first
    guard let windowScene = scene as? UIWindowScene else {return 0}
    guard let manager = windowScene.statusBarManager else {return 0}
    return manager.statusBarFrame.height
}()


public let KNavHeight: CGFloat = DeviceInfo.isIpad() ? 50.0 : 44.0

/// 导航栏高度 + 安全距离
public let KStatusAndNavBarHeight: CGFloat = StatusBarHeight + KNavHeight

/// 屏幕宽度
public let KMainWidth: CGFloat = UIScreen.main.bounds.size.width

/// 屏幕高度
public let KMainHeight: CGFloat = UIScreen.main.bounds.size.height



