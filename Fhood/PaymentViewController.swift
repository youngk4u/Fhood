//
//  PaymentViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 6/3/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
//

import UIKit

final class PaymentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nav = self.navigationController?.navigationBar
        
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor(),NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 20)!]
        self.title = "Payment"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    
    }
    
    @IBAction func closePayment(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Table View
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PaymentTableViewCell", forIndexPath: indexPath)
        
        
        
        return cell
    }

    
}
