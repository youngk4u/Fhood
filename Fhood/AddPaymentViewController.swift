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
        
        nav?.titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.black,NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): UIFont(name: "HelveticaNeue-Light", size: 20)!]
        self.title = "Add Payment"
        
        self.savePaymentButton.isEnabled = false 
    
    
    }
    @IBAction func savePaymentCard(_ sender: AnyObject) {
        

    }
    
    
    @IBAction func cancelButton(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
    }
}
