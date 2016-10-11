//
//  ProfileViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 11/13/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
//

import UIKit
import Parse

final class ProfileViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    
    var firstName: String?
    var lastName: String?
    
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var profileButton: UIButton!
    @IBOutlet var addressButton: UIButton!
    @IBOutlet var aboutMeButton: UIButton!
    
    @IBOutlet var bottomUpdate: NSLayoutConstraint!
    
    @IBOutlet var profileButtonTop: NSLayoutConstraint!
    @IBOutlet var profilePicTop: NSLayoutConstraint!
    
    @IBOutlet var textFieldCloseButton: UIButton!
    
    let rootViewController: UIViewController = UIApplication.sharedApplication().windows[0].rootViewController!
    
    var kbHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Reload data
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProfileViewController.loadProfile(_:)),name:"loadProfileView", object: nil)
        
        // Navigation bar appearance
        let nav = self.navigationController?.navigationBar
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor(),NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 20)!]
        self.title = "Profile"
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        
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
        
        loadAddress()
        
        loadAboutMe()
        
    }
    
    
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProfileViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProfileViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func loadProfile(notification: NSNotification){
        loadProfilePic()
        loadAddress()
        loadAboutMe()
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
    
    func loadAddress() {
        // Get address from Parse 
        if PFUser.currentUser()?.objectForKey("streetAddress") != nil && PFUser.currentUser()?.objectForKey("city") != nil && PFUser.currentUser()?.objectForKey("stateProvince") != nil && PFUser.currentUser()?.objectForKey("zip") != nil && PFUser.currentUser()?.objectForKey("country") != nil {
            self.addressButton.setTitle("\(PFUser.currentUser()!.objectForKey("city")!)" + ", " + "\(PFUser.currentUser()!.objectForKey("stateProvince")!)" + ", " + "\(PFUser.currentUser()!.objectForKey("country")!)", forState: .Normal)
            self.addressButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        }
    }
    
    func loadAboutMe() {
        // Get about me from Parse
        if PFUser.currentUser()?.objectForKey("aboutMe") != nil {
            let aboutMe = String(PFUser.currentUser()!.objectForKey("aboutMe")!)
            self.aboutMeButton.setTitle(aboutMe, forState: .Normal)
            self.aboutMeButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            
            if aboutMe == "" {
                self.aboutMeButton.setTitle("About me", forState: .Normal)
                self.aboutMeButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
            }
        }
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize =  (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                self.kbHeight = keyboardSize.height
                self.bottomUpdate.constant = kbHeight
                
                self.profileButtonTop.constant = -100
                self.profilePicTop.constant = -100
                
                UIView.animateWithDuration(0.2, animations: {
                    self.view.layoutIfNeeded()
                    }, completion: nil)
                
                self.textFieldCloseButton.alpha = 1
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let _ = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                self.bottomUpdate.constant = 0
                
                self.profileButtonTop.constant = 0
                self.profilePicTop.constant = 33

                self.textFieldCloseButton.alpha = 0
            }
        }
    }
    
    
    func textfieldClose() {
        self.view.endEditing(true)
        
        self.textFieldCloseButton.alpha = 0
        
        self.bottomUpdate.constant = 0
        self.profileButtonTop.constant = 0
        self.profilePicTop.constant = 33
        
        UIView.animateWithDuration(0.2, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == self.firstNameTextField {
            textField.text = textField.text?.capitalizedString
        }
        else if textField == self.lastNameTextField {
            textField.text = textField.text?.capitalizedString
        }
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.firstNameTextField {
            textField.text = textField.text?.capitalizedString
        }
        else if textField == self.lastNameTextField {
            textField.text = textField.text?.capitalizedString
        }
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

            
            let user = PFUser.currentUser()
            
            if self.firstName != "" {
                user!["firstName"] = firstName
            }
            if self.lastName != "" {
                user!["lastName"] = lastName
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
                let alert = UIAlertController(title: "", message:"There was an error!", preferredStyle: .Alert)
                let error = UIAlertAction(title: "Ok", style: .Default) { _ in}
                alert.addAction(error)
                rootViewController.presentViewController(alert, animated: true, completion: nil)
                
            }

        }
        
    }

    private func validateInput() -> Bool {
        
        var newInfo = false
        
        if self.firstNameTextField.text == "" && self.lastNameTextField.text == ""  {
            self.showAlert(withMessage: "Please fill out the information before saving!")
            return false
        }

        
        if self.firstName != self.firstNameTextField.text! && self.firstNameTextField.text != ""{
            newInfo = true
        }
        else if self.lastName != self.lastNameTextField.text! && self.lastNameTextField.text != ""{
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
