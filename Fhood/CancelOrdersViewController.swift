//
//  CancelOrdersViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 10/21/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
//

import UIKit

class CancelOrdersViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.85)
        
        
        
    }
    
    @IBAction func dontCancelButton(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
