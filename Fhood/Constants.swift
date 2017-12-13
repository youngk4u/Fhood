//
//  Constants.swift
//  Fhood
//
//  Created by Matias Pequeno on 8/29/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
//

import Foundation

struct Constants {

    struct Vendor {
        static let ParseApplicationID = "Ji19GFajRMo6ruqU64dLdKhjdJLJNeFHN0t7AW1y"
        static let ParseClientKey = "vCP3IBibukwFMF3LdoxyKim7uw1hglzZhWDsQ4BO"
        static let ParseServerURL = "http://fhood.herokuapp.com/parse"
        
        static let OneSignalID = "37c577a0-3222-4a59-9966-f55eb1464e7b"
        
        static let FacebookAppID = "515338641949786"
        static let FacebookAppSecret = "0d116ebc6f08aa000a090a43405e607f"
        static let FacebookPermissions = ["email", "user_friends"]
        
        static let CoinbaseClientID = "750b1bce9d999bd4cf557ffc63672ac4b459b8955361112af373f6d44de4485f"
        static let CoinbaseClientSecretID = "4363c9d9c0d68edb31ea078d0a23459752a79749b1d2c89516f1bf9d8e3d10dd"
        static let CoinbaseRedirectSchema = "com.fhood.coinbase-oauth"
        static let CoinbaseRedirectUri = "com.fhood.coinbase-oauth://coinbase-oauth"
        static let CoinbaseApiKey    = "J5AUYanhoXzdUJD6"
        static let CoinbaseApiSecretKey    = "X2Qig65SLfBf3bNLYc2U4NlEAAlbg6WC"
    }
}
