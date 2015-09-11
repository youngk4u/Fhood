//
//  BubbleView.swift
//  CustomPin
//
//  Created by MIKALAI BUSLAYEU on 8/13/15.
//  Copyright (c) 2015 MI. All rights reserved.
//

import UIKit
import MapKit

final class BubbleView: UIView {
    @IBOutlet weak var BubbleView: UIView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var ImageLabel: UIImageView!
    @IBOutlet weak var TypeLabel: UILabel!
    @IBOutlet weak var SpoonLabel: UIImageView!
    @IBOutlet weak var ReviewLabel: UILabel!
    @IBOutlet weak var PickupLabel: UILabel!
    @IBOutlet weak var PriceLabel: UILabel!
    @IBOutlet weak var OpenLabel: UILabel!
    @IBOutlet weak var ClosedLabel: UILabel!

    var annotation: AnnotationObject? {
        didSet {
            guard let annotation = self.annotation else { return }
            self.ReviewLabel.text = annotation.reviewsDescription
            self.TypeLabel.text = annotation.subtitle
            self.NameLabel.text = annotation.title
            self.ImageLabel.image = annotation.image
            self.OpenLabel.hidden = annotation.open == false
            self.ClosedLabel.hidden = annotation.closed == false
            self.PriceLabel.text = String(format: "$%.2f", annotation.price)
            self.SpoonLabel.image = annotation.imageRatingActive
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.BubbleView.layer.cornerRadius = 9
        self.layer.cornerRadius = 10
    }
}
