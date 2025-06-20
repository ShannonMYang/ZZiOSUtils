
import Foundation
import UIKit

private var erHitScale = UnsafeRawPointer("erHitScale".withCString { $0 })
private var erHitEdgeInsets = UnsafeRawPointer("erHitEdgeInsets".withCString { $0 })

public typealias BtnBlock = () -> Void
private var overviewKey = 0

// 扩大点击区域
public extension UIButton {
    @objc var hitScale: CGFloat {
        set(newValue) {
            objc_setAssociatedObject(self, &erHitScale, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let sc = objc_getAssociatedObject(self, &erHitScale) as? CGFloat {
                return sc
            }
            return 1.0
        }
    }

    var hitEdgeInsets: UIEdgeInsets {
        set(newValue) {
            objc_setAssociatedObject(self, &erHitEdgeInsets, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let ed = objc_getAssociatedObject(self, &erHitEdgeInsets) as? UIEdgeInsets {
                return ed
            }
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if hitScale == 1 {
            return super.point(inside: point, with: event)
        } else {
            let buttonBounds = bounds
            let width = buttonBounds.size.width * hitScale
            let height = buttonBounds.size.height * hitScale
            hitEdgeInsets = UIEdgeInsets(top: -height, left: -width, bottom: -height, right: -width)
            let hitFrame = buttonBounds.inset(by: hitEdgeInsets)
            return hitFrame.contains(point)
        }
    }
}

/// click
extension UIButton {
    func handle(_ block: @escaping BtnBlock) {
        objc_setAssociatedObject(self, &overviewKey, block, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        addTarget(self, action: #selector(btnClicked(_:)), for: .touchUpInside)
    }

    @objc func btnClicked(_ sender: UIView) {
        if let block = objc_getAssociatedObject(self, &overviewKey) as? BtnBlock {
            block()
        }
    }
}
