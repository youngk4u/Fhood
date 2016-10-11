//
//  AboutMeViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 12/6/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
//

import UIKit
import Parse

class AboutMeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var textView: UITextView!
    @IBOutlet var bottomSave: NSLayoutConstraint!
    var aboutMeText: String?
    var kbHeight: CGFloat!
    
    var text: String = "Describe yourself in 200 characters."
    
    let rootViewController: UIViewController = UIApplication.sharedApplication().windows[1].rootViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "About me"
        
        self.textView.delegate = self
        
        textView.text = self.text
        textView.textColor = UIColor.lightGrayColor()
        
        // Get about me from Parse
        if PFUser.currentUser()?.objectForKey("aboutMe") != nil {
            self.textView.text = "\(PFUser.currentUser()!.objectForKey("aboutMe")!)"
            self.textView.textColor = UIColor.blackColor()
            self.aboutMeText = self.textView.text!
            
            if self.aboutMeText == "" {
                textView.text = self.text
                textView.textColor = UIColor.lightGrayColor()
            }
        }
        
        
    }
    
    func textView(textView: UITextView,  shouldChangeTextInRange range:NSRange, replacementText text:String ) -> Bool {
        
        if range.length + range.location > textView.text.characters.count {
            return false
        }
        let newlength = textView.text.characters.count + text.characters.count - range.length
        return newlength <= 200
    }

    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = self.text
            textView.textColor = UIColor.lightGrayColor()
        }
    }

    
    
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AboutMeViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
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

    @IBAction func saveButton(sender: UIButton) {
        
        if validateInput() {
            
            let user = PFUser.currentUser()
            
            user!["aboutMe"] = self.textView.text
            

            
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
        
        if self.aboutMeText == self.textView.text! && self.textView.text == "" {
            self.showAlert(withMessage: "Please fill out all the information before saving!")
            return false
        }
        
        if self.aboutMeText != self.textView.text! {
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
