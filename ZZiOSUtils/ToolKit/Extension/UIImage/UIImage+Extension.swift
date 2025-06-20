//
//  UIImage+Ex.swift
//  PictureLive
//
//  Created by Qi on 2021/1/29.
//

import Foundation
import UIKit


public extension UIImage {
    
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect.init(origin: CGPoint.zero, size: size)
        UIGraphicsBeginImageContext(size)
        defer {
            UIGraphicsEndImageContext()
        }
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(rect)

            if let cgImage = context.makeImage() {
                self.init(cgImage: cgImage)
                return
            }
        }
        return nil
    }
    
    convenience init?(colors: [UIColor], size: CGSize) {
        let cgColors = colors.map { color -> CGColor in
            color.cgColor
        }

        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        defer {
            UIGraphicsEndImageContext()
        }

        if let context = UIGraphicsGetCurrentContext() {
            guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                            colors: cgColors as CFArray, locations: nil) else {
                return nil
            }

            context.drawLinearGradient(gradient,
                                       start: CGPoint.zero,
                                       end: CGPoint(x: size.width, y: size.height),
                                       options: [.drawsBeforeStartLocation,
                                                 .drawsAfterEndLocation])

            if let cgImage = context.makeImage() {
                self.init(cgImage: cgImage)
                return
            }
        }

        return nil
    }

    // 压缩image
    public static func compressImage(_ image: UIImage, toByte maxLength: Int, success: @escaping (UIImage) -> Void) {
        DispatchQueue.global().async { // 并行、异步
            var compression: CGFloat = 1
            guard var data = image.jpegData(compressionQuality: compression),
                  data.count > maxLength else {
                DispatchQueue.main.async { // 串行、异步
                    success(image)
                }
                return
            }

            // Compress by size
            var max: CGFloat = 1
            var min: CGFloat = 0
            for _ in 0 ..< 6 {
                compression = (max + min) / 2
                data = image.jpegData(compressionQuality: compression)!
                if CGFloat(data.count) < CGFloat(maxLength) * 0.9 {
                    min = compression
                } else if data.count > maxLength {
                    max = compression
                } else {
                    break
                }
            }
            var resultImage: UIImage = UIImage(data: data)!
            if data.count < maxLength {
                DispatchQueue.main.async {
                    success(resultImage)
                }
                return
            }

            // Compress by size
            var lastDataLength: Int = 0
            while data.count > maxLength, data.count != lastDataLength {
                lastDataLength = data.count
                let ratio: CGFloat = CGFloat(maxLength) / CGFloat(data.count)
                let size: CGSize = CGSize(width: Int(resultImage.size.width * sqrt(ratio)),
                                          height: Int(resultImage.size.height * sqrt(ratio)))
                UIGraphicsBeginImageContext(size)
                resultImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                resultImage = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
                data = resultImage.jpegData(compressionQuality: compression)!
            }
            DispatchQueue.main.async {
                success(resultImage)
            }
        }
    }
    
    func imageCompressForCameraPicture() -> UIImage?{
        let compressImage = self.compress()
        if compressImage == nil{
            return nil
        }
        
        let newImg = UIImage.init(data: compressImage!.jpegData(compressionQuality: 0.001)!)
        return newImg
    }
    
    func withBackground(color: UIColor, opaque: Bool = true) -> UIImage {
       UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
           
       guard let ctx = UIGraphicsGetCurrentContext(), let image = cgImage else { return self }
       defer { UIGraphicsEndImageContext() }
           
       let rect = CGRect(origin: .zero, size: size)
       ctx.setFillColor(color.cgColor)
       ctx.fill(rect)
       ctx.concatenate(CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: size.height))
       ctx.draw(image, in: rect)
           
       return UIGraphicsGetImageFromCurrentImageContext() ?? self
     }
    
    func compress() -> UIImage?{
        let size = self.size
        let qualityRatio = 0.7
        let width = size.width * qualityRatio
        let height = size.height * qualityRatio
        UIGraphicsBeginImageContext(CGSize.init(width: width, height: height))
        self.draw(in: CGRect.init(x: 0, y: 0, width: width, height: height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func fixOrientation() -> UIImage {
        // No-op if the orientation is already correct
        if (self.imageOrientation == .up) {
            return self
        }
        
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform = CGAffineTransformIdentity
        
        switch (self.imageOrientation) {
            case .down, .downMirrored:
                transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
                transform = CGAffineTransformRotate(transform, .pi);
                break;
                
            case .left, .leftMirrored:
                transform = CGAffineTransformTranslate(transform, self.size.width, 0);
                transform = CGAffineTransformRotate(transform, .pi / 2);
                break;
                
            case .right, .rightMirrored:
                transform = CGAffineTransformTranslate(transform, 0, self.size.height);
                transform = CGAffineTransformRotate(transform, -(.pi / 2));
                break;
            default:
                break;
        }
        
        switch (self.imageOrientation) {
        case .upMirrored, .downMirrored:
                transform = CGAffineTransformTranslate(transform, self.size.width, 0);
                transform = CGAffineTransformScale(transform, -1, 1);
                break;
                
        case .leftMirrored, .rightMirrored:
                transform = CGAffineTransformTranslate(transform, self.size.height, 0);
                transform = CGAffineTransformScale(transform, -1, 1);
                break;
            default:
                break;
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        
        guard let cgImg = self.cgImage else { return self }

        
        let ctx = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: cgImg.bitsPerComponent, bytesPerRow: 0, space: cgImg.colorSpace!, bitmapInfo: cgImg.bitmapInfo.rawValue)
        
        ctx!.concatenate(transform);
        switch (self.imageOrientation) {
        case .left, .leftMirrored, .right, .rightMirrored:
                // Grr...
            ctx?.draw(cgImg, in: CGRect(x: 0, y: 0, width: self.size.height, height: self.size.width))
                break;
                
            default:
            ctx?.draw(cgImg, in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
                break;
        }
        
        // And now we just create a new UIImage from the drawing context
        guard let newCGImg = ctx?.makeImage() else { return self }
        let img = UIImage(cgImage: newCGImg)
        return img;
    }
        
    
}
