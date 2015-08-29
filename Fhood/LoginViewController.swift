//
//  LoginViewController.swift
//  Fhood
//
//  Created by YOUNG on 8/29/15.
//  Copyright © 2015 YOUNG&YOUM. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
