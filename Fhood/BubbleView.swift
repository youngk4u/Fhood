//
//  BubbleView.swift
//  CustomPin
//
//  Created by MIKALAI BUSLAYEU on 8/13/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
//

import UIKit

final class BubbleView: UIView {
    @IBOutlet fileprivate var nameLabel: UILabel!
    @IBOutlet fileprivate var imageView: UIImageView!
    @IBOutlet fileprivate var typeLabel: UILabel!
    @IBOutlet fileprivate var spoonView: UIImageView!
    @IBOutlet fileprivate var reviewLabel: UILabel!
    @IBOutlet fileprivate var pickupLabel: UILabel!
    @IBOutlet fileprivate var deliveryLabel: UILabel!
    @IBOutlet fileprivate var eatinLabel: UILabel!
    @IBOutlet fileprivate var priceLabel: UILabel!
    @IBOutlet fileprivate var openLabel: UILabel!

    var annotation: AnnotationObject? {
        didSet {
            guard let annotation = self.annotation else { return }
            self.reviewLabel.text = annotation.reviewsDescription
            self.typeLabel.text = annotation.subtitle
            self.nameLabel.text = annotation.title
            self.imageView.image = annotation.image
            self.pickupLabel.isHidden = !annotation.pickup
            self.deliveryLabel.isHidden = !annotation.deliver
            self.eatinLabel.isHidden = !annotation.eatin
            
            let image = UIImageView(image: self.imageView.image)
            self.imageView.image = nil
            image.frame = CGRect(x: 0, y: 0, width: 58, height: 58)
            image.layer.masksToBounds = false
            image.layer.cornerRadius = 13
            image.layer.cornerRadius = image.frame.size.height/2
            image.clipsToBounds = true
            self.imageView.addSubview(image)
            
            if annotation.open == true {
                self.openLabel.text = "Open"
                self.openLabel.textColor = UIColor.green
            }
            else {
                self.openLabel.text = "Closed"
                self.openLabel.textColor = UIColor.red
            }
            
            self.priceLabel.text = String(format: "$%.2f", annotation.price)
            self.spoonView.image = annotation.imageRatingActive
        }
    }

    class func nibView(withAnnotation annotation: AnnotationObject?) -> BubbleView {
        let view = Bundle.main.loadNibNamed("BubbleView", owner: self, options: nil)![0]
        let bubbleView = view as? BubbleView ?? BubbleView()
        bubbleView.annotation = annotation
        return bubbleView
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 8
        self.backgroundColor = UIColor.clear
    }
}
