//
//  ConfirmViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 7/16/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
//

import UIKit
import Parse


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
        
        let image = UIImageView(image: Fhooder.fhooderPicture!)
        image.frame = CGRectMake(0, 0, 80, 80)
        image.layer.masksToBounds = false
        image.layer.cornerRadius = 13
        image.layer.cornerRadius = image.frame.size.height/2
        image.clipsToBounds = true
        self.fhooderFace.addSubview(image)
        
        self.fhooderFaceName.text = Fhooder.fhooderFirstName!
        
        
    }

    
}
