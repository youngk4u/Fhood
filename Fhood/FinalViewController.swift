//
//  FinalViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 7/18/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
//

import UIKit

final class FinalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Color Gradient
        let topColor = UIColor(red: 0, green: 255/255.0, blue: 234/255.0, alpha: 1)
        let bottomColor = UIColor(red: 255/255.0, green: 255/225.0, blue: 255/255.0, alpha: 1)
        
        let gradientColors: [CGColor] = [topColor.CGColor, bottomColor.CGColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, atIndex: 0)
    }
}
