//
// Created by Liu Shuai on 7/16/20.
// Copyright (c) 2020 The Chromium Authors. All rights reserved.
//
import UIKit

public extension UIImage {
    func draw(in rect: CGRect, on context: CGContext) {
        if let image = cgImage {
            context.draw(image, in: rect)
        }
    }

    func scaleToSize(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage
    }

    //截取image中间区域
    func cutImage() -> UIImage? {
        var reSize = CGSize()
        var reOrigin = CGPoint()
        
        if size.width >= size.height {
            reSize.width = CGFloat(cgImage!.height)
            reSize.height = CGFloat(cgImage!.height)

            reOrigin.y = 0
            reOrigin.x = (CGFloat(cgImage!.width) - CGFloat(cgImage!.height)) / 2
        } else {
            reSize.width = CGFloat(cgImage!.width)
            reSize.height = CGFloat(cgImage!.width)

            reOrigin.x = 0
            reOrigin.y = (CGFloat(cgImage!.height) - CGFloat(cgImage!.width)) / 2
        }

        let subImageRef = cgImage?.cropping(to: CGRect(x: reOrigin.x, y: reOrigin.y, width: reSize.width, height: reSize.height))
        let smallRect = CGRect.init(x: 0, y: 0, width: subImageRef!.width, height: subImageRef!.height)
        
        UIGraphicsBeginImageContext(reSize)
        let context = UIGraphicsGetCurrentContext()
        context?.draw(subImageRef!, in: smallRect)
        let cropedImage = UIImage.init(cgImage: subImageRef!)
        UIGraphicsEndImageContext()
        return cropedImage
    }
    
    static func imageWithImage(sourceImage: UIImage, scaledToSize targetSize: CGSize) -> UIImage? {
        let rawWidth = floor(targetSize.width)
        var targetWidth: CGFloat = 0
        var targetHeight: CGFloat = 0

        guard let imageRef = sourceImage.cgImage else {
            return nil
        }

        let imageOrientation = sourceImage.imageOrientation

        if imageOrientation == UIImage.Orientation.up
            || imageOrientation == UIImage.Orientation.down
            || imageOrientation == UIImage.Orientation.upMirrored
            || imageOrientation == UIImage.Orientation.downMirrored {
            if targetSize.equalTo(.zero) {
                targetWidth = CGFloat(imageRef.width)
                targetHeight = CGFloat(imageRef.height)
            } else if rawWidth >= CGFloat(imageRef.width) {
                targetWidth = CGFloat(imageRef.width)
                targetHeight = CGFloat(imageRef.height)
            } else {
                targetWidth = rawWidth
                targetHeight = CGFloat(imageRef.height) * rawWidth / CGFloat(imageRef.width)
            }
        } else {
            if targetSize.equalTo(.zero) {
                targetWidth = CGFloat(imageRef.height)
                targetHeight = CGFloat(imageRef.width)
            } else if rawWidth >= CGFloat(imageRef.height) {
                targetWidth = CGFloat(imageRef.height)
                targetHeight = CGFloat(imageRef.width)
            } else {
                targetWidth = rawWidth
                targetHeight = CGFloat(imageRef.width) * rawWidth / CGFloat(imageRef.height)
            }
        }
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)
        let colorSpaceInfo = CGColorSpaceCreateDeviceRGB()
        let bitmap = CGContext(data: nil, width: Int(targetWidth), height: Int(targetHeight), bitsPerComponent: imageRef.bitsPerComponent, bytesPerRow: 4 * Int(targetWidth), space: colorSpaceInfo, bitmapInfo: bitmapInfo.rawValue)
        let transform = sourceImage.transformForOrientation(CGSize(width: targetWidth, height: targetHeight))
        bitmap?.concatenate(transform)
        if imageOrientation == UIImage.Orientation.up
            || imageOrientation == UIImage.Orientation.down
            || imageOrientation == UIImage.Orientation.upMirrored
            || imageOrientation == UIImage.Orientation.downMirrored {
            bitmap?.draw(imageRef, in: CGRect(x: 0, y: 0, width: targetWidth, height: targetHeight))
        } else {
            bitmap?.draw(imageRef, in: CGRect(x: 0, y: 0, width: targetHeight, height: targetWidth))
        }
        var newImage: UIImage?
        if let ref = bitmap?.makeImage() {
            newImage = UIImage(cgImage: ref)
        }
        return newImage
    }
}
