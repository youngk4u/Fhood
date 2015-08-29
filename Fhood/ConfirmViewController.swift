//
//  ConfirmViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 7/16/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
//

import UIKit

final class ConfirmViewController: UIViewController {

    
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var welcomeSign: UILabel!
    @IBOutlet weak var fhooderFace: UIImageView!
    @IBOutlet weak var fhooderFaceName: UILabel!
    
    
    var formatter = NSNumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logo = UIImage(named: "FhoodLogo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        self.tabBarController?.tabBar.hidden = true
        
        // Currency formatter
        self.formatter.numberStyle = .CurrencyStyle
        totalPriceLabel.text = formatter.stringFromNumber(variables.totalItemPrice!)
        
        self.welcomeSign.text = "Welcome to \(variables.name!)!"
        
        self.fhooderFace.image = UIImage(named: variables.fhooderFace!)
        self.fhooderFaceName.text = variables.fhooderFirstName!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
