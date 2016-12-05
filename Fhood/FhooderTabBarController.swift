//
//  FhooderTabBarController.swift
//  Fhood
//
//  Created by Young-hu Kim on 8/30/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
//

import UIKit
import Parse

final class FhooderTabBarController: UITabBarController {
    
    var badgeNum : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FhooderTabBarController.badgeRefresh(_:)), name: "postBadgeRefresh", object: nil)
        
        NSNotificationCenter.defaultCenter().postNotificationName("postBadgeRefresh", object: nil)
        
        // Set Tab Bar item and text color
        UITabBar.appearance().barTintColor = UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1.0)
        UITabBar.appearance().tintColor = UIColor(red: 0/255, green: 255/255, blue: 234/255, alpha: 1.0)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.whiteColor()], forState:.Normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:UIColor(red: 0/255, green: 255/255, blue: 234/255, alpha: 1.0)], forState:.Selected)
        
        UINavigationBar.appearance().tintColor = UIColor.blackColor()
        UINavigationBar.appearance().barTintColor = UIColor(red: 0/255, green: 255/255, blue: 234/255, alpha: 1)
        UINavigationBar.appearance().backgroundColor = UIColor(red: 0/255, green: 255/255, blue: 234/255, alpha: 1)
        
    }
    
    func badgeRefresh(Notification: NSNotification) {
        self.badgeNum = Fhooder.orderQuantity!

        if badgeNum > 0  {
            self.tabBar.items![1].badgeValue = String(badgeNum!)
        }
        else if badgeNum <= 0 {
            self.tabBar.items![1].badgeValue = nil
        }
    }
}
