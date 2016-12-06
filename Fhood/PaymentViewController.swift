//
//  PaymentViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 6/3/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
//

import UIKit

final class PaymentViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nav = self.navigationController?.navigationBar
        
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black,NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 20)!]
        self.title = "Payment"
        
    
    }
    
    @IBAction func closePayment(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    

    
}
