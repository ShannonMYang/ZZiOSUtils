//
//  String+Ex.swift
//  PictureLive
//
//  Created by Qi on 2021/3/1.
//

import Foundation
import UIKit

import CommonCrypto

let deviceUuidKey = "com.aiphoto.deviceUdid"

public extension String {
    
    public static var deviceUdid: String {
        
        get {
            let did = UserDefaults.standard.string(forKey: deviceUuidKey)
            guard let did = did else {
                let uuid = String.UUID
                UserDefaults.standard.setValue(uuid, forKey: deviceUuidKey)
                return uuid
                
            }
            return did
        }
    }
    
    public static var UUID:String {
        get {
            
          
            let puuid = CFUUIDCreate(nil)
            if let suuid = CFUUIDCreateString(nil, puuid) {
                return "\(suuid)"
            } else {
                return "\(arc4random())"+"\(arc4random())"+"\(arc4random())"
            }
        }
    }
    
    //转成URL
    var toUrl: URL {
        if self.starts(with: "/") {
            return URL.init(fileURLWithPath: self)
        }
        return URL.init(string: self) ?? URL.init(fileURLWithPath: self)
    }
    //计算文本宽高
    func width(font: UIFont) -> CGFloat {
        guard self.isEmpty == false else {
            return 0
        }
        let str = self
        let attributes = [NSAttributedString.Key.font:font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect: CGRect = str.boundingRect(with: CGSize.init(width: 320.0, height: 999.9), options: option, attributes: attributes, context: nil)
        return rect.size.width
    }
    
    func widthWithConstrainedHeight(height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.infinity, height: height)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.width
    }
    
    //是否包含指定字符串
    func contains(subStr: String) -> Bool {
        let ss = NSString(string: self)
        let range = ss.range(of: subStr)
        if range.location == NSNotFound {
            return false
        } else {
            return true
        }
    }
    //找出字符串内的数字
    func getIntFromString() -> Int {
        let scanner = Scanner.init(string: self)
        scanner.scanUpToCharacters(from: CharacterSet.decimalDigits, into: nil)
        var number: Int = 0
        scanner.scanInt(&number)
//        print(number)
        return number
    }
    
    var localized: String {
        return NSLocalizedString(self, comment: self)
    }
    
    /// 获取字符串宽度
    /// - Parameters：
    ///   - font：字符串的字体样式、字号大小
    ///   - size：主要是字符串的高度
    /// - Throws：
    /// - Returns：字符串宽度值
    ///
    /// 这是一个获取字符串的宽度的方法，用于计算得到一个高度固定的字符串的宽度
    func strWidth(font: UIFont, size: CGSize) -> CGFloat {
        let rect = NSString(string: self).boundingRect(with: CGSize(width: size.width, height: size.height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.width)
    }
    
    /// 获取字符串高度
    /// - Parameters：
    ///   - font：字符串的字体样式、字号大小
    ///   - size：主要是字符串的高度
    /// - Throws：
    /// - Returns：字符串高度值
    ///
    /// 这是一个获取字符串的高度的方法，用于计算得到一个宽度固定的字符串的高度
    func strHeight(font: UIFont, size: CGSize) -> CGFloat {
        let rect = NSString(string: self).boundingRect(with: CGSize(width: size.width, height: size.height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.height)
    }
    
    var unicodeDescription : String{
        return self.stringByReplaceUnicode
    }
    
    var stringByReplaceUnicode : String{
        let tempStr1 = self.replacingOccurrences(of: "\\u", with: "\\U")
        let tempStr2 = tempStr1.replacingOccurrences(of: "\"", with: "\\\"")
        let tempStr3 = "\"".appending(tempStr2).appending("\"")
        let tempData = tempStr3.data(using: String.Encoding.utf8)
        var returnStr:String = ""
        do {
            returnStr = try PropertyListSerialization.propertyList(from: tempData!, options: [.mutableContainers], format: nil) as! String
        } catch {
            
        }
        return returnStr.replacingOccurrences(of: "\\n", with: "\n")
    }
}

public extension NSMutableAttributedString {
    class func attributedString(font: UIFont, textColor: UIColor, lineSpace: CGFloat, lineBreakMode: NSLineBreakMode, textAlignment: NSTextAlignment, text: String) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpace
        paragraphStyle.lineBreakMode = lineBreakMode
        paragraphStyle.alignment = textAlignment

        let attStr = NSMutableAttributedString(string: text)
        let range = NSMakeRange(0, attStr.length)

        attStr.beginEditing()
        attStr.addAttributes([NSAttributedString.Key.font: font,
                              NSAttributedString.Key.foregroundColor: textColor,
                              NSAttributedString.Key.paragraphStyle: paragraphStyle], range: range)
        attStr.endEditing()

        return attStr
    }
}

public extension String {
    func hmac(by algorithm: Algorithm, key: [UInt8]) -> [UInt8] {
        var result = [UInt8](repeating: 0, count: algorithm.digestLength())
        CCHmac(algorithm.algorithm(), key, key.count, self.bytes, self.bytes.count, &result)
        return result
    }
    
    func hashHex(by algorithm: Algorithm) -> String {
        return algorithm.hash(string: self).hexString
    }
    
     func hash(by algorithm: Algorithm) -> [UInt8] {
        return algorithm.hash(string: self)
     }
}


public enum Algorithm {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    
    func algorithm() -> CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .MD5:    result = kCCHmacAlgMD5
        case .SHA1:   result = kCCHmacAlgSHA1
        case .SHA224: result = kCCHmacAlgSHA224
        case .SHA256: result = kCCHmacAlgSHA256
        case .SHA384: result = kCCHmacAlgSHA384
        case .SHA512: result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
    
    func digestLength() -> Int {
        var result: CInt = 0
        switch self {
        case .MD5:    result = CC_MD5_DIGEST_LENGTH
        case .SHA1:   result = CC_SHA1_DIGEST_LENGTH
        case .SHA224: result = CC_SHA224_DIGEST_LENGTH
        case .SHA256: result = CC_SHA256_DIGEST_LENGTH
        case .SHA384: result = CC_SHA384_DIGEST_LENGTH
        case .SHA512: result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
    
    func hash(string: String) -> [UInt8] {
        var hash = [UInt8](repeating: 0, count: self.digestLength())
        switch self {
        case .MD5:    CC_MD5(   string.bytes, CC_LONG(string.bytes.count), &hash)
        case .SHA1:   CC_SHA1(  string.bytes, CC_LONG(string.bytes.count), &hash)
        case .SHA224: CC_SHA224(string.bytes, CC_LONG(string.bytes.count), &hash)
        case .SHA256: CC_SHA256(string.bytes, CC_LONG(string.bytes.count), &hash)
        case .SHA384: CC_SHA384(string.bytes, CC_LONG(string.bytes.count), &hash)
        case .SHA512: CC_SHA512(string.bytes, CC_LONG(string.bytes.count), &hash)
        }
        return hash
    }
}

public extension Array where Element == UInt8 {
    var hexString: String {
        return self.reduce(""){$0 + String(format: "%02x", $1)}
    }
    
    var base64String: String {
        return self.data.base64EncodedString(options: Data.Base64EncodingOptions.lineLength76Characters)
    }
    
    var data: Data {
        return Data(self)
    }
}

public extension String {
    var bytes: [UInt8] {
        return [UInt8](self.utf8)
    }
}

public extension Data {
    var bytes: [UInt8] {
        return [UInt8](self)
    }
}
