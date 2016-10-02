//
//  Fhoodie.swift
//  Fhood
//
//  Created by Young-hu Kim on 10/27/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
//

import Foundation

struct Fhoodie {
    
    static var fhoodieID: String?
    static var fhoodiePic: String?
    static var fhoodiePhoto: UIImage?
    
    static var fhoodieFirstName: String?
    static var fhoodieLastName: String?
    static var fhoodieRating: Double?
    static var fhoodieRatingInString: String?
    static var fhoodieReviews: Int?
    static var fhoodieAddress: String?
    static var fhoodieLatitude: Double?
    static var fhoodieLongitude: Double?
    static var fhoodieDistance: Double?

    static var fhoodiePhoneNum: String?
    
    static var selectedShopName: String?
    static var selectedIndex: Int?
    static var selectedItemNames: [String]?
    static var selectedItemPrices: [Double]?
    static var selectedItemCount: [Int]? = [0, 0, 0, 0, 0, 0, 0]
    static var selectedItemObjectId: [String]?
    static var fhoodieOrderID: String?
    static var isAnythingSelected: Bool?
    static var selectedTotalItemPrice: Double?
    static var totalDue: Double?
    
}
