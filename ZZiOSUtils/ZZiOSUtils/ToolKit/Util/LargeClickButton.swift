//
//  LargeClickButton.swift
//  iWallart
//
//  Created by 谭鹏 on 2022/7/8.
//

import Foundation
import UIKit

public class LargeClickButton : UIButton {
    var largeSize:CGFloat = 5
    
    //按钮点击区域扩大largeSize
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var bounds = self.bounds
        bounds = bounds.insetBy(dx: -largeSize, dy: -largeSize)
        return bounds.contains(point)
    }
}
