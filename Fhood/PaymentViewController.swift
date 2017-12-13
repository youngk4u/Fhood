//
//  PaymentViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 6/3/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
//

import UIKit
import coinbase_official

final class PaymentViewController: UIViewController {
    
    @IBOutlet weak var coinbaseLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nav = self.navigationController?.navigationBar
        
        nav?.titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.black,NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): UIFont(name: "HelveticaNeue-Light", size: 20)!]
        self.title = "Payment"
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let _ = appDelegate.coinbaseClient {
            coinbaseLabel.text = "Available"
        } else {
            coinbaseLabel.text = "Not Connected"
        }
    }
    
    @IBAction func closePayment(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func authorizeCoinbase(_ sender: Any) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let _ = appDelegate.coinbaseClient {
            print("already authorized")
        } else {
            CoinbaseOAuth.startAuthentication(withClientId: Constants.Vendor.CoinbaseClientID, scope: "user balance", redirectUri: Constants.Vendor.CoinbaseRedirectUri, meta: nil)
        }
    }
    
}
