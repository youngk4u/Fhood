//
//  OrdersViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 8/30/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
//

import UIKit

final class OrdersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var TableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Logo
        let logo = UIImage(named: "FhoodLogo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        // TableView Delegates
        self.TableView.delegate = self
        self.TableView.dataSource = self
        

    }

    // Table View
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Try to get a cell to reuse
        let cell = tableView.dequeueReusableCellWithIdentifier("Tablecell") as! OrdersTableViewCell
        
        // Cell Marginal lines on the left to stretch all the way to the left screen
        cell.layoutMargins = UIEdgeInsetsZero

        // Link Fhoodie information
        
        
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
                
        TableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    


}
