//
//  TabBarController.swift
//  Fhood
//
//  Created by Young-hu Kim on 6/3/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
//

import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set Tab Bar item and text color
        UITabBar.appearance().barTintColor = UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1.0)
        UITabBar.appearance().tintColor = UIColor(red: 0/255, green: 255/255, blue: 234/255, alpha: 1.0)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.white], for:UIControlState())
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:UIColor(red: 0/255, green: 255/255, blue: 234/255, alpha: 1.0)], for:.selected)
        
        UINavigationBar.appearance().tintColor = UIColor.black
        UINavigationBar.appearance().barTintColor = UIColor(red: 0/255, green: 255/255, blue: 234/255, alpha: 1)
        UINavigationBar.appearance().backgroundColor = UIColor(red: 0/255, green: 255/255, blue: 234/255, alpha: 1)
    }
}
