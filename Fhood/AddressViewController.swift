//
//  AddressViewController.swift
//  Fhood
//
//  Created by YOUNG on 12/5/15.
//  Copyright © 2015 YOUNG&YOUM. All rights reserved.
//

import UIKit
import Parse

class AddressViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate {

    @IBOutlet var streetAddressTextField: UITextField!
    @IBOutlet var aptAddressTextField: UITextField!
    @IBOutlet var cityAddressTextField: UITextField!
    @IBOutlet var stateAddressTextField: UITextField!
    @IBOutlet var zipAddressTextField: UITextField!
    
    var streetAddress: String?
    var aptAddress: String?
    var cityAddress: String?
    var stateAddress: String?
    var zipAddress: String?
    
    @IBOutlet var bottomSave: NSLayoutConstraint!
    var kbHeight: CGFloat!
    
    var statePicker: UIPickerView!
    let statePickerValues = ["","AL","AK","AZ","AR","CA","CO","CT","DE","FL","GA","HI","ID","IL", "IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ","NM","NY","NC","ND","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VT","VA","WA","WV","WI","WY"]
    
    let rootViewController: UIViewController = UIApplication.sharedApplication().windows[1].rootViewController!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Address"
        
        self.statePicker = UIPickerView()
        
        // textField delegates
        self.streetAddressTextField.delegate = self
        self.aptAddressTextField.delegate = self
        self.cityAddressTextField.delegate = self
        self.zipAddressTextField.delegate = self
        self.statePicker.delegate = self
        
        self.stateAddressTextField.inputView = self.statePicker
        self.stateAddressTextField.text = ""
        
        // Get address from Parse
        if PFUser.currentUser()?.objectForKey("streetAddress") != nil {
            self.streetAddressTextField.text = "\(PFUser.currentUser()!.objectForKey("streetAddress")!)"
            self.streetAddressTextField.textColor = UIColor.blackColor()
            self.streetAddress = self.streetAddressTextField.text
        }
        if PFUser.currentUser()?.objectForKey("unit") != nil {
            self.aptAddressTextField.text = "\(PFUser.currentUser()!.objectForKey("unit")!)"
            self.aptAddressTextField.textColor = UIColor.blackColor()
            self.aptAddress = self.aptAddressTextField.text
        }
        if PFUser.currentUser()?.objectForKey("city") != nil {
            self.cityAddressTextField.text = "\(PFUser.currentUser()!.objectForKey("city")!)"
            self.cityAddressTextField.textColor = UIColor.blackColor()
            self.cityAddress = self.cityAddressTextField.text
        }
        if PFUser.currentUser()?.objectForKey("stateProvince") != nil {
            self.stateAddressTextField.text = "\(PFUser.currentUser()!.objectForKey("stateProvince")!)"
            self.stateAddressTextField.textColor = UIColor.blackColor()
            self.stateAddress = self.stateAddressTextField.text
        }
        if PFUser.currentUser()?.objectForKey("zip") != nil {
            self.zipAddressTextField.text = "\(PFUser.currentUser()!.objectForKey("zip")!)"
            self.zipAddressTextField.textColor = UIColor.blackColor()
            self.zipAddress = self.zipAddressTextField.text
        }
        
        
    }
    
    
    // Picker view for State/Province
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return statePickerValues.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return statePickerValues[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        stateAddressTextField.text = statePickerValues[row]
    }
    
    
    
    
    
    
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddressViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddressViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == self.cityAddressTextField {
            textField.text = textField.text?.capitalizedString
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.cityAddressTextField {
            textField.text = textField.text?.capitalizedString
        }

        textField.resignFirstResponder()
        return true
    }
    
    
    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize =  (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                kbHeight = keyboardSize.height
                bottomSave.constant = kbHeight
                UIView.animateWithDuration(0.2, animations: {
                    self.view.layoutIfNeeded()
                    }, completion: nil)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let _ = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            bottomSave.constant = 0
            UIView.animateWithDuration(0.2, animations: {
                self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    
    // Zip code no more than 5 numbers
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField == self.zipAddressTextField {
            guard let text = textField.text else { return true }
            
            let newLength = text.utf16.count + string.utf16.count - range.length
            return newLength <= 5 // Bool
        }
        return true
    }
    
    func textfieldClose() {
        self.view.endEditing(true)
        
        self.bottomSave.constant = 0
        
        UIView.animateWithDuration(0.2, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }

    
    
    
    
    @IBAction func saveButton(sender: UIButton) {
        
        if validateInput() {

            let user = PFUser.currentUser()
            
            if self.streetAddressTextField.text != "" {
                user!["streetAddress"] = self.streetAddressTextField.text
            }
            
            // Apt unit number is optional
            user!["unit"] = self.aptAddressTextField.text
            
            if self.cityAddressTextField.text != "" {
                user!["city"] = self.cityAddressTextField.text
            }
            if self.stateAddressTextField.text != "" {
                user!["stateProvince"] = self.stateAddressTextField.text
            }
            if self.zipAddressTextField.text != "" {
                user!["zip"] = self.zipAddressTextField.text
            }
            
            // Country
            user!["country"] = "United States"
            
            
            do {
                try user!.save()
                
                NSNotificationCenter.defaultCenter().postNotificationName("loadProfileView", object: nil)
                
                let alert = UIAlertController(title: "", message:"Your new info has been updated!", preferredStyle: .Alert)
                let saved = UIAlertAction(title: "Nice!", style: .Default) { _ in}
                alert.addAction(saved)
                rootViewController.presentViewController(alert, animated: true, completion: nil)
                
                
                navigationController?.popViewControllerAnimated(true)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            catch {
                let alert = UIAlertController(title: "", message:"There was an error!", preferredStyle: .Alert)
                let error = UIAlertAction(title: "Ok", style: .Default) { _ in}
                alert.addAction(error)
                rootViewController.presentViewController(alert, animated: true, completion: nil)
                
            }
            
        }
        
        
    }
    
    private func validateInput() -> Bool {
        
        var newInfo = false
        
        if self.streetAddressTextField.text == "" || self.cityAddressTextField.text == "" || self.stateAddressTextField.text == "" || self.zipAddressTextField.text == "" {
            self.showAlert(withMessage: "Please fill out all the information before saving!")
            return false
        }
        
        if self.streetAddress != self.streetAddressTextField.text! && self.streetAddressTextField.text != ""{
            newInfo = true
        }
        else if self.aptAddress != self.aptAddressTextField.text!{
            newInfo = true
        }
        else if self.cityAddress != self.cityAddressTextField.text! && self.cityAddressTextField.text != ""{
            newInfo = true
        }
        else if self.stateAddress != self.stateAddressTextField.text! && self.stateAddressTextField.text != "" {
            newInfo = true
        }
        else if self.zipAddress != self.zipAddressTextField.text! && self.zipAddressTextField.text != "" {
            newInfo = true
        }
        
        
        if newInfo == false {
            
            self.showAlert(withMessage: "There's nothing to save!")
            return false
        }
        
        return true
    }
    
    private func showAlert(withMessage message: String) {
        let alert = UIAlertController(title: "Oops", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        rootViewController.presentViewController(alert, animated: true, completion: nil)
    }

}
