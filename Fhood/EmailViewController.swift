//
//  EmailViewController.swift
//  Fhood
//
//  Created by YOUNG on 11/13/15.
//  Copyright © 2015 YOUNG&YOUM. All rights reserved.
//

import UIKit
import Parse

class EmailViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var bottomSave: NSLayoutConstraint!
    
    var emailAddress: String!
    
    var kbHeight: CGFloat!
    let rootViewController: UIViewController = UIApplication.sharedApplication().windows[1].rootViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get email address from Parse
        if PFUser.currentUser()?.objectForKey("email") != nil {
            self.emailTextField.text = "\(PFUser.currentUser()!.objectForKey("email")!)"
            self.emailAddress = self.emailTextField.text!
        }

        
        self.emailTextField.becomeFirstResponder()

    }
    
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        
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
        let email = self.emailTextField.text!
        
        if validateInput() {
            
            let user = PFUser.currentUser()
            
            user!["email"] = email
            user!["username"] = email
            do {
                try user!.save()
            
                let alert = UIAlertController(title: "", message:"Your new email has been saved!", preferredStyle: .Alert)
                let saved = UIAlertAction(title: "Nice!", style: .Default) { _ in}
                alert.addAction(saved)
                rootViewController.presentViewController(alert, animated: true, completion: nil)
                
                // Reload tableview from previous controller
                NSNotificationCenter.defaultCenter().postNotificationName("loadSettings", object: nil)
                
                navigationController?.popViewControllerAnimated(true)
            }
            catch {
                let alert = UIAlertController(title: "", message:"There was an erro!", preferredStyle: .Alert)
                let error = UIAlertAction(title: "Ok", style: .Default) { _ in}
                alert.addAction(error)
                rootViewController.presentViewController(alert, animated: true, completion: nil)

            }
        }

    }
    
    private func validateInput() -> Bool {
        guard let email = self.emailTextField.text where !email.isEmpty else {
            self.showAlert(withMessage: "Please, enter an email before continuing!")
            return false
        }
        
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$"
        let pattern = try! NSRegularExpression(pattern: emailRegex, options: [])
        let strRange = NSRange(location: 0, length: email.characters.count)
        guard pattern.firstMatchInString(email, options: [], range: strRange) != nil else {
            self.showAlert(withMessage: "Please, enter a valid email before continuing!")
            return false
        }
        
        guard emailAddress != self.emailTextField.text else{
            self.showAlert(withMessage: "Your email address is already saved!")
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
