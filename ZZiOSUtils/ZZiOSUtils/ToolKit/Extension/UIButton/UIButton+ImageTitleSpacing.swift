//
//  UIButton+ImageTitleSpacing.m
//  ESFileExplorer
//
//  Created by Li,Guoqiang on 2018/10/30.
//  Copyright © 2018 Xiaoxiong Bowang. All rights reserved.
//
import UIKit

public enum ImageAt {
    case top
    case left
    case bottom
    case right
}

public extension UIButton {
    func layoutImageAt(_ position: ImageAt, spacing space: CGFloat) {
        guard let imageView = self.imageView,
              let titleLabel = self.titleLabel else {
            return
        }

        // 1. 得到imageView和titleLabel的宽、高
        let imageWidth = imageView.image?.size.width ?? 0
        let imageHeight = imageView.image?.size.height ?? 0

        let labelWidth = titleLabel.intrinsicContentSize.width
        let labelHeight = titleLabel.intrinsicContentSize.height

        // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
        var imageEdgeInsets = UIEdgeInsets.zero;
        var labelEdgeInsets = UIEdgeInsets.zero;
                
        // 3. 根据style和space得到imageEdgeInsets和labelEdgeInsets的值
        switch (position) {
        case .top:
            if UIView.userInterfaceLayoutDirection(for: self.semanticContentAttribute) == .rightToLeft {
                imageEdgeInsets = UIEdgeInsets(top: -labelHeight - space / 2.0, left: -labelWidth, bottom: 0, right: 0);
                labelEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -imageHeight - space / 2.0, right: -imageWidth);
            } else {
                imageEdgeInsets = UIEdgeInsets(top: -labelHeight - space / 2.0, left: 0, bottom: 0, right: -labelWidth);
                labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: -imageHeight - space / 2.0, right: 0);
            }
        case .left:
            if UIView.userInterfaceLayoutDirection(for: self.semanticContentAttribute) == .rightToLeft {
                imageEdgeInsets = UIEdgeInsets(top: 0, left: space / 2.0, bottom: 0, right: -space / 2.0);
                labelEdgeInsets = UIEdgeInsets(top: 0, left: -space / 2.0, bottom: 0, right: space / 2.0);
            } else {
                imageEdgeInsets = UIEdgeInsets(top: 0, left: -space / 2.0, bottom: 0, right: space / 2.0);
                labelEdgeInsets = UIEdgeInsets(top: 0, left: space / 2.0, bottom: 0, right: -space / 2.0);
            }
        case .bottom:
            if UIView.userInterfaceLayoutDirection(for: self.semanticContentAttribute) == .rightToLeft {
                imageEdgeInsets = UIEdgeInsets(top: 0, left: -labelWidth, bottom: -labelHeight - space / 2.0, right: 0);
                labelEdgeInsets = UIEdgeInsets(top: -imageHeight - space / 2.0, left: 0, bottom: 0, right: -imageWidth);
            } else {
                imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight - space / 2.0, right: -labelWidth);
                labelEdgeInsets = UIEdgeInsets(top: -imageHeight - space / 2.0, left: -imageWidth, bottom: 0, right: 0);
            }
        case .right:
            if UIView.userInterfaceLayoutDirection(for: self.semanticContentAttribute) == .rightToLeft {
                imageEdgeInsets = UIEdgeInsets(top: 0, left: -labelWidth - space / 2.0, bottom: 0, right: labelWidth + space / 2.0);
                labelEdgeInsets = UIEdgeInsets(top: 0, left: imageWidth + space / 2.0, bottom: 0, right: -imageWidth - space / 2.0);
            } else {
                imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth + space / 2.0, bottom: 0, right: -labelWidth - space / 2.0);
                labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth - space / 2.0, bottom: 0, right: imageWidth + space / 2.0);
            }
        }

        // 4. 赋值
        self.titleEdgeInsets = labelEdgeInsets;
        self.imageEdgeInsets = imageEdgeInsets;
    }
}
