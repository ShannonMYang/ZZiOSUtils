//
//  JYPlaceHolderTextView.swift
//  JYToolKit
//
//  Created by 王震 on 2024/4/1.
//

import UIKit

public class JYPlaceHolderTextView: UITextView {

    /// 占位符
    public var placeHolder: String = "" {
        didSet{
            self.setNeedsDisplay()
        }
    }
    /// 占位符的颜色
    public var placeHolderColor: UIColor = UIColor.gray {
        didSet{
            self.setNeedsDisplay()
        }
    }
    /// 富文本位置的调整
    public var placeholderOrigin: CGPoint = CGPoint(x: 5, y: 7) {
        didSet {
            self.setNeedsDisplay()
        }
    }
    /// 字体的大小
    public override var font: UIFont? {
        didSet{
            self.setNeedsDisplay()
        }
    }
    /// 文字
    public override var text: String! {
        didSet{
            self.setNeedsDisplay()
        }
    }
    /// 富文本
    public override var attributedText: NSAttributedString! {
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        /// 默认字号
        self.font = UIFont.systemFont(ofSize: 14)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChanged), name: UITextView.textDidChangeNotification, object: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 文字的变化
    /// - Parameter notification: NSNotification
    @objc func textDidChanged(notification: NSNotification) {
        self.setNeedsDisplay()
    }
    
    public override func draw(_ rect: CGRect) {
        if self.hasText {
            return
        }
        var newRect = CGRect()
        newRect.origin = self.placeholderOrigin
        let size = self.rectSize(font: self.font ?? UIFont.systemFont(ofSize: 14), size: rect.size)
        newRect.size.width = size.width
        newRect.size.height = size.height
        /// 将placeHolder画在textView上
        (self.placeHolder as NSString).draw(in: newRect, withAttributes: [NSAttributedString.Key.font: self.font ?? UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor: self.placeHolderColor])
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.setNeedsDisplay()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: self)
    }

    /// 对字符串(多行)指定出字体大小和最大的 Size，获取展示的 Size
    /// - Parameters:
    ///   - font: 字体大小
    ///   - size: 字符串的最大宽和高
    /// - Returns: 按照 font 和 Size 的字符的Size
    func rectSize(font: UIFont, size: CGSize) -> CGSize {
        let attributes = [NSAttributedString.Key.font: font]
        /**
         usesLineFragmentOrigin: 整个文本将以每行组成的矩形为单位计算整个文本的尺寸
         usesFontLeading:
         usesDeviceMetrics:
         @available(iOS 6.0, *)
         truncatesLastVisibleLine:
         */
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect: CGRect = self.placeHolder.boundingRect(with: size, options: option, attributes: attributes, context: nil)
        return rect.size
    }
    
}
