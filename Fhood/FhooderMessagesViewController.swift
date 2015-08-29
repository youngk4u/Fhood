//
//  FhooderMessagesViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 6/11/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
//

import UIKit

final class FhooderMessagesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }

    @IBAction func segmentControl(sender: AnyObject) {
        
        switch sender.selectedSegmentIndex
        {
        case 0:
            performSegueWithIdentifier("toDirectionView", sender: self)
        case 1:
            return
        case 2:
            performSegueWithIdentifier("toMainView", sender: self)
        default:
            break
        }
    }

}
