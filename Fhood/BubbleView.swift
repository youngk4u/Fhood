//
//  BubbleView.swift
//  CustomPin
//
//  Created by MIKALAI BUSLAYEU on 8/13/15.
//  Copyright (c) 2015 MI. All rights reserved.
//

import UIKit

final class BubbleView: UIView {
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var typeLabel: UILabel!
    @IBOutlet private var spoonView: UIImageView!
    @IBOutlet private var reviewLabel: UILabel!
    @IBOutlet private var pickupLabel: UILabel!
    @IBOutlet private var priceLabel: UILabel!
    @IBOutlet private var openLabel: UILabel!
    @IBOutlet private var closedLabel: UILabel!

    var annotation: AnnotationObject? {
        didSet {
            guard let annotation = self.annotation else { return }
            self.reviewLabel.text = annotation.reviewsDescription
            self.typeLabel.text = annotation.subtitle
            self.nameLabel.text = annotation.title
            self.imageView.image = annotation.image
            self.openLabel.hidden = annotation.open == false
            self.closedLabel.hidden = annotation.closed == false
            self.priceLabel.text = String(format: "$%.2f", annotation.price)
            self.spoonView.image = annotation.imageRatingActive
        }
    }

    class func nibView(withAnnotation annotation: AnnotationObject?) -> BubbleView {
        let view = NSBundle.mainBundle().loadNibNamed("BubbleView", owner: self, options: nil)[0]
        let bubbleView = view as? BubbleView ?? BubbleView()
        bubbleView.annotation = annotation
        return bubbleView
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 8
    }
}
