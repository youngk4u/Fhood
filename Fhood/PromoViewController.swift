//
//  PromoViewController.swift
//  Fhood
//
//  Created by YOUNG on 11/16/15.
//  Copyright © 2015 YOUNG&YOUM. All rights reserved.
//

import UIKit

final class PromoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nav = self.navigationController?.navigationBar
        
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor(),NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 20)!]

        self.title = "Promotions"
       
    }

    @IBAction func closePromo(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
