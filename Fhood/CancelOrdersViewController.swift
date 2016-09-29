//
//  CancelOrdersViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 10/21/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
//

import UIKit
import Parse

final class CancelOrdersViewController: UIViewController {
    
    var reason: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.85)
        
    }
    
    
    func pushNotification () {
        
        let pushData: NSDictionary = NSDictionary(objects: ["Fhooder has cancelled your order.", "fhooderCancelled", "1"], forKeys: ["alert", "type", "number"])
        
        let uQuery = PFUser.query()!
        uQuery.whereKey("objectId", equalTo: Fhoodie.fhoodieID!)
        
        let iQuery = PFInstallation.query()!
        iQuery.whereKey("user", matchesQuery: uQuery)
        
        let push : PFPush = PFPush()
        push.setData(pushData as [NSObject : AnyObject])
        //push.setMessage("Fhooder has cancelled your order.")
        
        do {
            try push.sendPush()
        } catch {
            print("Push didn't work")
        }
        
    }
    
    
    func cancelOrder (why: String) {
       
        if PFUser.currentUser() != nil {
            let query = PFQuery(className: "Orders")
            let id = (Fhoodie.fhoodieOrderID)! as String
            query.getObjectInBackgroundWithId(id) { (order: PFObject?, error: NSError?) -> Void in
                if error == nil && order != nil {
                    
                    order!["orderStatus"] = why
                    order?.saveInBackground()
                    
                    self.pushNotification()  
                    
                   self.performSegueWithIdentifier("unwindToViewController1", sender: self)
                }
            NSNotificationCenter.defaultCenter().postNotificationName("hooderOrderLoad", object: nil)
                
            }
            
            
        }
        
    }
    

    @IBAction func fhoodieNoShow(sender: AnyObject) {
        self.reason = "No Show"
        cancelOrder(self.reason)
    }
    
    @IBAction func fhoodieCancelRequest(sender: AnyObject) {
        self.reason = "Cancel requested"
        cancelOrder(self.reason)
    }



    @IBAction func noReason(sender: AnyObject) {
        self.reason = "Cancel"
        cancelOrder(self.reason)
    }

    
    @IBAction func dontCancelButton(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
