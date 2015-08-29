//
//  ListNavigationController.swift
//  Fhood
//
//  Created by Young-hu Kim on 7/21/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
//

import UIKit

final class ListNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set Tab Bar icon image
        self.tabBarItem.image = UIImage(named: "ListWhite")
        self.tabBarItem.selectedImage = UIImage(named: "ListCyan")
    }
}
