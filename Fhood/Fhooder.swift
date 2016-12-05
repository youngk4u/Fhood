//
//  Fhooder.swift
//  Fhood
//
//  Created by Young-hu Kim on 7/1/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
//

import Foundation

struct Fhooder {
    
    static var objectID: String? = ""
    static var shopName: String? = ""
    static var fhooderFirstName: String? = ""
    static var fhooderLastName: String? = ""
    static var rating: Double? = 0
    static var ratingInString: String? = ""
    static var reviews: Int? = 0
    static var foodTypeOne: String? = ""
    static var foodTypeTwo: String? = ""
    static var foodTypeThree: String? = ""
    static var address: String? = ""
    static var fhooderLatitude: Double? = 0
    static var fhooderLongitude: Double? = 0
    static var distance: Double? = 0
    static var pickup: Bool? = false
    static var delivery: Bool? = false
    static var eatin: Bool? = false
    static var phoneNum: String? = ""
    static var isOpen: Bool? = false
    static var isClosed: Bool? = true
    static var timeOpenHour: Int? = 0
    static var timeOpenMinute: Int? = 0
    static var timeOpenAmpm: String? = ""
    static var timeCloseHour: Int? = 0
    static var timeCloseMinute: Int? = 0
    static var timeCloseAmpm: String? = ""
    static var timeReserveHour: Int? = 0
    static var timeReserveMinute: Int? = 0
    static var timeReserveAmpm: String? = ""
    static var orderTimeHour: Int? = 0
    static var orderTimeMinute: Int? = 0
    static var orderTimeAmpm: String? = ""
    static var orderTime: String? = ""
    static var orderQuantity: Int? = 0

    static var itemNames: [String]? = []
    static var itemPrice: Double? = 0
    static var itemID: [String]? = []
    static var itemPics: [UIImage]? = []
    static var itemPrices: [Double]? = []
    static var totalItemPrice: Double? = 0
    // "organic", "vegan", "glutenfree", "nutsfree", "soyfree", "msgfree", "dairyfree", "lowsodium"
    static var itemPrefernce: [[Int]]? = [[]]
    static var itemPreferences: [[Bool]]? = [[]]
    static var itemDescription: [String]? = []
    static var descriptionText: String? = ""
    static var itemIngredients: [String]? = []
    static var ingredientsText: String? = ""
    static var itemCuisineType: String? = ""
    
    static var itemPic: UIImage? = nil
    
    static var itemIndex: Int? = 0
    static var dailyQuantity: [Int]? = []
    static var maxOrderLimit: [Int]? = []
    static var timeInterval: [Int]? = []
    

    static var fhooderFace: String? = ""
    static var fhooderPic: String? = ""
    static var fhooderPicture: UIImage? = nil
    static var fhooderAboutMe: String? = ""
    
    static var fhooderSignedIn: Bool = false
}
