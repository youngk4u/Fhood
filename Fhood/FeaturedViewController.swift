//
//  FeaturedViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 5/18/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
//

import UIKit

final class FeaturedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logo = UIImage(named: "FhoodLogo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.layoutMargins = UIEdgeInsetsZero
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("featuredTableCell") as! FeaturedTableViewCell
        
        cell.layoutMargins = UIEdgeInsetsZero
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        fhooderOne()
        
        self.performSegueWithIdentifier("toFhooderView", sender: tableView)

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    
}
