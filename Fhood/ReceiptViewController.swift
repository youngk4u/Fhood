//
//  ReceiptViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 10/26/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
//

import UIKit
import Parse

final class ReceiptViewController: UIViewController {
    
    @IBOutlet weak var fhooderName: UILabel!
    
    @IBOutlet weak var subTotal: UILabel!
    @IBOutlet weak var taxesAndFees: UILabel!
    @IBOutlet weak var totalAmountDue: UILabel!
    
    @IBOutlet weak var quantityOne: UILabel!
    @IBOutlet weak var quantityTwo: UILabel!
    @IBOutlet weak var quantityThree: UILabel!
    @IBOutlet weak var quantityFour: UILabel!
    @IBOutlet weak var quantityFive: UILabel!
    @IBOutlet weak var quantitySix: UILabel!
    @IBOutlet weak var quantitySeven: UILabel!
    var quantityArray: [Int] = [0,0,0,0,0,0,0]
    
    @IBOutlet weak var itemOne: UILabel!
    @IBOutlet weak var itemTwo: UILabel!
    @IBOutlet weak var itemThree: UILabel!
    @IBOutlet weak var itemFour: UILabel!
    @IBOutlet weak var itemFive: UILabel!
    @IBOutlet weak var itemSix: UILabel!
    @IBOutlet weak var itemSeven: UILabel!
    var itemNameArray: [String] = ["","","","","","",""]
    
    @IBOutlet weak var priceOne: UILabel!
    @IBOutlet weak var priceTwo: UILabel!
    @IBOutlet weak var priceThree: UILabel!
    @IBOutlet weak var priceFour: UILabel!
    @IBOutlet weak var priceFive: UILabel!
    @IBOutlet weak var priceSix: UILabel!
    @IBOutlet weak var priceSeven: UILabel!
    var priceTextArray: [String] = ["","","","","","",""]

    @IBOutlet weak var timePicker: UIDatePicker!
    
    var currentDate: NSDate!
    var newDate: NSDate!
    var newDate2: NSDate!
    var closeDate: NSDate!
    
