//
//  BubbleBackgroundView.swift
//  Fhood
//
//  Created by Matias Pequeno on 9/13/15.
//  Copyright © 2015 YOUNG&YOUM. All rights reserved.
//

import UIKit
import SMCalloutView

private var kBackgroundColor = UIColor(white: 0, alpha: 0.9)
private var kCalloutArrowImage: UIImage? = nil

final class BubbleBackgroundView: SMCalloutBackgroundView {
    private static var initOnceToken: dispatch_once_t = 0

    private let containerView = UIView()
    private let arrowView = UIView()
    private var arrowImageView = UIImageView()

    override var arrowPoint: CGPoint {
        didSet {
            self.setNeedsLayout()
        }
    }

    override var contentMask: CALayer {
        get {
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
            self.layer.renderInContext(UIGraphicsGetCurrentContext()!)
            let maskImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            let layer = CALayer()
            layer.frame = self.bounds
            layer.contents = maskImage.CGImage
            return layer
        }
        set { }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sharedInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.sharedInit()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let pointingUp = self.arrowPoint.y < self.frame.height / 2
        let dy: CGFloat = pointingUp ? 13.0 : 0
        let dheight = self.frame.height - self.arrowView.frame.height + 0.5

        self.containerView.frame = CGRect(x: 0.0, y: dy, width: self.frame.width, height: dheight)
        self.arrowView.frame.origin.x = round(self.arrowPoint.x - self.arrowView.frame.width / 2)
        self.arrowView.frame.origin.y = pointingUp ? 0 : self.containerView.frame.height
        self.arrowView.transform = pointingUp ? CGAffineTransformMakeRotation(CGFloat(M_PI)) : CGAffineTransformIdentity
    }

    // MARK: - Private functions

    private func sharedInit() {
        dispatch_once(&BubbleBackgroundView.initOnceToken) {
            let calloutArrow = SMCalloutBackgroundView.performSelector("embeddedImageNamed:", withObject: "CalloutArrow")
            guard let arrowImage = calloutArrow?.takeUnretainedValue() as? UIImage else {
                return assertionFailure("arrow couldn't be created")
            }

            kCalloutArrowImage = arrowImage.image(withColor: kBackgroundColor)
        }

        self.arrowView.frame = CGRect(origin: CGPointZero, size: kCalloutArrowImage?.size ?? CGSizeZero)
        self.arrowImageView = UIImageView(image: kCalloutArrowImage)

        self.containerView.backgroundColor = kBackgroundColor
        self.containerView.layer.cornerRadius = 8

        self.anchorHeight = 13
        self.anchorMargin = 27

        self.addSubview(self.containerView)
        self.addSubview(self.arrowView)
        self.arrowView.addSubview(self.arrowImageView)

        self.layoutSubviews()
    }
}

// MARK: - Private UIImage extension

private extension UIImage {

    private func image(withColor color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0)
        defer { UIGraphicsEndImageContext() }

        let imageRect = CGRect(origin: CGPointZero, size: self.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextTranslateCTM(context, 0, self.size.height)
        CGContextScaleCTM(context, 1, -1)
        CGContextClipToMask(context, imageRect, self.CGImage)
        color.setFill()
        CGContextFillRect(context, imageRect)

        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
