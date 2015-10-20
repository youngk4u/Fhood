//
//  OrdersDetailViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 10/16/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
//

import UIKit

class OrdersDetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Timer
        self.navigationController?.navigationBar.topItem?.title = "Order #"
        let attributes = [
            NSForegroundColorAttributeName: UIColor.blackColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 25)!
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        
        self.navigationItem.title = "00:07:52"
        
    }

}
