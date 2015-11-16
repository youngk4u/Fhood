//
//  ProfileViewController.swift
//  Fhood
//
//  Created by YOUNG on 11/13/15.
//  Copyright © 2015 YOUNG&YOUM. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nav = self.navigationController?.navigationBar
        
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor(),NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 20)!]
        
        self.title = "Profile"
        
    }

    @IBAction func closeProfile(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
