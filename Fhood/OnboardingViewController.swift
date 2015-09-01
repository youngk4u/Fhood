//
//  OnboardingViewController.swift
//  Fhood
//
//  Created by Matias Pequeno on 8/29/15.
//  Copyright © 2015 YOUNG&YOUM. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.emailTextField.becomeFirstResponder()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func authenticate() {
        assertionFailure("subclasses must implement")
    }

    // MARK: - Private functions

    private func validateInput() -> Bool {
        guard let email = self.emailTextField.text where !email.isEmpty else {
            self.showAlert(withMessage: "Please, enter an email before continuing!")
            self.emailTextField.becomeFirstResponder()
            return false
        }

        guard let password = self.passwordTextField.text where !password.isEmpty else {
            self.showAlert(withMessage: "Please, enter a password before continuing!")
            self.passwordTextField.becomeFirstResponder()
            return false
        }

        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$"
        let pattern = try! NSRegularExpression(pattern: emailRegex, options: [])
        let strRange = NSRange(location: 0, length: email.characters.count)
        guard pattern.firstMatchInString(email, options: [], range: strRange) != nil else {
            self.showAlert(withMessage: "Please, enter a valid email before continuing!")
            self.emailTextField.becomeFirstResponder()
            return false
        }

        guard password.characters.count > 4 else {
            self.showAlert(withMessage: "Please, enter a password with at least 5 characters!")
            self.passwordTextField.becomeFirstResponder()
            return false
        }

        return true
    }

    private func showAlert(withMessage message: String) {
        let alert = UIAlertController(title: "Oops", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate implementation

extension OnboardingViewController: UITextFieldDelegate {

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField === self.emailTextField {
            self.passwordTextField.becomeFirstResponder()
        } else if self.validateInput() {
            self.authenticate()
        }

        return true
    }

}