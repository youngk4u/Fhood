//
//  SignUpViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 8/28/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
//

import UIKit
import Parse

final class SignUpViewController: OnboardingViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func authenticate() {
        let user = PFUser()
        user.username = self.emailTextField.text
        user.password = self.passwordTextField.text
        user.email = self.emailTextField.text
        user["phone"] = "555-555-5555"

        user.signUpInBackgroundWithBlock { success, error in

        }
    }
}
