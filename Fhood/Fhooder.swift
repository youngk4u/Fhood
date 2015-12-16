//
//  Fhooder.swift
//  Fhood
//
//  Created by Young-hu Kim on 7/1/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
//

import Foundation

struct Fhooder {

    static var shopName: String? = nil
    static var fhooderFirstName: String? = nil
    static var fhooderLastName: String? = nil
    static var rating: Double? = nil
    static var ratingInString: String? = nil
    static var reviews: Int? = nil
    static var foodTypeOne: String? = nil
    static var foodTypeTwo: String? = nil
    static var foodTypeThree: String? = nil
    static var address: String? = nil
    static var fhooderLatitude: Double? = nil
    static var fhooderLongitude: Double? = nil
    static var distance: Double? = nil
    static var servingMethod: [Bool]? = nil
    static var pickup: Bool? = nil
    static var eatin: Bool? = nil
    static var delivery: Bool? = nil
    static var phoneNum: String? = nil
    static var isOpen: Bool? = nil
    static var isClosed: Bool? = nil
    static var timeOpenHour: Int? = nil
    static var timeOpenMinute: Int? = nil
    static var timeOpenAmpm: String? = nil
    static var timeCloseHour: Int? = nil
    static var timeCloseMinute: Int? = nil
    static var timeCloseAmpm: String? = nil
    static var timeReserveHour: Int? = nil
    static var timeReserveMinute: Int? = nil
    static var timeReserveAmpm: String? = nil
    static var orderTimeHour: Int? = nil
    static var orderTimeMinute: Int? = nil
    static var orderTimeAmpm: String? = nil
    static var orderTime: String? = nil

    static var itemNames: [String]? = nil
    static var itemPics: [UIImage]? = nil
    static var itemPrices: [Double]? = nil
    static var itemCount: [Int]? = nil
    static var totalItemPrice: Double? = nil
    // "organic", "vegan", "glutenfree", "nutsfree", "soyfree", "msgfree", "dairyfree", "lowsodium"
    static var itemPrefernce: [[Int]]? = nil
    static var itemPreferences: [[Bool]]? = nil
    static var itemDescription: [String]? = []
    static var descriptionText: String? = ""
    static var itemIngredients: [String]? = []
    static var ingredientsText: String? = ""
    static var itemCuisineType: String? = nil
    
    static var itemPic: UIImage?
    
    static var itemIndex: Int? = 0
    static var dailyQuantity: [Int]? = nil
    static var maxOrderLimit: [Int]? = nil
    static var timeInterval: [Int]? = nil
    

    static var fhooderFace: String? = nil
    static var fhooderPic: String? = nil
    static var fhooderPicture: UIImage? = nil
    static var fhooderAboutMe: String? = nil
    
    static var fhooderSignedIn: Bool = false
}
