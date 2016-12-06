//
//  MoreViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 5/18/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
//

import UIKit

final class MoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let moreArray = ["Contact us", "Notifications", "About us", "Report users", "Help"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let logo = UIImage(named: "FhoodLogo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        // Configure reveal for this view
        let revealController = self.revealViewController()
        _ = revealController?.panGestureRecognizer()
        _ = revealController?.tapGestureRecognizer()

        // Account Icon
        let accountIcon = UIImage(named: "userCircle2")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: accountIcon, style: UIBarButtonItemStyle.plain, target: revealController, action: #selector(revealController?.revealToggle(_:)))
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moreArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "MoreTableViewCell", for: indexPath)
        cell.textLabel?.text = self.moreArray[indexPath.row]
        cell.textLabel?.textColor = UIColor.darkGray
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "Version alpha 1.0"
    }
}
