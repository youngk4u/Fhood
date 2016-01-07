//
//  ConfirmViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 7/16/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
//

import UIKit

final class ConfirmViewController: UIViewController {

    @IBOutlet private var totalPriceLabel: UILabel!
    @IBOutlet private var welcomeSign: UILabel!
    @IBOutlet private var fhooderFace: UIImageView!
    @IBOutlet private var fhooderFaceName: UILabel!

    private let formatter = NSNumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logo = UIImage(named: "FhoodLogo")
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView
        
        self.tabBarController?.tabBar.hidden = true
        
        // Currency formatter
        self.formatter.numberStyle = .CurrencyStyle
        totalPriceLabel.text = self.formatter.stringFromNumber(Fhoodie.totalDue!)
        
        self.welcomeSign.text = "Welcome to \(Fhooder.shopName!)!"
        
        self.fhooderFace.image = UIImage(named: Fhooder.fhooderFace!)
        self.fhooderFaceName.text = Fhooder.fhooderFirstName!
    }
}
