//
//  PhoneNumberViewController.swift
//  Fhood
//
//  Created by YOUNG on 11/13/15.
//  Copyright © 2015 YOUNG&YOUM. All rights reserved.
//

import UIKit

class PhoneNumberViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var bottonSaveButton: NSLayoutConstraint!
    
    var kbHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.phoneTextField.becomeFirstResponder()

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
