//
// Created by Liu Shuai on 7/16/20.
// Copyright (c) 2020 The Chromium Authors. All rights reserved.
//
import UIKit

public extension UIImage {
    ///
    /// 使用 CGImageAlphaInfo.premultipliedLast & CGBitmapInfo.byteOrder32Big 的方式填充给定的 [UInt8]
    ///
    /// 需要的大小： count = width * height * 4；布局方式： RGBA
    ///
    /// - Parameter pixels: 待填充的内存区域
    /// - Returns: 是否填充成功
    func fill(to pixels: inout [UInt8]) -> Bool {
        guard let cgImage = self.cgImage else {
            return false
        }

        let width = cgImage.width
        let height = cgImage.height

        // 使用内存布局的方式需要 CGImageAlphaInfo.premultipliedLast & CGBitmapInfo.byteOrder32Big
        // 这是 CMTProcessor 使用的内存布局
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
        let bytesPerRow = width * 4  // RGBA，需要 4 bytes
        let colorSpace = CGColorSpaceCreateDeviceRGB()

        if let context = CGContext(data: &pixels,
                width: width,
                height: height,
                bitsPerComponent: 8,
                bytesPerRow: bytesPerRow,
                space: colorSpace,
                bitmapInfo: bitmapInfo) {
            self.draw(in: CGRect(x: 0, y: 0, width: width, height: height), on: context)
            return true
        }

        return false
    }

    ///
    /// 使用仅 Alpha通道填充 [UInt8]
    ///
    /// 需要的大小： count = width * height * 1；布局方式：A
    ///
    /// - Parameters:
    ///   - pixels: 待填充的内存区域
    ///   - size: 如果指定大小，则缩放图片为指定大小
    /// - Returns: 是否填充成功
    func fillAlphaOnly(to pixels: inout [UInt8], size: CGSize = CGSize.zero) -> Bool {
        guard let cgImage = self.cgImage else {
            return false
        }

        let width = size == CGSize.zero ? cgImage.width : Int(size.width)
        let height = size == CGSize.zero ? cgImage.height : Int(size.height)

        let bitmapInfo = CGImageAlphaInfo.alphaOnly.rawValue
        let bytesPerRow = width * 1 // 仅有 Alpha，所以只有 1 byte
        let colorSpace = CGColorSpaceCreateDeviceGray() // alphaOnly 需要使用 CGColorSpaceCreateDeviceGray

        if let context = CGContext(data: &pixels,
                width: width,
                height: height,
                bitsPerComponent: 8,
                bytesPerRow: bytesPerRow,
                space: colorSpace,
                bitmapInfo: bitmapInfo) {
            self.draw(in: CGRect(x: 0, y: 0, width: width, height: height), on: context)
            return true
        }
        return false
    }

    ///
    /// 转换 fill 方法填充的内存数据成 UIImage
    ///
    /// - Parameters:
    ///   - pixels: CGImageAlphaInfo.premultipliedLast & CGBitmapInfo.byteOrder32Big 布局的内存区域
    ///   - width: 图片的宽
    ///   - height: 图片的高
    ///   - scale: 图片的缩放
    ///   - orientation: 图片的方向
    /// - Returns: UIImage? 对象
    convenience init?(pixels: [UInt8], width: Int, height: Int,
                      scale: CGFloat = 1, orientation: UIImage.Orientation = .up) {
        let data = UnsafeMutablePointer<UInt8>.allocate(capacity: pixels.count)
        data.initialize(from: pixels, count: pixels.count)
        let provider = CGDataProvider(dataInfo: data, data: data, size: pixels.count) { (_, data, _) in
            data.deallocate()
        }

        let bitsPerComponent = 8
        let bitsPerPixel = 32
        let bytesPerRow = (bitsPerPixel / bitsPerComponent) * width
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue

        if let cgImage = CGImage(width: width, height: height, bitsPerComponent: bitsPerComponent,
                bitsPerPixel: bitsPerPixel,
                bytesPerRow: bytesPerRow,
                space: CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: CGBitmapInfo(rawValue: bitmapInfo),
                provider: provider!,
                decode: nil,
                shouldInterpolate: true,
                intent: .defaultIntent) {
            self.init(cgImage: cgImage, scale: scale, orientation: .up)
            return
        } else {
            return nil
        }
    }
    
    //二分法压缩图片至指定大小
    func compressImage(maxLength: Int) -> Data {
           // let tempMaxLength: Int = maxLength / 8
           let tempMaxLength: Int = maxLength
           var compression: CGFloat = 1
           guard var data = self.jpegData(compressionQuality: compression), data.count > tempMaxLength else { return self.jpegData(compressionQuality: compression)! }
           
           // 压缩大小
           var max: CGFloat = 1
           var min: CGFloat = 0
           for _ in 0..<6 {
               compression = (max + min) / 2
               data = self.jpegData(compressionQuality: compression)!
               if CGFloat(data.count) < CGFloat(tempMaxLength) * 0.9 {
                   min = compression
               } else if data.count > tempMaxLength {
                   max = compression
               } else {
                   break
               }
           }
           var resultImage: UIImage = UIImage(data: data)!
           if data.count < tempMaxLength { return data }
           
           // 压缩大小
           var lastDataLength: Int = 0
           while data.count > tempMaxLength && data.count != lastDataLength {
               lastDataLength = data.count
               let ratio: CGFloat = CGFloat(tempMaxLength) / CGFloat(data.count)
             
               let size: CGSize = CGSize(width: Int(resultImage.size.width * sqrt(ratio)),
                                         height: Int(resultImage.size.height * sqrt(ratio)))
               UIGraphicsBeginImageContext(size)
               resultImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
               resultImage = UIGraphicsGetImageFromCurrentImageContext()!
               UIGraphicsEndImageContext()
               data = resultImage.jpegData(compressionQuality: compression)!
           }
           return data
       }
}
