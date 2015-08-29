//
//  MoreViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 5/18/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
//

import UIKit

final class MoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    var moreArray = ["Contact us", "Notifications", "About us", "Report users", "Help"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let logo = UIImage(named: "FhoodLogo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moreArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("MoreTableViewCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = self.moreArray[indexPath.row]
        cell.textLabel?.textColor = UIColor.darkGrayColor()
        cell.textLabel?.font = UIFont.systemFontOfSize(15.0)
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "Version alpha 1.0"
    }
    


}
