//
//  UIColor+Ex.swift
//  PictureLive
//
//  Created by Qi on 2021/1/26.
//

import Foundation
import UIKit

public extension UIColor {
    /// 转换  8 位 16 进制颜色值到色值 0xAARRGGBB
    convenience init(argb: uint) {
        let blue = CGFloat(argb & 0xFF)
        let green = CGFloat((argb & 0xFF00) >> 8)
        let red = CGFloat((argb & 0xFF0000) >> 16)
        let alpha = CGFloat((argb & 0xFF000000) >> 24)

        self.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha / 255.0)
    }

    /// 转换  6 位 16 进制颜色值到色值 0xRRGGBB
    convenience init(rgb: uint) {
        let blue = CGFloat(rgb & 0xFF)
        let green = CGFloat((rgb & 0xFF00) >> 8)
        let red = CGFloat((rgb & 0xFF0000) >> 16)

        self.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1)
    }

    // 传入“#979797”
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        //处理数值
        var cString = hex.uppercased().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        let length = (cString as NSString).length
        //错误处理
        if (length < 6 || length > 7 || (!cString.hasPrefix("#") && length == 7)){
            //返回whiteColor
            self.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            return
        }
        
        if cString.hasPrefix("#"){
            cString = (cString as NSString).substring(from: 1)
        }
        
        //字符chuan截取
        var range = NSRange()
        range.location = 0
        range.length = 2
        
        let rString = (cString as NSString).substring(with: range)
        
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
        
        //存储转换后的数值
        var r:UInt64 = 0,g:UInt64 = 0,b:UInt64 = 0
        //进行转换
        Scanner(string: rString).scanHexInt64(&r)
        Scanner(string: gString).scanHexInt64(&g)
        Scanner(string: bString).scanHexInt64(&b)
        //根据颜色值创建UIColor
         self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
    }
}


/// 颜色拓展
extension UIColor {
    
    // Primary c_FF1F2E3D
    public static func c_FF1F2E3D() -> UIColor {
        return UIColor.init(argb: 0xFF1F2E3D)
    }
    
    /// Transparent c_00000000
    public static func c_00000000() -> UIColor {
        return UIColor.init(argb: 0x00000000)
    }
    
    /// white c_FFFFFFFF
    public static func c_FFFFFFFF() -> UIColor {
        return UIColor.init(argb: 0xFFFFFFFF)
    }
    
    /// Black c_FF000000
    public static func c_FF000000() -> UIColor {
        return UIColor.init(argb: 0xFF000000)
    }
    
    /// securityWaterMask c_33000000
    public static func c_33000000() -> UIColor {
        return UIColor.init(argb: 0x33000000)
    }
    
    /// gradientStart  c_FFFB705E
    public static func c_FFFB705E() -> UIColor {
        return UIColor.init(argb: 0xFFFB705E)
    }
    
    /// gradientEnd / nextBtn1
    /// c_FFEC1254
    public static func c_FFEC1254() -> UIColor {
        return UIColor.init(argb: 0xFFEC1254)
    }
    
    /// PremiumText
    /// c_FFAAAAAA
    public static func c_FFAAAAAA() -> UIColor {
        return UIColor.init(argb: 0xFFAAAAAA)
    }
    
    /// SelectedBorder
    /// c_FFF23C58
    public static func c_FFF23C58() -> UIColor {
        return UIColor.init(argb: 0xFFF23C58)
    }
    
    /// CustomBluePremium / 自定义蓝色
    /// c_FF0082FF
    public static func c_FF0082FF() -> UIColor {
        return UIColor.init(argb: 0xFF0082FF)
    }
    
    /// white90
    /// c_E6FFFFFF
    public static func c_E6FFFFFF() -> UIColor {
        return UIColor.init(argb: 0xE6FFFFFF)
    }
    
    /// nextBtn2
    /// c_FFF66F5D
    public static func c_FFF66F5D() -> UIColor {
        return UIColor.init(argb: 0xFFF66F5D)
    }
    
    
}
