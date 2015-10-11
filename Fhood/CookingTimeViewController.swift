//
//  CookingTimeViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 10/8/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
//

import UIKit

class CookingTimeViewController: UIViewController {

    @IBOutlet weak var cookingSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if variables.isOpen == true {
            self.cookingSwitch.on = true
        }
        self.cookingSwitch.addTarget(self, action: "switchState:", forControlEvents: UIControlEvents.ValueChanged)
       
    }
    
    func switchState (Switch: UISwitch) {
        if Switch.on {
            variables.isOpen = true
            variables.isClosed = false
        }
        else {
            variables.isClosed = true
            variables.isOpen = false
        }
    }

    @IBAction func closedButton(sender: AnyObject) {
        self.cookingSwitch.setOn(false, animated: true)
        switchState(cookingSwitch)
    }
    
    @IBAction func openButton(sender: AnyObject) {
        self.cookingSwitch.setOn(true, animated: true)
        switchState(cookingSwitch)
    }
    
    
    
    
    @IBAction func doneButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
