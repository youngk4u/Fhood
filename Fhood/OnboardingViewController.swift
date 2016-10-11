//
//  OnboardingViewController.swift
//  Fhood
//
//  Created by Matias Pequeno on 8/29/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4

final class OnboardingViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBInspectable var intentIsLogin: Bool = false

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.emailTextField.becomeFirstResponder()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    // MARK: - Private functions

    @IBAction private func facebookTapped() {
        if let token = FBSDKAccessToken.currentAccessToken() {
            return self.authenticate(withFacebookAccessToken: token)
        }


        FBSDKLoginManager().logInWithReadPermissions(Constants.Vendor.FacebookPermissions, fromViewController: self) { (result, error) -> Void in
      
            guard result?.isCancelled == false else { return }
            guard error == nil, let token = result?.token else {
                FBSDKLoginManager().logOut()
                self.showAlert(withMessage: "There was an error logging in to your Facebook account, please try again!")
                return
            }

            self.authenticate(withFacebookAccessToken: token)
        }
    }

    private func authenticate() {
        guard let email = self.emailTextField.text, let password = self.passwordTextField.text else { return }
        
        HUD.show()

        if self.intentIsLogin {
            PFUser.logInWithUsernameInBackground(email, password: password) { [weak self] user, error in
                self?.parseDidAuthenticate(withUser: user, error: error)
            }

        } else {
            let user = PFUser(email: email, password: password)
            
            user.signUpInBackgroundWithBlock { [weak self] _, error in
                self?.parseDidAuthenticate(withUser: PFUser.currentUser(), error: error)
            }
        }
    }

    private func authenticate(withFacebookAccessToken token: FBSDKAccessToken) {
        HUD.show()
        PFFacebookUtils.logInInBackgroundWithAccessToken(token) { [weak self] user, error in
            guard error == nil, let user = user else {
                self?.parseDidAuthenticate(withUser: nil, error: error)
                return
            }

            // If the user already exists, we just finish authentication and move on
            if !user.isNew {
                self?.parseDidAuthenticate(withUser: user, error: error)
                return
            }

            // For new users, we grab some extra info and save it
            let graphParameters = ["fields": "first_name, last_name, email, picture.type(large)"]
            let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: graphParameters)
            graphRequest.startWithCompletionHandler { _, result, _ in
                // if for some reason this fails, we must ask for the user's email separately
                guard let email = result?["email"] as? String else {
                    self?.parseDidAuthenticate(withUser: user, error: nil)
                    return
                }

                user.username = email
                user.email = email
                user["firstName"] = result?["first_name"] as? String
                user["lastName"] = result?["last_name"] as? String
                user["pictureUrl"] = result?["picture"]??["data"]??["url"] as? String
                user.saveInBackgroundWithBlock { _, error  in
                    self?.parseDidAuthenticate(withUser: user, error: nil)
                }
            }
        }
    }
    

    private func parseDidAuthenticate(withUser user: PFUser?, error: NSError?) {
        HUD.dismiss()

        guard error == nil && user != nil else {
            let message = error?.localizedDescription ?? "Something went wrong, please try again!"
            self.showAlert(withMessage: message)
            return
        }

        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        
        
        let installation: PFInstallation = PFInstallation.currentInstallation()!
        installation["user"] = PFUser.currentUser()
        installation.saveInBackground()


        Router.route(true)
    }

    private func validateInput() -> Bool {
        guard let email = self.emailTextField.text  where !email.isEmpty else {
            self.showAlert(withMessage: "Please, enter an email before continuing!")
            self.emailTextField.becomeFirstResponder()
            return false
        }

        guard let password = self.passwordTextField.text  where !password.isEmpty else {
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

// MARK: - PFUser private extension

private extension PFUser {

    convenience init(email: String, password: String) {
        self.init()

        self.username = email
        self.email = email
        self.password = password
        
    }
}
