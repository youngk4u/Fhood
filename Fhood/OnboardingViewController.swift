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

        self.emailTextField.becomeFirstResponder()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func authenticate() {
        assertionFailure("subclasses must implement")
    }

    // MARK: - Private functions

    private func validateInput() -> Bool {
        // validate email
        // validate password
        return false
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