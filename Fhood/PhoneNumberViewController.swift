//
//  PhoneNumberViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 11/13/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
//

import UIKit
import Parse

final class PhoneNumberViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var bottomSave: NSLayoutConstraint!
    var phoneNumber: String!
    var kbHeight: CGFloat!
    let rootViewController: UIViewController = UIApplication.shared.windows[1].rootViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        
        // Get phone number from Parse
        if PFUser.current()?.object(forKey: "phone") != nil {
            self.textField.text = "\(PFUser.current()!.object(forKey: "phone")!)"
            self.phoneNumber = self.textField.text
            
        }
        
        self.textField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(PhoneNumberViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
    }

    
    func keyboardWillShow(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize =  (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                kbHeight = keyboardSize.height
                bottomSave.constant = kbHeight
            }
        }
    }
    
    
    @IBAction func saveButton(_ sender: AnyObject) {
        
        let number = self.textField.text!
        
        if number.characters.count == 13 && self.phoneNumber != self.textField.text{
        
            let user = PFUser.current()
        
            user!["phone"] = number
            do {
                try user!.save()
                
                let alert = UIAlertController(title: "", message:"Your new phone number has been saved!", preferredStyle: .alert)
                let saved = UIAlertAction(title: "Cool!", style: .default) { _ in}
                alert.addAction(saved)
                rootViewController.present(alert, animated: true, completion: nil)
                
                // Reload tableview from previous controller
                NotificationCenter.default.post(name: Notification.Name(rawValue: "loadSettings"), object: nil)
                
                _ = navigationController?.popViewController(animated: true)
            }
            catch {
                let alert = UIAlertController(title: "", message:"Something went wrong!", preferredStyle: .alert)
                let error = UIAlertAction(title: "Ok", style: .default) { _ in}
                alert.addAction(error)
                rootViewController.present(alert, animated: true){}
            }

        }
        else if number.characters.count == 13 && self.phoneNumber == self.textField.text {
            let alert = UIAlertController(title: "", message:"Your phone number is already saved!", preferredStyle: .alert)
            let redun = UIAlertAction(title: "Ok", style: .default) { _ in}
            alert.addAction(redun)
            rootViewController.present(alert, animated: true){}
        }
        else {
            let alert = UIAlertController(title: "", message:"Are you sure that's your phone number?", preferredStyle: .alert)
            let not = UIAlertAction(title: "Guess not", style: .default) { _ in}
            alert.addAction(not)
            rootViewController.present(alert, animated: true){}
        }
        
    }
    
    
    
    // Auto phone number formatter
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let components = newString.components(separatedBy: CharacterSet.decimalDigits.inverted)
        
        let decimalString : String = components.joined(separator: "")
        let length = decimalString.characters.count
        let decimalStr = decimalString as NSString
        let hasLeadingOne = length > 0 && decimalStr.character(at: 0) == (1 as unichar)
        
        if length == 0 || (length > 10 && !hasLeadingOne) || length > 11
        {
            let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
            
            return (newLength > 10) ? false : true
        }
        var index = 0 as Int
        let formattedString = NSMutableString()
        
        if hasLeadingOne
        {
            formattedString.append("1 ")
            index += 1
        }
        if (length - index) > 3
        {
            let areaCode = decimalStr.substring(with: NSMakeRange(index, 3))
            formattedString.appendFormat("(%@)", areaCode)
            index += 3
        }
        if length - index > 3
        {
            let prefix = decimalStr.substring(with: NSMakeRange(index, 3))
            formattedString.appendFormat("%@-", prefix)
            index += 3
        }
        
        let remainder = decimalStr.substring(from: index)
        formattedString.append(remainder)
        textField.text = formattedString as String
        return false
    }
}


