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

    @IBOutlet fileprivate var totalPriceLabel: UILabel!
    @IBOutlet fileprivate var welcomeSign: UILabel!
    @IBOutlet fileprivate var fhooderFace: UIImageView!
    @IBOutlet fileprivate var fhooderFaceName: UILabel!

    fileprivate let formatter = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logo = UIImage(named: "FhoodLogo")
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView
        
        self.tabBarController?.tabBar.isHidden = true
        
        // Currency formatter
        self.formatter.numberStyle = .currency
        totalPriceLabel.text = self.formatter.string(from: NSNumber(value: Fhoodie.totalDue!))
        
        self.welcomeSign.text = "Welcome to \(Fhooder.shopName!)!"
        
        let image = UIImageView(image: Fhooder.fhooderPicture!)
        image.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        image.layer.masksToBounds = false
        image.layer.cornerRadius = 13
        image.layer.cornerRadius = image.frame.size.height/2
        image.clipsToBounds = true
        self.fhooderFace.addSubview(image)
        
        self.fhooderFaceName.text = Fhooder.fhooderFirstName!
        
        
    }

    
}
