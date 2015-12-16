//
//  HistoryViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 6/8/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
//

import UIKit

final class HistoryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nav = self.navigationController?.navigationBar
        
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor(),NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 20)!]
        
        self.title = "History"
    }
    
    
    
    
    
    @IBAction func cancelButton(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
