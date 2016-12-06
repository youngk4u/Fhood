//
//  EmailViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 11/13/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
//

import UIKit
import Parse

final class EmailViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var bottomSave: NSLayoutConstraint!
    
    var emailAddress: String!
    
    var kbHeight: CGFloat!
    let rootViewController: UIViewController = UIApplication.shared.windows[1].rootViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get email address from Parse
        if PFUser.current()?.object(forKey: "email") != nil {
            self.emailTextField.text = "\(PFUser.current()!.object(forKey: "email")!)"
            self.emailAddress = self.emailTextField.text!
        }

        
        self.emailTextField.becomeFirstResponder()

    }
    
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(EmailViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
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
        let email = self.emailTextField.text!
        
        if validateInput() {
            
            let user = PFUser.current()
            
            user!["email"] = email
            user!["username"] = email
            do {
                try user!.save()
            
                let alert = UIAlertController(title: "", message:"Your new email has been saved!", preferredStyle: .alert)
                let saved = UIAlertAction(title: "Nice!", style: .default) { _ in}
                alert.addAction(saved)
                rootViewController.present(alert, animated: true, completion: nil)
                
                // Reload tableview from previous controller
                NotificationCenter.default.post(name: Notification.Name(rawValue: "loadSettings"), object: nil)
                
                _ = navigationController?.popViewController(animated: true)
            }
            catch {
                let alert = UIAlertController(title: "", message:"There was an erro!", preferredStyle: .alert)
                let error = UIAlertAction(title: "Ok", style: .default) { _ in}
                alert.addAction(error)
                rootViewController.present(alert, animated: true, completion: nil)

            }
        }

    }
    
    fileprivate func validateInput() -> Bool {
        guard let email = self.emailTextField.text, !email.isEmpty else {
            self.showAlert(withMessage: "Please, enter an email before continuing!")
            return false
        }
        
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$"
        let pattern = try! NSRegularExpression(pattern: emailRegex, options: [])
        let strRange = NSRange(location: 0, length: email.characters.count)
        guard pattern.firstMatch(in: email, options: [], range: strRange) != nil else {
            self.showAlert(withMessage: "Please, enter a valid email before continuing!")
            return false
        }
        
        guard emailAddress != self.emailTextField.text else{
            self.showAlert(withMessage: "Your email address is already saved!")
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
