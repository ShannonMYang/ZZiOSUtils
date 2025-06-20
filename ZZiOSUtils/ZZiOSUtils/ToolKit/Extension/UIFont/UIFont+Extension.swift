//
//  UIFont+Ex.swift
//  PictureLive
//
//  Created by Ja on 2023/9/4.
//

import Foundation
import UIKit

public extension UIFont {
    
    static func systemRegularFont(fontSize:CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: fontSize, weight: .regular)
    }
    
    static func systemMediumFont(fontSize:CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: fontSize, weight: .medium)
    }
    
    static func systemLightFont(fontSize:CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: fontSize, weight: .light)
    }
    
    static func systemSemiboldFont(fontSize:CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: fontSize, weight: .semibold)
    }
    
    enum PoppinsStyle {
        case regular, bold, semibold, medium, extraBold, extraBoldItalic
    }
    
    class func poppins(style: PoppinsStyle, size: CGFloat) -> UIFont {
        switch style {
        case .regular:
            return UIFont(name: "Poppins-Regular", size: size) ?? UIFont.systemFont(ofSize: size, weight: .regular)
        case .bold:
            return UIFont(name: "Poppins-Bold", size: size) ?? UIFont.systemFont(ofSize: size, weight: .bold)
        case .semibold:
            return UIFont(name: "Poppins-Semibold", size: size) ?? UIFont.systemFont(ofSize: size, weight: .semibold)
        case .medium:
            return UIFont(name: "Poppins-Medium", size: size) ?? UIFont.systemFont(ofSize: size, weight: .medium)
        case .extraBold:
            return UIFont(name: "Poppins-ExtraBold", size: size) ?? UIFont.systemFont(ofSize: size, weight: .heavy)
        case .extraBoldItalic:
            return UIFont(name: "Poppins-ExtraBoldItalic", size: size) ?? UIFont.systemFont(ofSize: size, weight: .bold)
        }
    }
    
    enum PingFangStyle {
        case regular, semibold, medium
    }
    
    class func pingfang(style: PingFangStyle, size: CGFloat) -> UIFont {

        switch style {
        case .regular:
            return UIFont(name: "PingFangSC-Regular", size: size) ?? UIFont.systemFont(ofSize: size, weight: .regular)
        case .semibold:
            return UIFont(name: "PingFangSC-Semibold", size: size) ?? UIFont.systemFont(ofSize: size, weight: .semibold)
        case .medium:
            return UIFont(name: "PingFangSC-Medium", size: size) ?? UIFont.systemFont(ofSize: size, weight: .medium)
        }

    }
    
}
