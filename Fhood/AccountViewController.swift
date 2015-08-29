//
//  AccountViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 6/2/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
//

import UIKit

final class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var array : [String] = ["   History                                           >",
                            "   Photos                                           >",
                            "   Log out", "",""]
    var selectedRow = -1
    
    @IBOutlet weak var fhooderSwitch: UISwitch!
    @IBOutlet weak var tableView2: UITableView!
    @IBOutlet weak var joinWindow: UIView!
    @IBOutlet weak var signUpButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView2.delegate = self
        self.tableView2.dataSource = self
        self.tableView2.layoutMargins = UIEdgeInsetsZero
        
        // Connect to switch function
        self.fhooderSwitch.addTarget(self, action: "toggleSwitch:", forControlEvents: UIControlEvents.ValueChanged)
    
        // Make join window and sign up button round
        self.joinWindow.layer.cornerRadius = 5
        self.signUpButton.layer.cornerRadius = 5

        
    }

    func tableView(tableView2: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array.count
    }
    
    func tableView(tableView2: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Try to get a cell to reuse
        let cell: UITableViewCell = tableView2.dequeueReusableCellWithIdentifier("Tablecell2", forIndexPath: indexPath)
        
        // Customize cell
        cell.textLabel?.text = self.array[indexPath.row]
        cell.textLabel?.textColor = UIColor.darkGrayColor()
        cell.textLabel?.font = UIFont.systemFontOfSize(15.0)
        // Cell Marginal lines on the left to stretch all the way to the left screen
        cell.layoutMargins = UIEdgeInsetsZero
        
        return cell
    }
    
    func tableView(tableView2: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.selectedRow = indexPath.row
  
        if self.selectedRow == 0 {
        self.performSegueWithIdentifier("toHistoryView", sender: tableView2)
        }
        else if self.selectedRow == 1 {
        self.performSegueWithIdentifier("toPhotoView", sender: tableView2)
        }
    }
    
    func toggleSwitch(sender: UISwitch) {
        
        UIView.animateWithDuration(0.5, animations: {
            
            if self.joinWindow.alpha == 0 {
                self.joinWindow.alpha = 1
            }
            else {
                self.joinWindow.alpha = 0
            }
        })
                
    }
    
}
