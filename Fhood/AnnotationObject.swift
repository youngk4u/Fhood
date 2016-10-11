//
//  AnnotationObject.swift
//  CustomPin
//
//  Created by Telescopia on 8/13/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
//

import Foundation
import MapKit

final class AnnotationObject: NSObject, MKAnnotation  {

    //MKAnnotation ->>> Protocol
    let objectID: String?
    let title: String?
    let coordinate: CLLocationCoordinate2D
    let subtitle: String?
    //->>>MKAnnotation
    let countReviews: Int
    let image: UIImage
    let price: Double
//    let pickup: Bool
    let open: Bool
    let imageRatingActive: UIImage
    let distance: Double

    var reviewsDescription: String {
        return "\(countReviews) Reviews"
    }

    init(objectID: String, title: String, subtitle: String,coordinate: CLLocationCoordinate2D, countReviews: Int, image: UIImage, price: Double, open: Bool, imageRating: UIImage, distanceX: Double) {
        
        self.objectID = objectID
        self.title = title
        self.coordinate = coordinate
        self.subtitle = subtitle
        self.countReviews = countReviews
        self.image = image
        self.price = price
        self.open = open
        self.imageRatingActive = imageRating
        self.distance = distanceX

        super.init()
    }
}
