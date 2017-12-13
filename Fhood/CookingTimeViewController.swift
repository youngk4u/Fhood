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
    
    fileprivate var openTimeHour: Int!
    fileprivate var openTimeMin: Int!
    fileprivate var closeTimeHour: Int!
    fileprivate var closeTimeMin: Int!
    fileprivate var amPm: Bool = true
    
    fileprivate var totalDailyQuantity: Int!
    fileprivate var picker : UIPickerView!
    
    @IBOutlet weak var scheduleView: UIView!
    
    @IBOutlet var centerConstraint: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.openTextfield.tintColor = UIColor.clear
        self.closeTextfield.tintColor = UIColor.clear
        
        self.openTextfield.delegate = self
        self.closeTextfield.delegate = self
        
        
        // Round corners for scheduleView
        self.scheduleView.layer.cornerRadius = 7
        
        
        let query = PFQuery(className: "Fhooder")
        query.getObjectInBackground(withId: Fhooder.objectID!) { (fhooder: PFObject?, error: Error?) -> Void in
            if error == nil && fhooder != nil {
                Fhooder.isOpen = fhooder!.value(forKey: "isOpen") as? Bool
        
        
                // Initializing the switch
                if Fhooder.isOpen == true {
                    self.cookingSwitch.isOn = true
                    self.scheduleView.alpha = 1
                    
                    self.openTextfield.text = fhooder!.value(forKey: "openTime") as? String
                    self.closeTextfield.text = fhooder!.value(forKey: "closeTime") as? String
                    
                }
                else {
                    self.cookingSwitch.isOn = false
                    self.scheduleView.alpha = 0
                }
            }
        
        }
        
        self.cookingSwitch.addTarget(self, action: #selector(CookingTimeViewController.switchState(_:)), for: UIControlEvents.valueChanged)
       
    }
    
    // Switch function for the cooking time on/off
    @objc func switchState (_ Switch: UISwitch) {
        
        HUD.show()
        
        self.totalDailyQuantity = 0
        
        // See if dailyQuantity is set for any items before opening the shop
        let query = PFQuery(className: "Fhooder")
        query.getObjectInBackground(withId: Fhooder.objectID!) { (fhooder: PFObject?, error: Error?) -> Void in
            
            let relation = fhooder!.relation(forKey: "items")
            let query2 = relation.query()
            
            query2.findObjectsInBackground(block: { (items: [PFObject]?, error2: Error?) -> Void in
                if error2 == nil && items != nil {
                    for item in items! {
                        
                        let itemDailyQuantity = item["dailyQuantity"] as! Int
                        self.totalDailyQuantity = self.totalDailyQuantity + itemDailyQuantity
                        
                        
                        if Switch.isOn && self.totalDailyQuantity == 0 {
                            Switch.isOn = false
                            Fhooder.isOpen = false
                            let alert = UIAlertController(title: "", message:"Please set daily quantity before opening!", preferredStyle: .alert)
                            let error = UIAlertAction(title: "Ok", style: .default) { _ in}
                            alert.addAction(error)
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                        else if Switch.isOn {
                            Fhooder.isOpen = true
                            UIView.animate(withDuration: 0.3, animations: { 
                                self.scheduleView.alpha = 1
                            }, completion: { (true) in
                                
                            })
                            

                        }
                        else {
                            Fhooder.isOpen = false
                            UIView.animate(withDuration: 0.3, animations: {
                                self.scheduleView.alpha = 1
                            }, completion: { (true) in
                                
                            })
                        }
                        
                    }
                }
            })
        }
        HUD.dismiss()
    }

    // Closed button for Switch
    @IBAction func closedButton(_ sender: AnyObject) {
        self.cookingSwitch.setOn(false, animated: true)
        switchState(cookingSwitch)
    }
    
    // Open button for Switch
    @IBAction func openButton(_ sender: AnyObject) {
        self.cookingSwitch.setOn(true, animated: true)
        switchState(cookingSwitch)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        self.createDoneButton(textField)
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.time
        let currentDate = Date()
        var newDate : Date!
        
        if textField == self.openTextfield {
            
            newDate = Date(timeInterval: (0 * 60), since: currentDate)
            
            datePickerView.minimumDate = newDate
            datePickerView.date = newDate
            textField.inputView = datePickerView
            
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = DateFormatter.Style.short
            openTextfield.text = dateFormatter.string(from: newDate)
            
            datePickerView.addTarget(self, action: #selector(CookingTimeViewController.datePickerValueChanged(_:)), for: UIControlEvents.valueChanged)
        }
        else if textField == self.closeTextfield {
            
            if self.openTextfield.text != "Now" {
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "h:mm a"
                
                let localeStr = "en_US_POSIX"
                dateFormatter.locale = Locale(identifier: localeStr)
                dateFormatter.timeZone = TimeZone(identifier: "US/Pacific")
                
                let openTimeString = self.openTextfield.text!
                let openTime = dateFormatter.date(from: openTimeString)

                newDate = Date(timeInterval: (1 * 60), since: openTime!)
            }
            else {
                newDate = Date(timeInterval: (1 * 60), since: currentDate)
            }
            
            datePickerView.minimumDate = newDate
            datePickerView.date = newDate
            textField.inputView = datePickerView
            
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = DateFormatter.Style.short
            closeTextfield.text = dateFormatter.string(from: newDate)
        
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
                self.view.frame.origin.y -= 100
            })
            datePickerView.addTarget(self, action: #selector(CookingTimeViewController.datePickerValueChanged2(_:)), for: UIControlEvents.valueChanged)
        }
        return true
    }
    
    
    func createDoneButton(_ sender: UITextField) {
        // Create a button bar for the number pad or cuisine type picker
        let keyboardDoneButtonView = UIToolbar()
        keyboardDoneButtonView.sizeToFit()
        
        if sender == closeTextfield {
        // Setup the buttons to be put in the system.
            let item = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(CookingTimeViewController.pickerDoneButton2) )
            let item2 = UIBarButtonItem(title: "Later", style: UIBarButtonItemStyle.plain, target: self, action: #selector(CookingTimeViewController.laterButton) )
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
            item.tintColor = UIColor.black
            let toolbarButtons = [flexibleSpace, item, flexibleSpace, item2]
            //Put the buttons into the ToolBar and display the tool bar
            keyboardDoneButtonView.setItems(toolbarButtons, animated: false)
            sender.inputAccessoryView = keyboardDoneButtonView
        }
        else {
            let item = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(CookingTimeViewController.pickerDoneButton) )
            let item2 = UIBarButtonItem(title: "Now", style: UIBarButtonItemStyle.plain, target: self, action: #selector(CookingTimeViewController.nowButton))
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
            item.tintColor = UIColor.black
            let toolbarButtons = [flexibleSpace, item, flexibleSpace, item2]
            //Put the buttons into the ToolBar and display the tool bar
            keyboardDoneButtonView.setItems(toolbarButtons, animated: false)
            sender.inputAccessoryView = keyboardDoneButtonView
        }
    }
    
    
    @objc func pickerDoneButton() {
        self.view.endEditing(true)
    }
    
    @objc func pickerDoneButton2() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
            self.view.frame.origin.y -= -100
        })
        self.view.endEditing(true)
    }
    
    @objc func nowButton() {
        self.openTextfield.text = "Now"
        self.view.endEditing(true)
    }
    
    @objc func laterButton() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
            self.view.frame.origin.y -= -100
        })

        self.closeTextfield.text = "Later"
        self.view.endEditing(true)
    }
    

    
    
    @objc func datePickerValueChanged(_ sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        openTextfield.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func datePickerValueChanged2(_ sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        closeTextfield.text = dateFormatter.string(from: sender.date)
    }
    
    
    // Done button
    @IBAction func doneButton(_ sender: AnyObject) {
        
        let query = PFQuery(className: "Fhooder")
        query.getObjectInBackground(withId: Fhooder.objectID!) { (fhooder: PFObject?, error: Error?) -> Void in
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
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "load3"), object: nil)
        
        self.dismiss(animated: true, completion: nil)
    }

}
