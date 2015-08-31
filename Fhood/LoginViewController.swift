//
//  LoginViewController.swift
//  Fhood
//
//  Created by YOUNG on 8/29/15.
//  Copyright © 2015 YOUNG&YOUM. All rights reserved.
//

import UIKit
import Parse

final class LoginViewController: OnboardingViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func authenticate() {
        let email = self.emailTextField.text!
        let password = self.passwordTextField.text!

        HUD.show()
        PFUser.logInWithUsernameInBackground(email, password: password) { user, error in
            HUD.dismiss()

        }
    }
}
