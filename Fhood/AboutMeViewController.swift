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
    
    let rootViewController: UIViewController = UIApplication.shared.windows[1].rootViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "About me"
        
        self.textView.delegate = self
        
        textView.text = self.text
        textView.textColor = UIColor.lightGray
        
        // Get about me from Parse
        if PFUser.current()?.object(forKey: "aboutMe") != nil {
            self.textView.text = "\(PFUser.current()!.object(forKey: "aboutMe")!)"
            self.textView.textColor = UIColor.black
            self.aboutMeText = self.textView.text!
            
            if self.aboutMeText == "" {
                textView.text = self.text
                textView.textColor = UIColor.lightGray
            }
        }
        
        
    }
    
    func textView(_ textView: UITextView,  shouldChangeTextIn range:NSRange, replacementText text:String ) -> Bool {
        
        if range.length + range.location > textView.text.characters.count {
            return false
        }
        let newlength = textView.text.characters.count + text.characters.count - range.length
        return newlength <= 300
    }

    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = self.text
            textView.textColor = UIColor.lightGray
        }
    }

    
    
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AboutMeViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
    }
    
    
    func keyboardWillShow(_ notification: Notification) {
        
        
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

    @IBAction func saveButton(_ sender: UIButton) {
        
        if validateInput() {
            
            let user = PFUser.current()
            
            user!["aboutMe"] = self.textView.text
            

            
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
    
    fileprivate func showAlert(withMessage message: String) {
        let alert = UIAlertController(title: "Oops", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        rootViewController.present(alert, animated: true, completion: nil)
    }
}
