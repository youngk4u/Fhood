//
//  CookingTimeViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 10/8/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
//

import UIKit
import Parse

final class CookingTimeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var cookingSwitch: UISwitch!
    
    @IBOutlet var openTextfield: UITextField!
    @IBOutlet var closeTextfield: UITextField!
    
    private var openTimeHour: Int!
    private var openTimeMin: Int!
    private var closeTimeHour: Int!
    private var closeTimeMin: Int!
    private var amPm: Bool = true
    
    private var totalDailyQuantity: Int!
    private var picker : UIPickerView!
    
    @IBOutlet weak var scheduleView: UIView!
    
    @IBOutlet var centerConstraint: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.openTextfield.tintColor = UIColor.clearColor()
        self.closeTextfield.tintColor = UIColor.clearColor()
        
        self.openTextfield.delegate = self
        self.closeTextfield.delegate = self
        
        
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
                    
                    self.openTextfield.text = fhooder!.valueForKey("openTime") as? String
                    self.closeTextfield.text = fhooder!.valueForKey("closeTime") as? String
                    
                }
                else {
                    self.cookingSwitch.on = false
                    self.scheduleView.alpha = 0
                }
            }
        
        }
        
        self.cookingSwitch.addTarget(self, action: #selector(CookingTimeViewController.switchState(_:)), forControlEvents: UIControlEvents.ValueChanged)
       
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
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        self.createDoneButton(textField)
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Time
        let currentDate = NSDate()
        var newDate : NSDate!
        
        if textField == self.openTextfield {
            
            newDate = NSDate(timeInterval: (0 * 60), sinceDate: currentDate)
            
            datePickerView.minimumDate = newDate
            datePickerView.date = newDate
            textField.inputView = datePickerView
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            openTextfield.text = dateFormatter.stringFromDate(newDate)
            
            datePickerView.addTarget(self, action: #selector(CookingTimeViewController.datePickerValueChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        }
        else if textField == self.closeTextfield {
            
            if self.openTextfield.text != "Now" {
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "h:mm a"
                
                let localeStr = "en_US_POSIX"
                dateFormatter.locale = NSLocale(localeIdentifier: localeStr)
                dateFormatter.timeZone = NSTimeZone(name: "US/Pacific")
                
                let openTimeString = self.openTextfield.text!
                let openTime = dateFormatter.dateFromString(openTimeString)

                newDate = NSDate(timeInterval: (1 * 60), sinceDate: openTime!)
            }
            else {
                newDate = NSDate(timeInterval: (1 * 60), sinceDate: currentDate)
            }
            
            datePickerView.minimumDate = newDate
            datePickerView.date = newDate
            textField.inputView = datePickerView
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            closeTextfield.text = dateFormatter.stringFromDate(newDate)
        
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.view.frame.origin.y -= 100
            })
            datePickerView.addTarget(self, action: #selector(CookingTimeViewController.datePickerValueChanged2(_:)), forControlEvents: UIControlEvents.ValueChanged)
        }
        return true
    }
    
    
    func createDoneButton(sender: UITextField) {
        // Create a button bar for the number pad or cuisine type picker
        let keyboardDoneButtonView = UIToolbar()
        keyboardDoneButtonView.sizeToFit()
        
        if sender == closeTextfield {
        // Setup the buttons to be put in the system.
            let item = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CookingTimeViewController.pickerDoneButton2) )
            let item2 = UIBarButtonItem(title: "Later", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CookingTimeViewController.laterButton) )
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
            item.tintColor = UIColor.blackColor()
            let toolbarButtons = [flexibleSpace, item, flexibleSpace, item2]
            //Put the buttons into the ToolBar and display the tool bar
            keyboardDoneButtonView.setItems(toolbarButtons, animated: false)
            sender.inputAccessoryView = keyboardDoneButtonView
        }
        else {
            let item = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CookingTimeViewController.pickerDoneButton) )
            let item2 = UIBarButtonItem(title: "Now", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CookingTimeViewController.nowButton))
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
            item.tintColor = UIColor.blackColor()
            let toolbarButtons = [flexibleSpace, item, flexibleSpace, item2]
            //Put the buttons into the ToolBar and display the tool bar
            keyboardDoneButtonView.setItems(toolbarButtons, animated: false)
            sender.inputAccessoryView = keyboardDoneButtonView
        }
    }
    
    
    func pickerDoneButton() {
        self.view.endEditing(true)
    }
    
    func pickerDoneButton2() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.view.frame.origin.y -= -100
        })
        self.view.endEditing(true)
    }
    
    func nowButton() {
        self.openTextfield.text = "Now"
        self.view.endEditing(true)
    }
    
    func laterButton() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.view.frame.origin.y -= -100
        })

        self.closeTextfield.text = "Later"
        self.view.endEditing(true)
    }
    

    
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        openTextfield.text = dateFormatter.stringFromDate(sender.date)
    }
    
    func datePickerValueChanged2(sender:UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        closeTextfield.text = dateFormatter.stringFromDate(sender.date)
    }
    
    
    // Done button
    @IBAction func doneButton(sender: AnyObject) {
        
        let query = PFQuery(className: "Fhooder")
        query.getObjectInBackgroundWithId(Fhooder.objectID!) { (fhooder: PFObject?, error: NSError?) -> Void in
            if error == nil && fhooder != nil {
                
                fhooder!["isOpen"] = Fhooder.isOpen
                
                if self.openTextfield.text == "Now" {
                    fhooder!["openTime"] = "Now"
                }
                else {
                    fhooder!["openTime"] = self.openTextfield.text
                }
                
                if self.closeTextfield.text == "Later" {
                    fhooder!["closeTime"] = "Later"
                }
                else {
                    fhooder!["closeTime"] = self.closeTextfield.text
                }
                
                fhooder?.saveInBackground()
                
            }
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("load3", object: nil)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
