//
//  User.swift
//  Fhood
//
//  Created by Matias Pequeno on 8/30/15.
//  Copyright © 2015 YOUNG&YOUM. All rights reserved.
//

import Foundation
import Parse

struct User {
    var parseUser: PFUser? = nil

    var name: String? = nil
    var fhooderFirstName: String? = nil
    var fhooderLastName: String? = nil
    var rating: Double? = nil
    var ratingInString: String? = nil
    var reviews: Int? = nil
    var foodType: [String]? = nil
    var address: String? = nil
    var fhooderLatitude: Double? = nil
    var fhooderLongitude: Double? = nil
    var distance: Double? = nil
    var pickup: Bool? = nil
    var eatin: Bool? = nil
    var delivery: Bool? = nil
    var phoneNum: String? = nil
    var isOpen: Bool? = nil
    var isClosed: Bool? = nil
    var timeOpenHour: Int? = nil
    var timeOpenMinute: Int? = nil
    var timeOpenAmpm: String? = nil
    var timeCloseHour: Int? = nil
    var timeCloseMinute: Int? = nil
    var timeCloseAmpm: String? = nil
    var timeReserveHour: Int? = nil
    var timeReserveMinute: Int? = nil
    var timeReserveAmpm: String? = nil
    var orderTimeHour: Int? = nil
    var orderTimeMinute: Int? = nil
    var orderTimeAmpm: String? = nil
    var orderTime: String? = nil

    var itemNames: [String]? = nil
    var itemPrices: [Double]? = nil
    var itemCount: [Int]? = nil
    var totalItemPrice: Double? = nil
    var itemIngredients: [String]? = nil

    var fhooderFace: String? = nil
    var fhooderPic: String? = nil

    init(parameters: [String: AnyObject]) {

    }
}