    var formatter = NSNumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.8)
        
        // Currency formatter
        self.formatter.numberStyle = .CurrencyStyle
        
        self.fhooderName.text = Fhooder.shopName!

        // Put the order list on the receipt
        for var x = 0; x < Fhoodie.selectedItemCount!.count; x++ {
            if x == 0 && x < Fhoodie.selectedItemCount!.count {
                self.quantityOne.text = String("\(Fhoodie.selectedItemCount![0])")
                self.quantityArray[0] = Fhoodie.selectedItemCount![0]
                self.itemOne.text = Fhoodie.selectedItemNames![0]
                self.itemNameArray[0] = Fhoodie.selectedItemNames![0]
                self.priceOne.text = formatter.stringFromNumber(Fhoodie.selectedItemPrices![0] * Double(Fhoodie.selectedItemCount![0]))
                self.priceTextArray[0] = self.priceOne.text!
            } else if x == 1 && x < Fhoodie.selectedItemCount!.count {
                self.quantityTwo.text = String("\(Fhoodie.selectedItemCount![1])")
                self.quantityArray[1] = Fhoodie.selectedItemCount![1]
                self.itemTwo.text = Fhoodie.selectedItemNames![1]
                self.itemNameArray[1] = Fhoodie.selectedItemNames![1]
                self.priceTwo.text = formatter.stringFromNumber(Fhoodie.selectedItemPrices![1] * Double(Fhoodie.selectedItemCount![1]))
                self.priceTextArray[1] = self.priceTwo.text!
            } else if x == 2 && x < Fhoodie.selectedItemCount!.count {
                self.quantityThree.text = String("\(Fhoodie.selectedItemCount![2])")
                self.quantityArray[2] = Fhoodie.selectedItemCount![2]
                self.itemThree.text = Fhoodie.selectedItemNames![2]
                self.itemNameArray[2] = Fhoodie.selectedItemNames![2]
                self.priceThree.text = formatter.stringFromNumber(Fhoodie.selectedItemPrices![2] * Double(Fhoodie.selectedItemCount![2]))
                self.priceTextArray[2] = self.priceThree.text!
            } else if x == 3 && x < Fhoodie.selectedItemCount!.count {
                self.quantityFour.text = String("\(Fhoodie.selectedItemCount![3])")
                self.quantityArray[3] = Fhoodie.selectedItemCount![3]
                self.itemFour.text = Fhoodie.selectedItemNames![3]
                self.itemNameArray[3] = Fhoodie.selectedItemNames![3]
                self.priceFour.text = formatter.stringFromNumber(Fhoodie.selectedItemPrices![3] * Double(Fhoodie.selectedItemCount![3]))
                self.priceTextArray[3] = self.priceFour.text!
            } else if x == 4 && x < Fhoodie.selectedItemCount!.count {
                self.quantityFive.text = String("\(Fhoodie.selectedItemCount![4])")
                self.quantityArray[4] = Fhoodie.selectedItemCount![4]
                self.itemFive.text = Fhoodie.selectedItemNames![4]
                self.itemNameArray[4] = Fhoodie.selectedItemNames![4]
                self.priceFive.text = formatter.stringFromNumber(Fhoodie.selectedItemPrices![4] * Double(Fhoodie.selectedItemCount![4]))
                self.priceTextArray[4] = self.priceFive.text!
            } else if x == 5 && x < Fhoodie.selectedItemCount!.count {
                self.quantitySix.text = String("\(Fhoodie.selectedItemCount![5])")
                self.quantityArray[5] = Fhoodie.selectedItemCount![5]
                self.itemSix.text = Fhoodie.selectedItemNames![5]
                self.itemNameArray[5] = Fhoodie.selectedItemNames![5]
                self.priceSix.text = formatter.stringFromNumber(Fhoodie.selectedItemPrices![5] * Double(Fhoodie.selectedItemCount![5]))
                self.priceTextArray[5] = self.priceSix.text!
            } else if x == 6 && x < Fhoodie.selectedItemCount!.count {
                self.quantitySeven.text = String("\(Fhoodie.selectedItemCount![6])")
                self.quantityArray[6] = Fhoodie.selectedItemCount![6]
                self.itemSeven.text = Fhoodie.selectedItemNames![6]
                self.itemNameArray[6] = Fhoodie.selectedItemNames![6]
                self.priceSeven.text = formatter.stringFromNumber(Fhoodie.selectedItemPrices![6] * Double(Fhoodie.selectedItemCount![6]))
                self.priceTextArray[6] = self.priceSeven.text!
            } else {
                return
            }
        }
        
        // Stripe fee (2.9% + 30 cents) and taxes (7.1% - Stripe) added to every order
        self.subTotal.text = formatter.stringFromNumber(Fhoodie.selectedTotalItemPrice!)
        self.taxesAndFees.text = formatter.stringFromNumber(Fhoodie.selectedTotalItemPrice! * 0.1 + 0.3)
        Fhoodie.totalDue = Fhoodie.selectedTotalItemPrice! + Fhoodie.selectedTotalItemPrice! * 0.1 + 0.3
        self.totalAmountDue.text = formatter.stringFromNumber(Fhoodie.totalDue!)

        
        
        let query = PFQuery(className: "Fhooder")
        query.getObjectInBackgroundWithId(Fhooder.objectID!) { (fhooder: PFObject?, error: NSError?) -> Void in
            if error == nil && fhooder != nil {
                
                
                // Time Picker
                self.timePicker.datePickerMode = UIDatePickerMode.Time // use time only
                
                var openTime : String!
                var closeTime : String!
                
                openTime = fhooder!.valueForKey("openTime") as? String
                closeTime = fhooder!.valueForKey("closeTime") as? String
                
                // Get open time and close time from Parse
                if  openTime == "Now" {
                    self.currentDate = NSDate()
                }
                else {
                    
                    let timeFormatter = NSDateFormatter()
                    timeFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
                    timeFormatter.dateFormat = "hh:mm a"
                    
                    let time = timeFormatter.dateFromString(openTime)
                    self.currentDate = time
                    
                    self.newDate = NSDate(timeInterval: (15 * 60), sinceDate: self.currentDate)  // add 15 minutes

                    self.timePicker.minimumDate = self.newDate // set the current date/time as a minimum
                }
                
                if  closeTime == "Later" {
                    
                }
                else {
                    
                    let timeFormatter = NSDateFormatter()
                    timeFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
                    timeFormatter.dateFormat = "hh:mm a"
                    
                    let time = timeFormatter.dateFromString(closeTime)
                    self.closeDate = time
                    
                    self.newDate2 = NSDate(timeInterval: (5 * 60), sinceDate: self.closeDate)
                    self.timePicker.maximumDate = self.newDate2

                }
                
                
                let compareResult = self.newDate.compare(NSDate())
                
                if compareResult == NSComparisonResult.OrderedAscending {
                    self.timePicker.date = self.newDate // defaults to current time but shows how to use it.
                }
                else {
                    self.timePicker.date = NSDate()
                }

            }
            
        }
        
        

    }
    
    @IBAction func completeOrder(sender: AnyObject) {
        let alert = UIAlertController(title: "Confirm your order", message:"The total amount of \(self.totalAmountDue.text!) will be charged to your account. Would you like to proceed?", preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "Cancel", style: .Default) { _ in}
        let proceed = UIAlertAction(title: "Proceed", style: .Default) { (action: UIAlertAction!) -> () in
            
            HUD.show()
            
            let user = PFUser.query()
            let userID = PFUser.currentUser()!.objectId!
            let fhooderID = Fhooder.objectID!
            
            user?.getObjectInBackgroundWithId(userID, block: { (user: PFObject?, error: NSError?) -> Void in
                
                let order = PFObject(className: "Orders")
                order["userId"] = userID
                order["fhooderId"] = fhooderID
                order["itemsId"] = Fhoodie.selectedItemObjectId!
                order["itemQty"] = Fhoodie.selectedItemCount!
                
                order.saveInBackgroundWithBlock({ (success: Bool, error2: NSError?) -> Void in
                    if success {
                        
                        let relation = user?.relationForKey("orders")
                        relation!.addObject(order)
                        
                        do {
                            try user?.save()
                            
                            let alert = UIAlertController(title: "Order completed", message:"Your order is submitted! Please wait for the confirmation.", preferredStyle: .Alert)
                            let added = UIAlertAction(title: "Ok!", style: .Default) { _ in}
                            alert.addAction(added)
                            self.presentViewController(alert, animated: true, completion: nil)
                            
                            
                            let query = PFQuery(className: "Fhooder")
                            query.getObjectInBackgroundWithId(fhooderID, block: { (fhooder: PFObject?, error: NSError?) -> Void in
                  
                                let relation2 = fhooder?.relationForKey("orders")
                                relation2!.addObject(order)
                                
                                do {
                                    try fhooder?.save()
                                }
                                catch {
                                    print(error)
                                }
                                
                                let relation3 = fhooder?.relationForKey("items")
                                let query2 = relation3?.query()
                                
                                query2?.orderByAscending("createdAt")
                                query2?.findObjectsInBackgroundWithBlock({ (items: [PFObject]?, error3: NSError?) -> Void in
                                    
                                    if error3 == nil {
                                        
                                        var i = 0
                                        for item in items! {
                                            
                                            let id = item.objectId!
                                            
                                            if Fhoodie.selectedItemObjectId![i] == id {
                                                
                                                let dailyQty = item["dailyQuantity"] as? Int
                                                item["dailyQuantity"] = dailyQty! - Fhoodie.selectedItemCount![i]
                                                
                                                item.saveInBackground()
                                                
                                                if i < ((Fhoodie.selectedItemObjectId?.count)! - 1) {
                                                    i++
                                                }
                                            }
                                        }
                                        
                                    }
                                })
                            })

                            
                            
                        }
                        catch {
                            let alert = UIAlertController(title: "", message:"There was an error!", preferredStyle: .Alert)
                            let error = UIAlertAction(title: "Ok", style: .Default) { _ in}
                            alert.addAction(error)
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                    }
                    
                })
                
            })
            
            self.performSegueWithIdentifier("toOrderedView", sender: self)
        }
        alert.addAction(cancel)
        alert.addAction(proceed)
        self.presentViewController(alert, animated: true){}
        
        HUD.dismiss()
    }
    
    //Passing order list values to the next View Controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "toOrderedView") {
            let orderedVC = segue.destinationViewController as! OrderedViewController;
            
            orderedVC.qtyArray = self.quantityArray
            orderedVC.itemArray = self.itemNameArray
            orderedVC.priceArray = self.priceTextArray
            
            orderedVC.subtotalPassed = self.subTotal.text!
            orderedVC.taxesAndFeesPassed = self.taxesAndFees.text!
            orderedVC.totalPassed = self.totalAmountDue.text!
        }
    }

    // Close receipt
    @IBAction func closeReceiptView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
