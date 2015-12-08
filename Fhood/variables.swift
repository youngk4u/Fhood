//
//  variables.swift
//  Fhood
//
//  Created by Young-hu Kim on 7/1/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
//

import Foundation

struct variables {

    static var name: String?
    static var fhooderFirstName: String?
    static var fhooderLastName: String?
    static var rating: Double?
    static var ratingInString: String?
    static var reviews: Int?
    static var foodType: [String]?
    static var address: String?
    static var fhooderLatitude: Double?
    static var fhooderLongitude: Double?
    static var distance: Double?
    static var pickup: Bool?
    static var eatin: Bool?
    static var delivery: Bool?
    static var phoneNum: String?
    static var isOpen: Bool?
    static var isClosed: Bool?
    static var timeOpenHour: Int?
    static var timeOpenMinute: Int?
    static var timeOpenAmpm: String?
    static var timeCloseHour: Int?
    static var timeCloseMinute: Int?
    static var timeCloseAmpm: String?
    static var timeReserveHour: Int?
    static var timeReserveMinute: Int?
    static var timeReserveAmpm: String?
    static var orderTimeHour: Int?
    static var orderTimeMinute: Int?
    static var orderTimeAmpm: String?
    static var orderTime: String?

    static var itemNames: [String]?
    static var itemPrices: [Double]?
    static var itemCount: [Int]?
    static var totalItemPrice: Double?
    static var itemPrefernce: [[Int]]?
    static var itemDescription: [String]?
    static var itemIngredients: [String]?
    
    static var itemIndex: Int?
    static var dailyQuantity: [Int]?
    static var maxOrderLimit: [Int]?
    static var timeInterval: [Int]?
    

    static var fhooderFace: String?
    static var fhooderPic: String?
    static var fhooderAboutMe: String?
    
    static var fhooderSignedIn: Bool = false
}
