//
//  OrderedViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 7/26/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
//

import UIKit

final class OrderedViewController: UIViewController {


    @IBOutlet weak var orderedTime: UILabel!
    @IBOutlet weak var orderStatus: UILabel!
    @IBOutlet weak var fhooderName: UILabel!
    @IBOutlet private var address: UILabel!

    
    @IBOutlet weak var subtotal: UILabel!
    var subtotalPassed: String = ""

    @IBOutlet weak var taxesAndFees: UILabel!
    var taxesAndFeesPassed: String = ""

    @IBOutlet weak var total: UILabel!
    var totalPassed: String = ""

    
    @IBOutlet weak var qtyOne: UILabel!
    @IBOutlet weak var qtyTwo: UILabel!
    @IBOutlet weak var qtyThree: UILabel!
    @IBOutlet weak var qtyFour: UILabel!
    @IBOutlet weak var qtyFive: UILabel!
    @IBOutlet weak var qtySix: UILabel!
    @IBOutlet weak var qtySeven: UILabel!
    var qtyArray: [Int] = [0,0,0,0,0,0,0]
    
    @IBOutlet weak var itemOne: UILabel!
    @IBOutlet weak var itemTwo: UILabel!
    @IBOutlet weak var itemThree: UILabel!
    @IBOutlet weak var itemFour: UILabel!
    @IBOutlet weak var itemFive: UILabel!
    @IBOutlet weak var itemSix: UILabel!
    @IBOutlet weak var itemSeven: UILabel!
    var itemArray: [String] = ["","","","","","",""]
    
    @IBOutlet weak var priceOne: UILabel!
    @IBOutlet weak var priceTwo: UILabel!
    @IBOutlet weak var priceThree: UILabel!
    @IBOutlet weak var priceFour: UILabel!
    @IBOutlet weak var priceFive: UILabel!
    @IBOutlet weak var priceSix: UILabel!
    @IBOutlet weak var priceSeven: UILabel!
    var priceArray: [String] = ["","","","","","",""]
    
    @IBOutlet var navbar: UINavigationBar!
    
    // Create Message Composer
    let messageComposer = MessageComposer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Timer
        let attributes = [
            NSForegroundColorAttributeName: UIColor.blackColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 25)!
        ]
        self.navbar.titleTextAttributes = attributes
        self.navbar.topItem?.title = "00:07:52"

        
        //Hide tab bar
        self.tabBarController?.tabBar.hidden = true
        
        //self.orderTime.text = "Ordered at \(fhoodie.orderedTime)"
        self.fhooderName.text = variables.name!
        self.address.text = variables.address!
        
        
        //Passing values from previous View Controller
        if self.qtyArray[0] != 0 {
            self.qtyOne.text = String(self.qtyArray[0])
            self.itemOne.text = self.itemArray[0]
            self.priceOne.text = self.priceArray[0]
        }
        if self.qtyArray[1] != 0 {
            self.qtyTwo.text = String(self.qtyArray[1])
            self.itemTwo.text = self.itemArray[1]
            self.priceTwo.text = self.priceArray[1]
        }
        if self.qtyArray[2] != 0 {
            self.qtyThree.text = String(self.qtyArray[2])
            self.itemThree.text = self.itemArray[2]
            self.priceThree.text = self.priceArray[2]
        }
        if self.qtyArray[3] != 0 {
            self.qtyFour.text = String(self.qtyArray[3])
            self.itemFour.text = self.itemArray[3]
            self.priceFour.text = self.priceArray[3]
        }
        if self.qtyArray[4] != 0 {
            self.qtyFive.text = String(self.qtyArray[4])
            self.itemFive.text = self.itemArray[4]
            self.priceFive.text = self.priceArray[4]
        }
        if self.qtyArray[5] != 0 {
            self.qtySix.text = String(self.qtyArray[5])
            self.itemSix.text = self.itemArray[5]
            self.priceSix.text = self.priceArray[5]
        }
        if self.qtyArray[6] != 0 {
            self.qtySeven.text = String(self.qtyArray[6])
            self.itemSeven.text = self.itemArray[6]
            self.priceSeven.text = self.priceArray[6]
        }
        
        self.subtotal.text = self.subtotalPassed
        self.taxesAndFees.text = self.taxesAndFeesPassed
        self.total.text = self.totalPassed
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
