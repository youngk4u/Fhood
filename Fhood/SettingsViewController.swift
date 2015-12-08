//
//  SettingsViewController.swift
//  Fhood
//
//  Created by YOUNG on 11/11/15.
//  Copyright © 2015 YOUNG&YOUM. All rights reserved.
//

import UIKit
import Parse

final class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    var cellNameArray: [String] = ["Edit profile", "Email", "Phone number", "Password"]
    var cellIconArray: [String] = ["user", "email", "phone", "password"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Reload tableView data
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadList:",name:"loadSettings", object: nil)
                
        let nav = self.navigationController?.navigationBar
        
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor(),NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 20)!]
        
        self.title = "Settings"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    // Reload tableView function to use from other controllers
    func loadList(notification: NSNotification){
        self.tableView.reloadData()
    }

    @IBAction func closeSettings(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    // Table View
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellNameArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingsTableViewCell") as! SettingsTableViewCell
        
        cell.cellIcon.image = UIImage(named: self.cellIconArray[indexPath.row])
        
        // Display email, phoneNum if user has saved them in Parse
        if PFUser.currentUser()?.objectForKey("email") != nil && indexPath.row == 1 {
            cell.cellName.text = "\(PFUser.currentUser()!.objectForKey("email")!)"
            cell.cellName.textColor = UIColor.blackColor()
        }
        else if PFUser.currentUser()?.objectForKey("phone") != nil && indexPath.row == 2 {
            cell.cellName.text = "\(PFUser.currentUser()!.objectForKey("phone")!)"
            cell.cellName.textColor = UIColor.blackColor()
        }
        else {
            cell.cellName.text = self.cellNameArray[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedRow = indexPath.row
        
        if selectedRow == 0 {
            performSegueWithIdentifier("toProfile", sender: self)
        }
        
        else if selectedRow == 1 {
            performSegueWithIdentifier("toEmail", sender: self)
        }
        else if selectedRow == 2 {
            performSegueWithIdentifier("toPhoneNumber", sender: self)
        }
        else if selectedRow == 3 {
            
            
        }
     
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }



}
