//
//  SignUpViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 8/28/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.navigationController?.navigationBarHidden = false
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0/255, green: 255/255, blue: 234/255, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
        self.navigationItem.title = "Sign up"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    


}
