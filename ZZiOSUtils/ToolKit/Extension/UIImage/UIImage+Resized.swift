//
//  UIImage+Resized.swift
//  Runner
//
import UIKit

public extension UIImage {
    func scaledTo(constrain targetSize: CGSize) -> UIImage? {
        let rawWidth = Int(targetSize.width)

        guard let imageRef = self.cgImage else {
            return nil
        }

        var targetWidth = imageRef.width
        var targetHeight = imageRef.height

        if self.imageOrientation == .up
                   || self.imageOrientation == .down
                   || self.imageOrientation == .upMirrored
                   || self.imageOrientation == .downMirrored {
            if CGSize.zero.equalTo(targetSize) || rawWidth > imageRef.width {
                targetWidth = imageRef.width
                targetHeight = imageRef.height
            } else {
                targetWidth = rawWidth
                targetHeight = imageRef.height * rawWidth / imageRef.width
            }
        } else {
            if CGSize.zero.equalTo(targetSize) || rawWidth > imageRef.height {
                targetWidth = imageRef.height
                targetHeight = imageRef.width
            } else {
                targetHeight = rawWidth
                targetWidth = imageRef.width * rawWidth / imageRef.height
            }
        }

        let colorSpace = CGColorSpaceCreateDeviceRGB();
        guard let context = CGContext(data: nil,
                width: targetWidth,
                height: targetHeight,
                bitsPerComponent: 8,
                bytesPerRow: 4 * targetWidth,
                space: colorSpace,
                bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue) else {
            return nil
        }

        let transform = self.transformForOrientation(CGSize(width: 0, height: 0))
        context.concatenate(transform)

        if (self.imageOrientation == .up
                || self.imageOrientation == .down
                || self.imageOrientation == .upMirrored
                || self.imageOrientation == .downMirrored) {
            context.draw(imageRef, in: CGRect(x: 0, y: 0, width: targetWidth, height: targetHeight))
        } else {
            context.draw(imageRef, in: CGRect(x: 0, y: 0, width: targetHeight, height: targetWidth))
        }

        if let cgImage = context.makeImage() {
            return UIImage(cgImage: cgImage)
        }

        return nil
    }

    func transformForOrientation(_ size: CGSize) -> CGAffineTransform {
        var transform = CGAffineTransform.identity
        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: .pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: .pi / 2)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: .pi / 2 * -1)
        default:
            break
        }

        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: -1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: -1)
        default:
            break
        }

        return transform
    }
}
