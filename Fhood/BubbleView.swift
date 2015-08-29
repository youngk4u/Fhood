//
//  BubbleView.swift
//  CustomPin
//
//  Created by MIKALAI BUSLAYEU on 8/13/15.
//  Copyright (c) 2015 MI. All rights reserved.
//

import UIKit
import MapKit

final class BubbleView: MKAnnotationView {

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
    
    var annotationObj: AnnotationObject?

   
    func SetUpView(annotation: AnnotationObject)
    {
        self.BubbleView.layer.cornerRadius = 9
        ReviewLabel.text = annotation.reviewsDescription
        TypeLabel.text = annotation.subtitle
        NameLabel.text = annotation.title
        ImageLabel.image = annotation.image
        OpenLabel.hidden = !annotation.open
        ClosedLabel.hidden = !annotation.closed
        PriceLabel.text = "$\(annotation.price.description)0"
        SpoonLabel.image = annotation.imageRatingActive
    }

        
}
