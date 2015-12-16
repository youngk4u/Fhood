//
//  PromoViewController.swift
//  Fhood
//
//  Created by YOUNG on 11/16/15.
//  Copyright © 2015 YOUNG&YOUM. All rights reserved.
//

import UIKit

final class PromoViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nav = self.navigationController?.navigationBar
        
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor(),NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 20)!]

        self.title = "Promotions"
       
        self.textField.delegate = self
        
    }

    @IBAction func closePromo(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
