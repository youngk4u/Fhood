//
//  CancelOrdersViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 10/21/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
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
        
        let pushData: NSDictionary = NSDictionary(objects: ["Fhooder has cancelled your order.", "fhooderCancelled", "1"], forKeys: ["alert" as NSCopying, "type" as NSCopying, "number" as NSCopying])
        
        let uQuery = PFUser.query()!
        uQuery.whereKey("objectId", equalTo: Fhoodie.fhoodieID!)
        
        let iQuery = PFInstallation.query()!
        iQuery.whereKey("user", matchesQuery: uQuery)
        
        let push : PFPush = PFPush()
        push.setData(pushData as? [AnyHashable: Any])
        //push.setMessage("Fhooder has cancelled your order.")
        
        do {
            try push.send()
        } catch {
            print("Push didn't work")
        }
        
    }
    
    
    func cancelOrder (_ why: String) {
       
        if PFUser.current() != nil {
            let query = PFQuery(className: "Orders")
            let id = (Fhoodie.fhoodieOrderID)! as String
            query.getObjectInBackground(withId: id) { (order: PFObject?, error: Error?) -> Void in
                if error == nil && order != nil {
                    
                    order!["orderStatus"] = why
                    order?.saveInBackground()
                    
                    self.pushNotification()  
                    
                   self.performSegue(withIdentifier: "unwindToViewController1", sender: self)
                }
            NotificationCenter.default.post(name: Notification.Name(rawValue: "hooderOrderLoad"), object: nil)
                
            }
            
            
        }
        
    }
    

    @IBAction func fhoodieNoShow(_ sender: AnyObject) {
        self.reason = "No Show"
        cancelOrder(self.reason)
    }
    
    @IBAction func fhoodieCancelRequest(_ sender: AnyObject) {
        self.reason = "Cancel requested"
        cancelOrder(self.reason)
    }



    @IBAction func noReason(_ sender: AnyObject) {
        self.reason = "Cancel"
        cancelOrder(self.reason)
    }

    
    @IBAction func dontCancelButton(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
    }

}
