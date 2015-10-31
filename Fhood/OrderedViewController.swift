//
//  OrderedViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 7/26/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
//

import UIKit

final class OrderedViewController: UIViewController {

    @IBOutlet private var address: UILabel!
    @IBOutlet private var orderTime: UILabel!
    
    // Create Message Composer
    let messageComposer = MessageComposer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.hidden = true
        
        self.address.text = variables.address!
        //self.orderTime.text = "\(variables.orderTimeHour):\(variables.orderTimeMinute) \(variables.orderTimeAmpm)"
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
        
    }
    @IBAction func messageFhooder(sender: AnyObject) {
        
        // Make sure the device can send text messages
        if (messageComposer.canSendText()) {
            // Obtain a configured MFMessageComposeViewController
            let messageComposeVC = messageComposer.configuredMessageComposeViewController()
            
            // Present the configured MFMessageComposeViewController instance
            // Note that the dismissal of the VC will be handled by the messageComposer instance,
            // since it implements the appropriate delegate call-back
            presentViewController(messageComposeVC, animated: true, completion: nil)
        } else {
            // Let the user know if his/her device isn't able to send text messages
            let alert = UIAlertController(title: "Cannot Send Text Message", message:"Your device is not able to send text messages", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default) { _ in}
            alert.addAction(action)
            self.presentViewController(alert, animated: true){}
            
        }
    }
}
