//
//  UITextField+Extension.swift
//  JYToolKit
//
//  Created by 王震 on 2024/4/1.
//

import Foundation
import UIKit

public extension UITextField {
    
    /// 添加左边的内边距
    /// - Parameter padding: 边距
    func addLeftTextPadding(_ padding: CGFloat) {
        let leftView = UIView()
        leftView.frame = CGRect(x: 0, y: 0, width: padding, height: self.frame.height)
        self.leftView = leftView
        self.leftViewMode = UITextField.ViewMode.always
    }
    
    /// 添加左边的图片
    /// - Parameters:
    ///   - image: 左边的图片
    ///   - leftViewFrame: 左边view的frame
    ///   - imageSize: 图片的大小
    func addLeftIcon(_ image: UIImage?, leftViewFrame: CGRect, imageSize: CGSize) {
        let leftView = UIView()
        leftView.frame = leftViewFrame
        let imgageView = UIImageView()
        imgageView.frame = CGRect(x: leftViewFrame.width - 8 - imageSize.width, y: (leftViewFrame.height - imageSize.height) / 2, width: imageSize.width, height: imageSize.height)
        imgageView.image = image
        leftView.addSubview(imgageView)
        self.leftView = leftView
        self.leftViewMode = UITextField.ViewMode.always
    }
    
    /// 是否都是数字
    /// - Returns: 返回结果
    func validateDigits() -> Bool {
        let digitsRegEx = "[0-9]*"
        let digitsTest = NSPredicate(format: "SELF MATCHES %@", digitsRegEx)
        return digitsTest.evaluate(with: self.text)
    }
    
    /// 设置富文本的占位符
    /// - Parameters:
    ///   - font: 字体的大小
    ///   - color: 字体的颜色
    func setPlaceholderAttribute(font: UIFont, color: UIColor = .black) {
        let arrStr = NSMutableAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font])
        self.attributedPlaceholder = arrStr
    }
    
}
