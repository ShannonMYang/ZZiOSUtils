
import Foundation
import UIKit

public enum JYDashLineDirection: Int {
    case vertical = 0
    case horizontal = 1
}

public enum JYShadowType: Int {
    case all = 0 /// 四周
    case top = 1 /// 上方
    case left = 2 /// 左边
    case right = 3 /// 右边
    case bottom = 4 /// 下方
}

public extension UIView {
    public var x: CGFloat {
        get {
            return frame.origin.x
        } set(value) {
            frame = CGRect(x: value, y: y, width: width, height: height)
        }
    }

    public var y: CGFloat {
        get {
            return frame.origin.y
        } set(value) {
            frame = CGRect(x: x, y: value, width: width, height: height)
        }
    }

    public var width: CGFloat {
        get {
            return frame.size.width
        } set(value) {
            frame = CGRect(x: x, y: y, width: value, height: height)
        }
    }

    public var height: CGFloat {
        get {
            return frame.size.height
        } set(value) {
            frame = CGRect(x: x, y: y, width: width, height: value)
        }
    }

    public var left: CGFloat {
        get {
            return x
        } set(value) {
            x = value
        }
    }

    public var right: CGFloat {
        get {
            return x + width
        } set(value) {
            x = value - width
        }
    }

    public var bottom: CGFloat {
        get {
            return y + height
        } set(value) {
            y = value - height
        }
    }

    /// 移除所有的子视图
    public func removeAllSubViews () {
        for subView in self.subviews {
            subView.removeFromSuperview()
        }
    }
    
    /// 寻找某个类型子视图
    /// - Parameter childViewType: 子视图类型
    /// - Returns: 返回这个类型对象
    public func findSubView<T>(childViewType: T.Type) -> T? {
        if let subView = self as? T {
            return subView
        }
        for subview in self.subviews {
            if let view = subview.findSubView(childViewType: childViewType) {
                return view
            }
        }
        return nil
    }
    

}

// MARK: - 关于UIView的 圆角、阴影、边框、虚线 的设置
extension UIView {
    
    /// 默认设置：黑色阴影
    public func shadow(_ type: JYShadowType) {
        shadow(type: type, color: .black, opactiy: 0.4, shadowSize: 4)
    }
    
    /// 设置阴影
    public func shadow(type: JYShadowType, color: UIColor, opactiy: Float, shadowSize: CGFloat) {
        layer.masksToBounds = false // 必须要等于NO否则会把阴影切割隐藏掉
        layer.shadowColor = color.cgColor // 阴影颜色
        layer.shadowOpacity = opactiy // 阴影透明度，默认0
        layer.shadowOffset = .zero // shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
        layer.shadowRadius = 3 // 阴影半径，默认3
        var shadowRect: CGRect?
        switch type {
        case .all:
            shadowRect = CGRect(x: -shadowSize, y: -shadowSize, width: bounds.size.width + 2 * shadowSize, height: bounds.size.height + 2 * shadowSize)
        case .top:
            shadowRect = CGRect(x: -shadowSize, y: -shadowSize, width: bounds.size.width + 2 * shadowSize, height: 2 * shadowSize)
        case .bottom:
            shadowRect = CGRect(x: -shadowSize, y: bounds.size.height - shadowSize, width: bounds.size.width + 2 * shadowSize, height: 2 * shadowSize)
        case .left:
            shadowRect = CGRect(x: -shadowSize, y: -shadowSize, width: 2 * shadowSize, height: bounds.size.height + 2 * shadowSize)
        case .right:
            shadowRect = CGRect(x: bounds.size.width - shadowSize, y: -shadowSize, width: 2 * shadowSize, height: bounds.size.height + 2 * shadowSize)
        }
        layer.shadowPath = UIBezierPath(rect: shadowRect!).cgPath
    }

    ///添加圆角
    /// - Parameters:
    ///   - conrners: 具体哪个圆角
    ///   - radius: 圆角的大小
    public func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    /// 添加圆角和边框
    /// - Parameters:
    ///   - conrners: 具体哪个圆角
    ///   - radius: 圆角的大小
    ///   - borderWidth: 边框的宽度
    ///   - borderColor: 边框的颜色
    func addCorner(conrners: UIRectCorner , radius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: conrners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
        
        // Add border
        let borderLayer = CAShapeLayer()
        borderLayer.path = maskLayer.path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.lineWidth = borderWidth
        borderLayer.frame =  self.bounds
        self.layer.addSublayer(borderLayer)
    }
    
