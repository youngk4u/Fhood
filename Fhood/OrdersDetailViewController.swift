//
//  OrdersDetailViewController.swift
//  Fhood
//
//  Created by Young-hu Kim / Andrew Bancroft on 10/16/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
//

import UIKit

class OrdersDetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Timer
        self.navigationController?.navigationBar.topItem?.title = "Order #"
        let attributes = [
            NSForegroundColorAttributeName: UIColor.blackColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 25)!
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        
        self.navigationItem.title = "00:07:52"
        
    }
    
    // Create a MessageComposer
    let messageComposer = MessageComposer()
    
    @IBAction func sendTextMessageButtonTapped(sender: UIButton) {
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
