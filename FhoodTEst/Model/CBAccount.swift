//
//  CBAccount.swift
//  FhoodTEst
//
//  Created by admin on 12/14/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

struct Constants {
    struct Vendor {
        static let CoinbaseClientID = "750b1bce9d999bd4cf557ffc63672ac4b459b8955361112af373f6d44de4485f"
        static let CoinbaseClientSecretID = "4363c9d9c0d68edb31ea078d0a23459752a79749b1d2c89516f1bf9d8e3d10dd"
        static let CoinbaseClientDevToken = "fc7cd91c4034a7847b6951d06bf1ba622896e755b088c77b4f0396a188ba9e69"
        static let CoinbaseRedirectSchema = "com.fhood.coinbase-oauth"
        static let CoinbaseRedirectUri = "com.fhood.coinbase-oauth://coinbase-oauth"
        static let CoinbaseApiKey    = "J5AUYanhoXzdUJD6"
        static let CoinbaseApiSecretKey    = "X2Qig65SLfBf3bNLYc2U4NlEAAlbg6WC"
        static let CoinbaseApiVersion      = "2017-12-13"
    }
}


struct CBBalance {
    var amount: String
    var currency: String
}

class CBCurrency: NSObject {
    var code: String?
    var name: String?
    var hexColor: String?
    var exponent: Int = 0
    var type: String?
    var addressRegax: String?
    
    init(_ dictionary: [String: Any?]) {
        self.code = dictionary["code"] as? String
        self.name = dictionary["name"] as? String
        self.hexColor = dictionary["color"] as? String
        self.exponent = dictionary["exponent"] as? Int ?? 0
        self.type = dictionary["type"] as? String
        self.addressRegax = dictionary["address_regex"] as? String
    }
}

class CBAccount: NSObject {
    var id          : String?
    var name        : String?
    var isPrimary   : Bool = false
    var type        : String?
    var balance     : CBBalance?
    var currency    : CBCurrency?
    
    init(_ dictionary: [String: Any?]) {
        self.id = dictionary["id"] as? String
        self.name = dictionary["name"] as? String
        self.isPrimary = dictionary["primary"] as? Bool ?? false
        self.type = dictionary["type"] as? String
        
        if let dict = dictionary["balance"] as? [String: Any] {
            self.balance = CBBalance(amount: dict["amount"] as! String, currency: dict["currency"] as! String)
        }
        
        if let dict = dictionary["currency"] as? [String: Any] {
            self.currency = CBCurrency(dict)
        }
    }
}
