//
//  BubbleBackgroundView.swift
//  Fhood
//
//  Created by Matias Pequeno on 9/13/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
//

import UIKit
import SMCalloutView


private var kBackgroundColor = UIColor(white: 0, alpha: 0.9)
private var kCalloutArrowImage: UIImage? = nil

final class BubbleBackgroundView: SMCalloutBackgroundView {
    private static var __once: () = {
            let calloutArrow = SMCalloutBackgroundView.perform(Selector(("embeddedImageNamed:")), with: "CalloutArrow")
            guard let arrowImage = calloutArrow?.takeUnretainedValue() as? UIImage else {
                return assertionFailure("arrow couldn't be created")
            }

            kCalloutArrowImage = arrowImage.image(withColor: kBackgroundColor)
        }()
    fileprivate static var initOnceToken: Int = 0

    fileprivate let containerView = UIView()
    fileprivate let arrowView = UIView()
    fileprivate var arrowImageView = UIImageView()

    override var arrowPoint: CGPoint {
        didSet {
            self.setNeedsLayout()
        }
    }

    override var contentMask: CALayer {
        get {
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
            self.layer.render(in: UIGraphicsGetCurrentContext()!)
            let maskImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            let layer = CALayer()
            layer.frame = self.bounds
            layer.contents = maskImage!.cgImage
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
        self.arrowView.transform = pointingUp ? CGAffineTransform(rotationAngle: CGFloat(M_PI)) : CGAffineTransform.identity
    }

    // MARK: - Private functions

    fileprivate func sharedInit() {
        _ = BubbleBackgroundView.__once

        self.arrowView.frame = CGRect(origin: CGPoint.zero, size: kCalloutArrowImage?.size ?? CGSize.zero)
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

    func image(withColor color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0)
        defer { UIGraphicsEndImageContext() }

        let imageRect = CGRect(origin: CGPoint.zero, size: self.size)
        let context = UIGraphicsGetCurrentContext()
        context!.translateBy(x: 0, y: self.size.height)
        context!.scaleBy(x: 1, y: -1)
        context!.clip(to: imageRect, mask: self.cgImage!)
        color.setFill()
        context!.fill(imageRect)

        return UIGraphicsGetImageFromCurrentImageContext()!
    }
}
