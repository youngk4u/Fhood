//
//  SettingsViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 11/11/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
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
        NotificationCenter.default.addObserver(self, selector: #selector(SettingsViewController.loadList(_:)),name:NSNotification.Name(rawValue: "loadSettings"), object: nil)
                
        let nav = self.navigationController?.navigationBar
        
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black,NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 20)!]
        
        self.title = "Settings"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    // Reload tableView function to use from other controllers
    func loadList(_ notification: Notification){
        self.tableView.reloadData()
    }

    @IBAction func closeSettings(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    // Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell") as! SettingsTableViewCell
        
        cell.cellIcon.image = UIImage(named: self.cellIconArray[indexPath.row])
        
        // Display email, phoneNum if user has saved them in Parse
        if PFUser.current()?.object(forKey: "email") != nil && indexPath.row == 1 {
            cell.cellName.text = "\(PFUser.current()!.object(forKey: "email")!)"
            cell.cellName.textColor = UIColor.black
        }
        else if PFUser.current()?.object(forKey: "phone") != nil && indexPath.row == 2 {
            cell.cellName.text = "\(PFUser.current()!.object(forKey: "phone")!)"
            cell.cellName.textColor = UIColor.black
        }
        else {
            cell.cellName.text = self.cellNameArray[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedRow = indexPath.row
        
        if selectedRow == 0 {
            performSegue(withIdentifier: "toProfile", sender: self)
        }
        
        else if selectedRow == 1 {
            performSegue(withIdentifier: "toEmail", sender: self)
        }
        else if selectedRow == 2 {
            performSegue(withIdentifier: "toPhoneNumber", sender: self)
        }
        else if selectedRow == 3 {
            
            
        }
     
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func logOut(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "", message:"Are you sure you want to log out?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .default) { _ in}
        let logout = UIAlertAction(title: "Log out", style: .default) { (action: UIAlertAction!) -> () in
            PFUser.logOutInBackground { error in
                Fhooder.fhooderSignedIn = false
                Router.route(true)
            }
        }
        alert.addAction(cancel)
        alert.addAction(logout)
        self.present(alert, animated: true){}
        
        
    }


}
