
import UIKit

private var clickDelayTime = UnsafeRawPointer("clickDelayTime".withCString { $0 })
private var defaultDelayTime: TimeInterval = 0.0
private var lastClickTime: TimeInterval = 0.0

public extension UIButton {
    var delayTime: TimeInterval {
        set {
            objc_setAssociatedObject(self, &clickDelayTime, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let clickDelayTime = objc_getAssociatedObject(self, &clickDelayTime) as? TimeInterval {
                return clickDelayTime
            }
            return defaultDelayTime
        }
    }
    
    open override func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        if delayTime == 0.0 {
            super.sendAction(action, to: target, for: event)
        } else {
            if lastClickTime == 0.0 {
                super.sendAction(action, to: target, for: event)
                lastClickTime = Date().timeIntervalSince1970
            } else {
                if Date().timeIntervalSince1970 - lastClickTime > delayTime {
                    lastClickTime = Date().timeIntervalSince1970
                    super.sendAction(action, to: target, for: event)
                }
            }
        }
    }
}
