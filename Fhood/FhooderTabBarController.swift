//
//  FhooderTabBarController.swift
//  Fhood
//
//  Created by Young-hu Kim on 8/30/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
//

import UIKit

final class FhooderTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Tab Bar item and text color
        UITabBar.appearance().barTintColor = UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1.0)
        UITabBar.appearance().tintColor = UIColor(red: 0/255, green: 255/255, blue: 234/255, alpha: 1.0)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.whiteColor()], forState:.Normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:UIColor(red: 0/255, green: 255/255, blue: 234/255, alpha: 1.0)], forState:.Selected)
        
        UINavigationBar.appearance().tintColor = UIColor.blackColor()
        UINavigationBar.appearance().barTintColor = UIColor(red: 0/255, green: 255/255, blue: 234/255, alpha: 1)
        UINavigationBar.appearance().backgroundColor = UIColor(red: 0/255, green: 255/255, blue: 234/255, alpha: 1)
    }
}
