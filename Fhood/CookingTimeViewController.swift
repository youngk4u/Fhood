//
//  CookingTimeViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 10/8/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
//

import UIKit

final class CookingTimeViewController: UIViewController {

    @IBOutlet weak var cookingSwitch: UISwitch!
    @IBOutlet weak var openTimeButton: UIButton!
    @IBOutlet weak var closeTimeButton: UIButton!
    
    private var openTimeHour: Int = 0
    private var openTimeMin: Int = 0
    private var closeTimeHour: Int = 0
    private var closeTimeMin: Int = 0
    private var amPm: Bool = true
    
    @IBOutlet weak var scheduleView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Round corners for scheduleView
        self.scheduleView.layer.cornerRadius = 7
        
        // Initializing the switch
        if Fhooder.isOpen == true {
            self.cookingSwitch.on = true
            self.scheduleView.alpha = 1
        }
        else {
            self.scheduleView.alpha = 0
        }
        
        self.cookingSwitch.addTarget(self, action: "switchState:", forControlEvents: UIControlEvents.ValueChanged)
       
    }
    
    // Switch function for the cooking time on/off
    func switchState (Switch: UISwitch) {
        if Switch.on {
            Fhooder.isOpen = true
            Fhooder.isClosed = false
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.scheduleView.alpha = 1
                })
        }
        else {
            Fhooder.isClosed = true
            Fhooder.isOpen = false
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.scheduleView.alpha = 0
            })
        }
    }

    // Closed button for Switch
    @IBAction func closedButton(sender: AnyObject) {
        self.cookingSwitch.setOn(false, animated: true)
        switchState(cookingSwitch)
    }
    
    // Open button for Switch
    @IBAction func openButton(sender: AnyObject) {
        self.cookingSwitch.setOn(true, animated: true)
        switchState(cookingSwitch)
    }
    
    
    // Done button
    @IBAction func doneButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
