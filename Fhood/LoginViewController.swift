//
//  LoginViewController.swift
//  Fhood
//
//  Created by YOUNG on 8/29/15.
//  Copyright © 2015 YOUNG&YOUM. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.navigationController?.navigationBarHidden = false
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0/255, green: 255/255, blue: 234/255, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
        self.navigationItem.title = "Log in"
    
    }
}
