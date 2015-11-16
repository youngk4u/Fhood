//
//  EmailViewController.swift
//  Fhood
//
//  Created by YOUNG on 11/13/15.
//  Copyright © 2015 YOUNG&YOUM. All rights reserved.
//

import UIKit

class EmailViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var bottonSaveButton: NSLayoutConstraint!
    
    var kbHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                bottonSaveButton.constant = kbHeight
            }
        }
    }

}
