//
//  SignUpViewController.swift
//  Fhood
//
//  Created by YOUNG on 11/25/15.
//  Copyright © 2015 YOUNG&YOUM. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UIApplicationDelegate {
    
    var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func toFhooder(sender: AnyObject) {
        
        // Since we are not using any default XIB we have to create the window.
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        Router.route(animated: false)
        self.window?.makeKeyAndVisible()
        
        let storyboard = UIStoryboard(name: "Fhooder", bundle: nil)
        self.window?.rootViewController = storyboard.instantiateInitialViewController()
        
    }

}
