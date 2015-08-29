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
    
    private let moreArray = ["Contact us", "Notifications", "About us", "Report users", "Help"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let logo = UIImage(named: "FhoodLogo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        // Configure reveal for this view
        let revealController = self.revealViewController()
        revealController.panGestureRecognizer()
        revealController.tapGestureRecognizer()

        // Account Icon
        let accountIcon = UIImage(named: "userCircle2")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: accountIcon, style: UIBarButtonItemStyle.Plain,
            target: revealController, action: "revealToggle:")
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moreArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("MoreTableViewCell", forIndexPath: indexPath)
        cell.textLabel?.text = self.moreArray[indexPath.row]
        cell.textLabel?.textColor = UIColor.darkGrayColor()
        cell.textLabel?.font = UIFont.systemFontOfSize(15.0)
        return cell
    }
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "Version alpha 1.0"
    }
}