    /// 设置半切边
    func addCorner(conrners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: conrners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    
    /// 绘制虚线
    /// - Parameters:
    ///   - strokeColor: 虚线颜色
    ///   - lineLength: 每段虚线的长度
    ///   - lineSpacing: 每段虚线的间隔
    ///   - direction: 虚线的方向
    func drawDashLine(strokeColor: UIColor,
                       lineLength: CGFloat = 4,
                      lineSpacing: CGFloat = 4,
                        direction: JYDashLineDirection = .horizontal) {
        // 线粗
        let lineWidth = direction == .horizontal ? self.height : self.width
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = self.bounds
        shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        shapeLayer.fillColor = UIColor.blue.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPhase = 0
        // 每一段虚线长度 和 每两段虚线之间的间隔
        shapeLayer.lineDashPattern = [NSNumber(value: lineLength), NSNumber(value: lineSpacing)]
        // 起点
        let path = CGMutablePath()
        if direction == .horizontal {
            path.move(to: CGPoint(x: 0, y: lineWidth / 2))
            // 终点
            // 横向 y = lineWidth / 2
            path.addLine(to: CGPoint(x: self.width, y: lineWidth / 2))
        } else {
            path.move(to: CGPoint(x: lineWidth / 2, y: 0))
            // 终点
            // 纵向 Y = view 的height
            path.addLine(to: CGPoint(x: lineWidth / 2, y: self.height))
        }
        shapeLayer.path = path
        self.layer.addSublayer(shapeLayer)
    }
    
    /// 按键呼吸灯scale动画
    func addScaleAnimation(repeatCount: Float) {
        
        let scaleAnimation = CAKeyframeAnimation.init(keyPath: "transform.scale")
        scaleAnimation.repeatCount = MAXFLOAT
        scaleAnimation.values = [NSNumber(value: 1.0), NSNumber(value: 1.1), NSNumber(value: 1.0), NSNumber(value: 1.0), NSNumber(value: 1.1), NSNumber(value: 1.0), NSNumber(value: 1.0)]
        scaleAnimation.keyTimes = [NSNumber(value: 0.0), NSNumber(value: 0.1), NSNumber(value: 0.2), NSNumber(value: 0.3), NSNumber(value: 0.4), NSNumber(value: 0.5), NSNumber(value: 1.0)]
        scaleAnimation.timingFunctions = [
            CAMediaTimingFunction(name: .easeIn),
            CAMediaTimingFunction(name: .easeOut),
            CAMediaTimingFunction(name: .linear),
            CAMediaTimingFunction(name: .easeIn),
            CAMediaTimingFunction(name: .easeOut),
            CAMediaTimingFunction(name: .linear)
        ]
        scaleAnimation.duration = 4
        scaleAnimation.isRemovedOnCompletion = false
        self.layer.add(scaleAnimation, forKey: nil)
        
    }
    
}

// MARK: - 继承于 UIView 视图的 平面、3D 旋转 以及 缩放、位移
extension UIView {
    
    /// 平面旋转
    /// - Parameters:
    ///   - angle: 旋转多少度
    ///   - isInverted: 顺时针还是逆时针，默认是顺时针
    public func setRotation(_ angle: CGFloat, isInverted: Bool = false) {
        let radians = Double(angle) / 180 * Double.pi
        self.transform = isInverted ? CGAffineTransform(rotationAngle: CGFloat(radians)).inverted() : CGAffineTransform(rotationAngle: CGFloat(radians))
    }
    
    /// 沿X轴方向旋转多少度(3D旋转)
    /// - Parameter angle: 旋转角度，angle参数是旋转的角度，为弧度制 0-2π
    public func set3DRotationX(_ angle: CGFloat) {
        // 初始化3D变换,获取默认值
        //var transform = CATransform3DIdentity
        // 透视 1/ -D，D越小，透视效果越明显，必须在有旋转效果的前提下，才会看到透视效果
        // 当我们有垂直于z轴的旋转分量时，设置m34的值可以增加透视效果，也可以理解为景深效果
        // transform.m34 = 1.0 / -1000.0
        // 空间旋转，x，y，z决定了旋转围绕的中轴，取值为 (-1,1) 之间
        //transform = CATransform3DRotate(transform, angle, 1.0, 0.0, 0.0)
        //self.layer.transform = transform
        self.layer.transform = CATransform3DMakeRotation(angle, 1.0, 0.0, 0.0)
    }
    
    /// 沿 Y 轴方向旋转多少度
    /// - Parameter angle: 旋转角度，angle参数是旋转的角度，为弧度制 0-2π
    public func set3DRotationY(_ angle: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, angle, 0.0, 1.0, 0.0)
        self.layer.transform = transform
    }
    
    /// 沿 Z 轴方向旋转多少度
    /// - Parameter angle: 旋转角度，angle参数是旋转的角度，为弧度制 0-2π
    public func set3DRotationZ(_ angle: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, angle, 0.0, 0.0, 1.0)
        self.layer.transform = transform
    }
    
    /// 沿 X、Y、Z 轴方向同时旋转多少度(3D旋转)
    /// - Parameters:
    ///   - xAngle: x 轴的角度，旋转的角度，为弧度制 0-2π
    ///   - yAngle: y 轴的角度，旋转的角度，为弧度制 0-2π
    ///   - zAngle: z 轴的角度，旋转的角度，为弧度制 0-2π
    public func setRotation(xAngle: CGFloat, yAngle: CGFloat, zAngle: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, xAngle, 1.0, 0.0, 0.0)
        transform = CATransform3DRotate(transform, yAngle, 0.0, 1.0, 0.0)
        transform = CATransform3DRotate(transform, zAngle, 0.0, 0.0, 1.0)
        self.layer.transform = transform
    }
    
    /// 设置 x,y 缩放
    /// - Parameters:
    ///   - x: x 放大的倍数
    ///   - y: y 放大的倍数
    public func setScale(x: CGFloat, y: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DScale(transform, x, y, 1)
        self.layer.transform = transform
    }
    
    public func flip(isHorizontal: Bool) {
        if isHorizontal {
            // 水平
            self.transform = self.transform.scaledBy(x: -1.0, y: 1.0)
        } else {
            // 垂直
            self.transform = self.transform.scaledBy(x: 1.0, y: -1.0)
        }
    }
    
    /// 移动到指定中心点位置
    public func moveToPoint(point: CGPoint) {
        var center = self.center
        center.x = point.x
        center.y = point.y
        self.center = center
    }
    
}
