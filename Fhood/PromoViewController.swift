//
//  PromoViewController.swift
//  Fhood
//
//  Created by YOUNG on 11/16/15.
//  Copyright © 2015 YOUNG&YOUM. All rights reserved.
//

import UIKit

class PromoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Promotions"
       
    }

    @IBAction func closePromo(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
