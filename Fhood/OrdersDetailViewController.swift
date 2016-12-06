//
//  OrdersDetailViewController.swift
//  Fhood
//
//  Created by Young-hu Kim / Andrew Bancroft on 10/16/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
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
    
    var formatter = NumberFormatter()
    
    var orderQuantity: [Int] = []
    var orderName: [String] = []
    var orderPrice: [Double] = []
    var sum: [Double] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(OrdersDetailViewController.orderList(_:)), name: NSNotification.Name(rawValue: "OrderListLoad"), object: nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "OrderListLoad"), object: nil)
    
        // Timer
        self.navigationController?.navigationBar.topItem?.title = "Order #"
        let attributes = [
            NSForegroundColorAttributeName: UIColor.black,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 25)!
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        
        self.navigationItem.title = "Pending"
        
        
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
        formatter.numberStyle = .currency
        
        // TableView Delegates
        self.orderListTableView.delegate = self
        self.orderListTableView.dataSource = self

    }
    
    
    func orderList(_ notification: Notification) {
            
    
        if PFUser.current() != nil {
            let query = PFQuery(className: "Orders")
            //let id = (Fhoodie.fhoodieOrderID)! as String
            
            query.getObjectInBackground(withId: Fhoodie.fhoodieOrderID!) { (Ordered: PFObject?, error: Error?) -> Void in
                if error == nil && Ordered != nil {
        
                    let orderStatus = Ordered!["orderStatus"] as! String
                    
                    if orderStatus == "New" || orderStatus == "Accepted" {
                        self.orderQuantity = Ordered!["itemQty"] as! [Int]
                        self.orderName = Ordered!["itemNames"] as! [String]
                        self.orderPrice = Ordered!["itemPrices"] as! [Double]
                        
                        for i in 0..<self.orderName.count {
                            self.sum.append(self.orderPrice[i] * Double(self.orderQuantity[i]))
                        }
                        
                        let multiples = self.sum
                        
                        // Adds the total price
                        self.totalPrice.text = self.formatter.string(from: multiples.reduce(0, +) / Double(multiples.count) as NSNumber)
                        
                        if orderStatus == "New" {
                            self.messageButton.isHidden = true
                            self.acceptOrderButton.isHidden = false
                        }
                        else {
                            self.messageButton.isHidden = false
                            self.acceptOrderButton.isHidden = true
                        }
                        
                    }
                    else {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "fhooderOrderLoad"), object: nil)
                        self.performSegue(withIdentifier: "unwindToViewController1", sender: self)
                    }
                    
                    self.orderListTableView.reloadData()
                }
            
            }
            
        }
        
    }
    
    
    @IBAction func acceptOrderTapped(_ sender: UIButton) {
        self.acceptOrderButton.isHidden = true
        self.messageButton.isHidden = false
        
        if PFUser.current() != nil {
            let query = PFQuery(className: "Orders")
            
            query.getObjectInBackground(withId: Fhoodie.fhoodieOrderID!) { (Ordered: PFObject?, error: Error?) -> Void in
                if error == nil && Ordered != nil {
                    
                    Ordered!["orderStatus"] = "Accepted"
                    
                    Ordered?.saveInBackground()
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "fhooderOrderLoad"), object: nil)
                }
            }
        }
        
    }
    
    
    // TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderName.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderListTablecell") as! OrdersDetailTableViewCell
        
        // Cell Marginal lines on the left to stretch all the way to the left screen
        cell.layoutMargins = UIEdgeInsets.zero
        
        cell.orderQty.text = String(self.orderQuantity[indexPath.row])
        cell.orderName.text = self.orderName[indexPath.row]
        cell.orderPrice.text = formatter.string(from: self.orderPrice[indexPath.row] * Double(self.orderQuantity[indexPath.row]) as NSNumber)
        
        return cell
    }

    
    // Create a MessageComposer_ 
    let messageComposer = MessageComposer()
    
    @IBAction func sendTextMessageButtonTapped(_ sender: UIButton) {
        // Make sure the device can send text messages
        if (messageComposer.canSendText()) {
            // Obtain a configured MFMessageComposeViewController
            let messageComposeVC = messageComposer.configuredMessageComposeViewController()
            
            // Present the configured MFMessageComposeViewController instance
            // Note that the dismissal of the VC will be handled by the messageComposer instance,
            // since it implements the appropriate delegate call-back
            present(messageComposeVC, animated: true, completion: nil)
        } else {
            // Let the user know if his/her device isn't able to send text messages
            let alert = UIAlertController(title: "Cannot Send Text Message", message:"Your device is not able to send text messages", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { _ in}
            alert.addAction(action)
            self.present(alert, animated: true){}
            
        }
    }

}
