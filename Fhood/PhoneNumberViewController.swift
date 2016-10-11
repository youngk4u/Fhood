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
    let rootViewController: UIViewController = UIApplication.sharedApplication().windows[1].rootViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        
        // Get phone number from Parse
        if PFUser.currentUser()?.objectForKey("phone") != nil {
            self.textField.text = "\(PFUser.currentUser()!.objectForKey("phone")!)"
            self.phoneNumber = self.textField.text
            
        }
        
        self.textField.becomeFirstResponder()
    }
    
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PhoneNumberViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
    }

    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize =  (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                kbHeight = keyboardSize.height
                bottomSave.constant = kbHeight
            }
        }
    }
    
    
    @IBAction func saveButton(sender: AnyObject) {
        
        let number = self.textField.text!
        
        if number.characters.count == 13 && self.phoneNumber != self.textField.text{
        
            let user = PFUser.currentUser()
        
            user!["phone"] = number
            do {
                try user!.save()
                
                let alert = UIAlertController(title: "", message:"Your new phone number has been saved!", preferredStyle: .Alert)
                let saved = UIAlertAction(title: "Cool!", style: .Default) { _ in}
                alert.addAction(saved)
                rootViewController.presentViewController(alert, animated: true, completion: nil)
                
                // Reload tableview from previous controller
                NSNotificationCenter.defaultCenter().postNotificationName("loadSettings", object: nil)
                
                navigationController?.popViewControllerAnimated(true)
            }
            catch {
                let alert = UIAlertController(title: "", message:"Something went wrong!", preferredStyle: .Alert)
                let error = UIAlertAction(title: "Ok", style: .Default) { _ in}
                alert.addAction(error)
                rootViewController.presentViewController(alert, animated: true){}
            }

        }
        else if number.characters.count == 13 && self.phoneNumber == self.textField.text {
            let alert = UIAlertController(title: "", message:"Your phone number is already saved!", preferredStyle: .Alert)
            let redun = UIAlertAction(title: "Ok", style: .Default) { _ in}
            alert.addAction(redun)
            rootViewController.presentViewController(alert, animated: true){}
        }
        else {
            let alert = UIAlertController(title: "", message:"Are you sure that's your phone number?", preferredStyle: .Alert)
            let not = UIAlertAction(title: "Guess not", style: .Default) { _ in}
            alert.addAction(not)
            rootViewController.presentViewController(alert, animated: true){}
        }
        
    }
    
    
    
    // Auto phone number formatter
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        let components = newString.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
        
        let decimalString : String = components.joinWithSeparator("")
        let length = decimalString.characters.count
        let decimalStr = decimalString as NSString
        let hasLeadingOne = length > 0 && decimalStr.characterAtIndex(0) == (1 as unichar)
        
        if length == 0 || (length > 10 && !hasLeadingOne) || length > 11
        {
            let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
            
            return (newLength > 10) ? false : true
        }
        var index = 0 as Int
        let formattedString = NSMutableString()
        
        if hasLeadingOne
        {
            formattedString.appendString("1 ")
            index += 1
        }
        if (length - index) > 3
        {
            let areaCode = decimalStr.substringWithRange(NSMakeRange(index, 3))
            formattedString.appendFormat("(%@)", areaCode)
            index += 3
        }
        if length - index > 3
        {
            let prefix = decimalStr.substringWithRange(NSMakeRange(index, 3))
            formattedString.appendFormat("%@-", prefix)
            index += 3
        }
        
        let remainder = decimalStr.substringFromIndex(index)
        formattedString.appendString(remainder)
        textField.text = formattedString as String
        return false
    }
}


