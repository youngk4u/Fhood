//
//  AddressViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 12/5/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
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
    
    let rootViewController: UIViewController = UIApplication.shared.windows[1].rootViewController!
    

    
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
        if PFUser.current()?.object(forKey: "streetAddress") != nil {
            self.streetAddressTextField.text = "\(PFUser.current()!.object(forKey: "streetAddress")!)"
            self.streetAddressTextField.textColor = UIColor.black
            self.streetAddress = self.streetAddressTextField.text
        }
        if PFUser.current()?.object(forKey: "unit") != nil {
            self.aptAddressTextField.text = "\(PFUser.current()!.object(forKey: "unit")!)"
            self.aptAddressTextField.textColor = UIColor.black
            self.aptAddress = self.aptAddressTextField.text
        }
        if PFUser.current()?.object(forKey: "city") != nil {
            self.cityAddressTextField.text = "\(PFUser.current()!.object(forKey: "city")!)"
            self.cityAddressTextField.textColor = UIColor.black
            self.cityAddress = self.cityAddressTextField.text
        }
        if PFUser.current()?.object(forKey: "stateProvince") != nil {
            self.stateAddressTextField.text = "\(PFUser.current()!.object(forKey: "stateProvince")!)"
            self.stateAddressTextField.textColor = UIColor.black
            self.stateAddress = self.stateAddressTextField.text
        }
        if PFUser.current()?.object(forKey: "zip") != nil {
            self.zipAddressTextField.text = "\(PFUser.current()!.object(forKey: "zip")!)"
            self.zipAddressTextField.textColor = UIColor.black
            self.zipAddress = self.zipAddressTextField.text
        }
        
        
    }
    
    
    // Picker view for State/Province
    func numberOfComponentsInPickerView(_ pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return statePickerValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return statePickerValues[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        stateAddressTextField.text = statePickerValues[row]
    }
    
    
    
    
    
    
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddressViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddressViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.cityAddressTextField {
            textField.text = textField.text?.capitalized
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.cityAddressTextField {
            textField.text = textField.text?.capitalized
        }

        textField.resignFirstResponder()
        return true
    }
    
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize =  (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                kbHeight = keyboardSize.height
                bottomSave.constant = kbHeight
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.layoutIfNeeded()
                    }, completion: nil)
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if let _ = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            bottomSave.constant = 0
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    
    // Zip code no more than 5 numbers
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
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
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }

    
    
    
    
    @IBAction func saveButton(_ sender: UIButton) {
        
        if validateInput() {

            let user = PFUser.current()
            
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
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: "loadProfileView"), object: nil)
                
                let alert = UIAlertController(title: "", message:"Your new info has been updated!", preferredStyle: .alert)
                let saved = UIAlertAction(title: "Nice!", style: .default) { _ in}
                alert.addAction(saved)
                rootViewController.present(alert, animated: true, completion: nil)
                
                
                _ = navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            }
            catch {
                let alert = UIAlertController(title: "", message:"There was an error!", preferredStyle: .alert)
                let error = UIAlertAction(title: "Ok", style: .default) { _ in}
                alert.addAction(error)
                rootViewController.present(alert, animated: true, completion: nil)
                
            }
            
        }
        
        
    }
    
    fileprivate func validateInput() -> Bool {
        
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
    
    fileprivate func showAlert(withMessage message: String) {
        let alert = UIAlertController(title: "Oops", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        rootViewController.present(alert, animated: true, completion: nil)
    }

}
