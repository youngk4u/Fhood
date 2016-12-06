//
//  LandingViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 8/28/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
//

import UIKit

final class LandingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let navigationBar = self.navigationController!.navigationBar
        navigationBar.barTintColor = UIColor(red: 0/255, green: 255/255, blue: 234/255, alpha: 1.0)
        navigationBar.tintColor = UIColor.black

        // Color Gradient
        let topColor = UIColor(red: 0, green: 255/255.0, blue: 234/255.0, alpha: 1)
        let bottomColor = UIColor(red: 255/255.0, green: 255/225.0, blue: 255/255.0, alpha: 1)
        
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as [NSNumber]?
        
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
