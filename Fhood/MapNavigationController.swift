//
//  MapNavigationController.swift
//  Fhood
//
//  Created by Young-hu Kim on 6/2/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
//

import UIKit

final class MapNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Tab Bar icon image
        self.tabBarItem.image = UIImage(named: "MapWhite")
        self.tabBarItem.selectedImage = UIImage(named: "MapCyan")
    }
}
