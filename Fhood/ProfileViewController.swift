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
    
    let rootViewController: UIViewController = UIApplication.shared.windows[0].rootViewController!
    
    var kbHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Reload data
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.loadProfile(_:)),name:NSNotification.Name(rawValue: "loadProfileView"), object: nil)
        
        // Navigation bar appearance
        let nav = self.navigationController?.navigationBar
        nav?.titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.black,NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): UIFont(name: "HelveticaNeue-Light", size: 20)!]
        self.title = "Profile"
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        
        // Get profile info from Parse
        loadProfilePic()
        
        if PFUser.current()?.object(forKey: "firstName") != nil {
            self.firstNameTextField.text = "\(PFUser.current()!.object(forKey: "firstName")!)"
            self.firstName = self.firstNameTextField.text!
        }
        if PFUser.current()?.object(forKey: "lastName") != nil {
            self.lastNameTextField.text = "\(PFUser.current()!.object(forKey: "lastName")!)"
            self.lastName = self.lastNameTextField.text!
        }
        
        loadAddress()
        
        loadAboutMe()
        
    }
    
    
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func loadProfile(_ notification: Notification){
        loadProfilePic()
        loadAddress()
        loadAboutMe()
    }
    
    func loadProfilePic() {
        // Get picture from file(Parse)
        if PFUser.current()?.object(forKey: "profilePhoto") != nil {
            let userImageFile = PFUser.current()!["profilePhoto"] as! PFFile
            userImageFile.getDataInBackground {
                (imageData: Data?, error: Error?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        self.profilePic.image = UIImage(data:imageData)
                        let image = UIImageView(image: self.profilePic.image)
                        self.profilePic.image = nil
                        image.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
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
            if PFUser.current()?.object(forKey: "pictureUrl") != nil {
                if let picURL = URL(string: "\(PFUser.current()!.object(forKey: "pictureUrl")!)") {
                    if let data = try? Data(contentsOf: picURL) {
                        self.profilePic.image = UIImage(data: data)
                        
                        // Profile pic becomes round with white border
                        let image = UIImageView(image: self.profilePic.image)
                        self.profilePic.image = nil // Get rid of the duplicate
                        image.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
                        image.layer.masksToBounds = false
                        image.layer.borderColor = UIColor.white.cgColor
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
        if PFUser.current()?.object(forKey: "streetAddress") != nil && PFUser.current()?.object(forKey: "city") != nil && PFUser.current()?.object(forKey: "stateProvince") != nil && PFUser.current()?.object(forKey: "zip") != nil && PFUser.current()?.object(forKey: "country") != nil {
            self.addressButton.setTitle("\(PFUser.current()!.object(forKey: "city")!)" + ", " + "\(PFUser.current()!.object(forKey: "stateProvince")!)" + ", " + "\(PFUser.current()!.object(forKey: "country")!)", for: UIControlState())
            self.addressButton.setTitleColor(UIColor.black, for: UIControlState())
        }
    }
    
    func loadAboutMe() {
        // Get about me from Parse
        if PFUser.current()?.object(forKey: "aboutMe") != nil {
            let aboutMe = String(describing: PFUser.current()!.object(forKey: "aboutMe")!)
            self.aboutMeButton.setTitle(aboutMe, for: UIControlState())
            self.aboutMeButton.setTitleColor(UIColor.black, for: UIControlState())
            
            if aboutMe == "" {
                self.aboutMeButton.setTitle("About me", for: UIControlState())
                self.aboutMeButton.setTitleColor(UIColor.lightGray, for: UIControlState())
            }
        }
    }
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize =  (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                self.kbHeight = keyboardSize.height
                self.bottomUpdate.constant = kbHeight
                
                self.profileButtonTop.constant = -100
                self.profilePicTop.constant = -100
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.layoutIfNeeded()
                    }, completion: nil)
                
                self.textFieldCloseButton.alpha = 1
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            if let _ = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
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
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.firstNameTextField {
            textField.text = textField.text?.capitalized
        }
        else if textField == self.lastNameTextField {
            textField.text = textField.text?.capitalized
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.firstNameTextField {
            textField.text = textField.text?.capitalized
        }
        else if textField == self.lastNameTextField {
            textField.text = textField.text?.capitalized
        }
        textfieldClose()
        return true
    }
    
    @IBAction func closeKeyboard(_ sender: AnyObject) {
        textfieldClose()
    }
    
    
    @IBAction func saveButton(_ sender: AnyObject) {

        
        if validateInput() {
            
            self.firstName = self.firstNameTextField.text
            self.lastName = self.lastNameTextField.text

            
            let user = PFUser.current()
            
            if self.firstName != "" {
                user!["firstName"] = firstName
            }
            if self.lastName != "" {
                user!["lastName"] = lastName
            }
            
            do {
                try user!.save()
            
                NotificationCenter.default.post(name: Notification.Name(rawValue: "loadSettings"), object: nil)
                
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
    
    
    fileprivate func showAlert(withMessage message: String) {
        let alert = UIAlertController(title: "Oops", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        rootViewController.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func closeProfile(_ sender: AnyObject) {
        self.view.endEditing(true)
        _ = navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }

}
