//
//  FeaturedNavigationController.swift
//  Fhood
//
//  Created by Young-hu Kim on 6/3/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
//

import UIKit

final class FeaturedNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set Tab Bar icon image
        self.tabBarItem.image = UIImage(named: "FeaturedWhite")
        self.tabBarItem.selectedImage = UIImage(named: "FeaturedCyan")

    }
}
