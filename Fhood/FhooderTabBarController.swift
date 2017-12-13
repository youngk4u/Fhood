//
//  FhooderTabBarController.swift
//  Fhood
//
//  Created by Young-hu Kim on 8/30/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
//

import UIKit
import Parse
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


final class FhooderTabBarController: UITabBarController {
    
    var badgeNum : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(FhooderTabBarController.badgeRefresh(_:)), name: NSNotification.Name(rawValue: "postBadgeRefresh"), object: nil)
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "postBadgeRefresh"), object: nil)
        
        // Set Tab Bar item and text color
        UITabBar.appearance().barTintColor = UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1.0)
        UITabBar.appearance().tintColor = UIColor(red: 0/255, green: 255/255, blue: 234/255, alpha: 1.0)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor.white], for:UIControlState())
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor(red: 0/255, green: 255/255, blue: 234/255, alpha: 1.0)], for:.selected)
        
        UINavigationBar.appearance().tintColor = UIColor.black
        UINavigationBar.appearance().barTintColor = UIColor(red: 0/255, green: 255/255, blue: 234/255, alpha: 1)
        UINavigationBar.appearance().backgroundColor = UIColor(red: 0/255, green: 255/255, blue: 234/255, alpha: 1)
        
    }
    
    @objc func badgeRefresh(_ Notification: Foundation.Notification) {
        self.badgeNum = Fhooder.orderQuantity!

        if badgeNum > 0  {
            self.tabBar.items![1].badgeValue = String(badgeNum!)
        }
        else if badgeNum <= 0 {
            self.tabBar.items![1].badgeValue = nil
        }
    }
}
