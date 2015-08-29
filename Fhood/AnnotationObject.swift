//
//  AnnotationObject.swift
//  CustomPin
//
//  Created by Telescopia on 8/13/15.
//  Copyright (c) 2015 MI. All rights reserved.
//

import Foundation
import MapKit

final class AnnotationObject: NSObject, MKAnnotation  {
   
    //MKAnnotation ->>> Protocol
    let title: String?
    let coordinate: CLLocationCoordinate2D
    let subtitle: String?
    //->>>MKAnnotation
    let countReviews: Int
    let image: UIImage
    let price: Double
//    let pickup: Bool
    let open: Bool
    let closed: Bool
    let imageRatingActive: UIImage
    var reviewsDescription: String {
        return "\(countReviews) Reviews"
    }
    
    
    init(title: String, subtitle: String,coordinate: CLLocationCoordinate2D, countReviews: Int, image: UIImage, price: Double, open: Bool, closed: Bool, imageRating: UIImage) {
            
        self.title = title
        self.coordinate = coordinate
        self.subtitle = subtitle
        self.countReviews = countReviews
        self.image = image
        self.price = price
        self.open = open
        self.closed = closed
        self.imageRatingActive = imageRating
        super.init()
    }
    
    
}