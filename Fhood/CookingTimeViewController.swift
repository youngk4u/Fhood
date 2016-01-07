//
//  CookingTimeViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 10/8/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
//

import UIKit
import Parse

final class CookingTimeViewController: UIViewController {

    @IBOutlet weak var cookingSwitch: UISwitch!
    @IBOutlet weak var openTimeButton: UIButton!
    @IBOutlet weak var closeTimeButton: UIButton!
    
    private var openTimeHour: Int!
    private var openTimeMin: Int!
    private var closeTimeHour: Int!
    private var closeTimeMin: Int!
    private var amPm: Bool = true
    
    private var totalDailyQuantity: Int!
    
    @IBOutlet weak var scheduleView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Round corners for scheduleView
        self.scheduleView.layer.cornerRadius = 7
        
        
        let query = PFQuery(className: "Fhooder")
        query.getObjectInBackgroundWithId(Fhooder.objectID!) { (fhooder: PFObject?, error: NSError?) -> Void in
            if error == nil && fhooder != nil {
                Fhooder.isOpen = fhooder!.valueForKey("isOpen") as? Bool
        
        
                // Initializing the switch
                if Fhooder.isOpen == true {
                    self.cookingSwitch.on = true
                    self.scheduleView.alpha = 1
                }
                else {
                    self.cookingSwitch.on = false
                    self.scheduleView.alpha = 0
                }
            }
        
        }
        
        self.cookingSwitch.addTarget(self, action: "switchState:", forControlEvents: UIControlEvents.ValueChanged)
       
    }
    
    // Switch function for the cooking time on/off
    func switchState (Switch: UISwitch) {
        
        HUD.show()
        
        self.totalDailyQuantity = 0
        
        // See if dailyQuantity is set for any items before opening the shop
        let query = PFQuery(className: "Fhooder")
        query.getObjectInBackgroundWithId(Fhooder.objectID!) { (fhooder: PFObject?, error: NSError?) -> Void in
            
            let relation = fhooder!.relationForKey("items")
            let query2 = relation.query()
            
            query2.findObjectsInBackgroundWithBlock({ (items: [PFObject]?, error2: NSError?) -> Void in
                if error2 == nil && items != nil {
                    for item in items! {
                        
                        let itemDailyQuantity = item["dailyQuantity"] as! Int
                        self.totalDailyQuantity = self.totalDailyQuantity + itemDailyQuantity
                        
                        
                        if Switch.on && self.totalDailyQuantity == 0 {
                            Switch.on = false
                            Fhooder.isOpen = false
                            let alert = UIAlertController(title: "", message:"Please set daily quantity before opening!", preferredStyle: .Alert)
                            let error = UIAlertAction(title: "Ok", style: .Default) { _ in}
                            alert.addAction(error)
                            self.presentViewController(alert, animated: true, completion: nil)
                            
                        }
                        else if Switch.on {
                            Fhooder.isOpen = true
                            UIView.animateWithDuration(0.3, animations: { () -> Void in
                                self.scheduleView.alpha = 1
                            })
                        }
                        else {
                            Fhooder.isOpen = false
                            UIView.animateWithDuration(0.3, animations: { () -> Void in
                                self.scheduleView.alpha = 0
                            })
                        }
                        
                    }
                }
            })
        }
        HUD.dismiss()
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
        
        let query = PFQuery(className: "Fhooder")
        query.getObjectInBackgroundWithId(Fhooder.objectID!) { (fhooder: PFObject?, error: NSError?) -> Void in
            if error == nil && fhooder != nil {
                
                fhooder!["isOpen"] = Fhooder.isOpen
                fhooder?.saveInBackground()
                
            }
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("load3", object: nil)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
