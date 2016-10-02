//
//  OrdersDetailViewController.swift
//  Fhood
//
//  Created by Young-hu Kim / Andrew Bancroft on 10/16/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
//

import UIKit
import Parse

final class OrdersDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var orderListTableView: UITableView!
    
    @IBOutlet weak var fhoodieImage: UIImageView!
    @IBOutlet weak var fhoodieName: UILabel!
    @IBOutlet weak var fhoodieRating: UIImageView!
    @IBOutlet weak var fhoodieReview: UILabel!
    
    @IBOutlet weak var totalPrice: UILabel!
    
    @IBOutlet weak var specialInstructions: UITextView!
    
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var acceptOrderButton: UIButton!
    
    var formatter = NSNumberFormatter()
    
    var orderQuantity: [Int] = []
    var orderName: [String] = []
    var orderPrice: [Double] = []
    var sum: [Double] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(OrdersDetailViewController.orderList(_:)), name: "OrderListLoad", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("OrderListLoad", object: nil)
    
        // Timer
        self.navigationController?.navigationBar.topItem?.title = "Order #"
        let attributes = [
            NSForegroundColorAttributeName: UIColor.blackColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 25)!
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        
        self.navigationItem.title = "Pending"
        
        self.messageButton.hidden = true
        
        
        self.fhoodieName.text = Fhoodie.fhoodieFirstName
        
        let picture = Fhoodie.fhoodiePhoto
        let fhoodieImage = UIImageView(image: picture)
        fhoodieImage.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        fhoodieImage.layer.masksToBounds = false
        fhoodieImage.layer.cornerRadius = 13
        fhoodieImage.layer.cornerRadius = fhoodieImage.frame.size.height/2
        fhoodieImage.clipsToBounds = true
        
        self.fhoodieImage.addSubview(fhoodieImage)
        
        // Currency formattec
        formatter.numberStyle = .CurrencyStyle
        
        // TableView Delegates
        self.orderListTableView.delegate = self
        self.orderListTableView.dataSource = self

    }
    
    
    func orderList(notification: NSNotification) {
            
    
        if PFUser.currentUser() != nil {
            let query = PFQuery(className: "Orders")
            //let id = (Fhoodie.fhoodieOrderID)! as String
            
            query.getObjectInBackgroundWithId(Fhoodie.fhoodieOrderID!) { (Ordered: PFObject?, error: NSError?) -> Void in
            if error == nil && Ordered != nil {
    
                let orderStatus = Ordered!["orderStatus"] as! String
                
                if orderStatus == "Made" || orderStatus == "Confirmed" {
                    self.orderQuantity = Ordered!["itemQty"] as! [Int]
                    self.orderName = Ordered!["itemNames"] as! [String]
                    self.orderPrice = Ordered!["itemPrices"] as! [Double]
                    
                    for i in 0..<self.orderName.count {
                        self.sum.append(self.orderPrice[i] * Double(self.orderQuantity[i]))
                    }
                    
                    let multiples = self.sum
                    
                    // Adds the total price
                    self.totalPrice.text = self.formatter.stringFromNumber(multiples.reduce(0, combine: +) / Double(multiples.count))
                    
                }
                else {
                    NSNotificationCenter.defaultCenter().postNotificationName("fhooderOrderLoad", object: nil)
                    self.performSegueWithIdentifier("unwindToViewController1", sender: self)
                }
                
                self.orderListTableView.reloadData()
            }
            
            }
            
        }
        
    }
    
    
    @IBAction func acceptOrderTapped(sender: UIButton) {
        self.acceptOrderButton.hidden = true
        self.messageButton.hidden = false
        
    }
    
    
    // TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderName.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("OrderListTablecell") as! OrdersDetailTableViewCell
        
        // Cell Marginal lines on the left to stretch all the way to the left screen
        cell.layoutMargins = UIEdgeInsetsZero
        
        cell.orderQty.text = String(self.orderQuantity[indexPath.row])
        cell.orderName.text = self.orderName[indexPath.row]
        cell.orderPrice.text = formatter.stringFromNumber(self.orderPrice[indexPath.row] * Double(self.orderQuantity[indexPath.row]))
        
        return cell
    }

    
    // Create a MessageComposer_ 
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
