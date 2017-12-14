//
//  AppManager.swift
//  FhoodTEst
//
//  Created by admin on 12/14/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Alamofire

class AppManager: NSObject {
    
    static let shared = AppManager()
    
    var token: String!
    var accounts: [CBAccount]!
    
    override init() {
        super.init()
    }
    
    class func startOAuthAuthentication(_ scope: String, meta: [String: Any]?) {
        
        var path = "/oauth/authorize?response_type=code&client_id=" + Constants.Vendor.CoinbaseClientID
        path = path + "&scope=" + OAuthUtil.urlEncodedString(from: scope)
        path = path + "&redirect_uri=" + OAuthUtil.urlEncodedString(from: Constants.Vendor.CoinbaseRedirectUri)
        
        if let meta = meta {
            for (key, value) in meta {
                path = path + "&meta[\(key)]=\(value as? String ?? "")"
            }
        }
        
        let base = URL(string: path, relativeTo: URL(string: "https://www.coinbase.com/"))
        let webUrl = URL(string: path, relativeTo: base)?.absoluteURL
        
        if UIApplication.shared.canOpenURL(webUrl!) {
            UIApplication.shared.open(webUrl!, options: [:], completionHandler: nil)
        }
    }
    
    class func getAuthTokenFrom(_ params: [String: Any]) {
        guard let code = params["code"] as? String else {
            return
        }
        
        let parameter = [
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": Constants.Vendor.CoinbaseRedirectUri,
            "client_id": Constants.Vendor.CoinbaseClientID,
            "client_secret": Constants.Vendor.CoinbaseClientSecretID
        ]
        
        OAuthUtil.doOAuthPost(toPath: "token", withParams: parameter) { (response, error) in
            print(response)
            if let error = error {
                print(error.localizedDescription)
            } else if let response = response as? [String: Any]{
                 AppManager.shared.token = response["access_token"] as! String
            }
        }
    }
    
    class func getAccounts(_ completionBlock: @escaping (([CBAccount]) -> Void)) {
        let endpoint = "https://api.coinbase.com/v2/accounts"
        let headers = [
            "Authorization" : "Bearer \(AppManager.shared.token ?? "")",
            "CB-VERSION"    : Constants.Vendor.CoinbaseApiVersion
        ]
        
        Alamofire.request(endpoint, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            print(response)
            switch response.result {
            case .success(let data):
                
                var cbAccounts = [CBAccount]()
                if let data = data as? [String: Any], let accounts = data["data"] as? [[String: Any]] {
                    for account in accounts {
                        let cbAccount = CBAccount(account)
                        cbAccounts.append(cbAccount)
                    }
                }
                
                completionBlock(cbAccounts)
                
                break
            case .failure(let error):
                print(error.localizedDescription)
                completionBlock([CBAccount]())
                break
            }
            
        }
    }
    
    class func sendMoney(_ account: String, fAToken: String?, isConfirm: Bool, completionBlock: @escaping ((Error?) -> Void)) {
        let endpoint = "https://api.coinbase.com/v2/accounts/\(account)/transactions"
        var headers = [
            "Authorization" : "Bearer \(AppManager.shared.token ?? "")",
            "CB-VERSION"    : Constants.Vendor.CoinbaseApiVersion,
            "Content-Type" : "application/json"
        ]
        
        if let faToken = fAToken {
            headers["CB-2FA-Token"] = faToken
        }
        
        let params = [
            "type": "send",
            "to": "youngk4u@gmail.com",
            "amount": "0.00001",
            "currency": "BTC"
        ]
        
        Alamofire.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print(response)
            switch response.result {
            case .success(let data):
                
                print(data)
                completionBlock(nil)
                
                break
            case .failure(let error):
                print(error.localizedDescription)
                completionBlock(error)
                break
            }
            
        }
    }
}
