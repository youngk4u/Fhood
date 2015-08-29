//
//  OrderedViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 7/26/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
//

import UIKit

final class OrderedViewController: UIViewController {

    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var orderTime: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.hidden = true
        
        self.address.text = variables.address!
        //self.orderTime.text = "\(variables.orderTimeHour):\(variables.orderTimeMinute) \(variables.orderTimeAmpm)"
        
    }
    

    override func viewWillAppear(animated: Bool)
    {
        self.navigationController?.navigationBarHidden = true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
