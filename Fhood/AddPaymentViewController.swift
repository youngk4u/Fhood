//
//  AddPaymentViewController.swift
//  Fhood
//
//  Created by YOUNG on 10/29/16.
//  Copyright © 2016 Fhood LLC. All rights reserved.
//

import UIKit
import Parse

final class AddPaymentViewController: UIViewController {
    
    @IBOutlet weak var savePaymentButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let nav = self.navigationController?.navigationBar
        
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor(),NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 20)!]
        self.title = "Add Payment"
        
        self.savePaymentButton.enabled = false 
    
    
    }
    @IBAction func savePaymentCard(sender: AnyObject) {
        

    }
    
    
    @IBAction func cancelButton(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
