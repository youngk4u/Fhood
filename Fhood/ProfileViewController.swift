//
//  ProfileViewController.swift
//  Fhood
//
//  Created by YOUNG on 11/13/15.
//  Copyright © 2015 YOUNG&YOUM. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var addressTextField: UITextField!
    @IBOutlet var aboutMeTextField: UITextField!
    
    var firstName: String?
    var lastName: String?
    var address: String?
    var aboutMe: String?
    
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var profileButton: UIButton!
    
    @IBOutlet var bottomSave: NSLayoutConstraint!
    
    @IBOutlet var profileButtonTop: NSLayoutConstraint!
    @IBOutlet var profilePicTop: NSLayoutConstraint!
    
    @IBOutlet var textFieldCloseButton: UIButton!
    
    let rootViewController: UIViewController = UIApplication.sharedApplication().windows[1].rootViewController!
    
    var kbHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Reload data
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadProfileView:",name:"loadProfileViewPic", object: nil)
        
        // Navigation bar appearance
        let nav = self.navigationController?.navigationBar
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor(),NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 20)!]
        self.title = "Profile"
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        addressTextField.delegate = self
        aboutMeTextField.delegate = self
        
        // Get profile info from Parse
        loadProfilePic()
        
        if PFUser.currentUser()?.objectForKey("firstName") != nil {
            self.firstNameTextField.text = "\(PFUser.currentUser()!.objectForKey("firstName")!)"
            self.firstName = self.firstNameTextField.text!
        }
        if PFUser.currentUser()?.objectForKey("lastName") != nil {
            self.lastNameTextField.text = "\(PFUser.currentUser()!.objectForKey("lastName")!)"
            self.lastName = self.lastNameTextField.text!
        }
        if PFUser.currentUser()?.objectForKey("address") != nil {
            self.addressTextField.text = "\(PFUser.currentUser()!.objectForKey("address")!)"
            self.address = self.addressTextField.text!
        }
        if PFUser.currentUser()?.objectForKey("aboutMe") != nil {
            self.aboutMeTextField.text = "\(PFUser.currentUser()!.objectForKey("aboutMe")!)"
            self.aboutMe = self.aboutMeTextField.text!
        }

        
    }
    
    
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func loadProfileView(notification: NSNotification){
        loadProfilePic()
    }
    
    func loadProfilePic() {
        // Get picture from file(Parse)
        if PFUser.currentUser()?.objectForKey("profilePhoto") != nil {
            let userImageFile = PFUser.currentUser()!["profilePhoto"] as! PFFile
            userImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        self.profilePic.image = UIImage(data:imageData)
                        let image = UIImageView(image: self.profilePic.image)
                        self.profilePic.image = nil
                        image.frame = CGRectMake(0, 0, 60, 60)
                        image.layer.masksToBounds = false
                        image.layer.cornerRadius = 13
                        image.layer.cornerRadius = image.frame.size.height/2
                        image.clipsToBounds = true
                        self.profilePic.addSubview(image)
                        
                    }
                }
            }
        }
        else {
            // Get picture from Facebook(Parse)
            if PFUser.currentUser()?.objectForKey("pictureUrl") != nil {
                if let picURL = NSURL(string: "\(PFUser.currentUser()!.objectForKey("pictureUrl")!)") {
                    if let data = NSData(contentsOfURL: picURL) {
                        self.profilePic.image = UIImage(data: data)
                        
                        // Profile pic becomes round with white border
                        let image = UIImageView(image: self.profilePic.image)
                        self.profilePic.image = nil // Get rid of the duplicate
                        image.frame = CGRectMake(0, 0, 60, 60)
                        image.layer.masksToBounds = false
                        image.layer.borderColor = UIColor.whiteColor().CGColor
                        image.layer.cornerRadius = 13
                        image.layer.cornerRadius = image.frame.size.height/2
                        image.clipsToBounds = true
                        self.profilePic.addSubview(image)
                        
                    }
                }
            }
        }
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize =  (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                self.kbHeight = keyboardSize.height
                self.bottomSave.constant = kbHeight
                
                self.profileButtonTop.constant = -100
                self.profilePicTop.constant = -100
                
                UIView.animateWithDuration(0.2, animations: {
                    self.view.layoutIfNeeded()
                    }, completion: nil)
                
                self.textFieldCloseButton.alpha = 1
            }
        }
    }
    
    
    func textfieldClose() {
        self.view.endEditing(true)
        
        self.textFieldCloseButton.alpha = 0
        
        self.bottomSave.constant = 0
        self.profileButtonTop.constant = 0
        self.profilePicTop.constant = 33
        
        UIView.animateWithDuration(0.2, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textfieldClose()
        return true
    }
    
    @IBAction func closeKeyboard(sender: AnyObject) {
        textfieldClose()
    }
    
    
    @IBAction func saveButton(sender: AnyObject) {

        
        if validateInput() {
            
            self.firstName = self.firstNameTextField.text
            self.lastName = self.lastNameTextField.text
            self.address = self.addressTextField.text
            self.aboutMe = self.aboutMeTextField.text

            
            let user = PFUser.currentUser()
            
            if self.firstName != "" {
                user!["firstName"] = firstName
            }
            if self.lastName != "" {
                user!["lastName"] = lastName
            }
            if self.address != "" {
                user!["address"] = address
            }
            if self.aboutMe != "" {
                user!["aboutMe"] = aboutMe
            }
            
            do {
                try user!.save()
            
                NSNotificationCenter.defaultCenter().postNotificationName("loadSettings", object: nil)
                
                let alert = UIAlertController(title: "", message:"Your new info has been updated!", preferredStyle: .Alert)
                let saved = UIAlertAction(title: "Nice!", style: .Default) { _ in}
                alert.addAction(saved)
                rootViewController.presentViewController(alert, animated: true, completion: nil)
        
                
                navigationController?.popViewControllerAnimated(true)
                self.dismissViewControllerAnimated(true, completion: nil)
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
        
        var newInfo = false
        
        if self.firstNameTextField.text == "" && self.lastNameTextField.text == "" && self.addressTextField.text == "" && self.aboutMeTextField.text == "" {
            self.showAlert(withMessage: "Please fill out the information before saving!")
            return false
        }

        
        if self.firstName != self.firstNameTextField.text! && self.firstNameTextField.text != ""{
            newInfo = true
        }
        else if self.lastName != self.lastNameTextField.text! && self.lastNameTextField.text != ""{
            newInfo = true
        }
        else if self.address != self.addressTextField.text! && self.addressTextField.text != "" {
            newInfo = true
        }
        else if self.aboutMe != self.aboutMeTextField.text! && self.aboutMeTextField.text != ""{
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
    
    @IBAction func closeProfile(sender: AnyObject) {
        self.view.endEditing(true)
        navigationController?.popViewControllerAnimated(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
