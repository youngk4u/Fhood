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
        
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as [NSNumber]?
        
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        let seconds = 3.0
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            
            // Back to mapview
            Router.route(true)
        })
        
    }
}
