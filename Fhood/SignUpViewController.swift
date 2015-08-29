//
//  SignUpViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 8/28/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
//

import UIKit

final class SignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
