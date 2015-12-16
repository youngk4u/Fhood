//
//  ReceiptViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 10/26/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
//

import UIKit

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
    
    var formatter = NSNumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.8)
        
        // Currency formatter
        self.formatter.numberStyle = .CurrencyStyle
        
        self.fhooderName.text = Fhooder.shopName!

        // Put the order list on the receipt
        for var x = 0; x < fhoodie.selectedItemCount!.count; x++ {
            if x == 0 && x < fhoodie.selectedItemCount!.count {
                self.quantityOne.text = String("\(fhoodie.selectedItemCount![0])")
                self.quantityArray[0] = fhoodie.selectedItemCount![0]
                self.itemOne.text = fhoodie.selectedItemNames![0]
                self.itemNameArray[0] = fhoodie.selectedItemNames![0]
                self.priceOne.text = formatter.stringFromNumber(fhoodie.selectedItemPrices![0] * Double(fhoodie.selectedItemCount![0]))
                self.priceTextArray[0] = self.priceOne.text!
            } else if x == 1 && x < fhoodie.selectedItemCount!.count {
                self.quantityTwo.text = String("\(fhoodie.selectedItemCount![1])")
                self.quantityArray[1] = fhoodie.selectedItemCount![1]
                self.itemTwo.text = fhoodie.selectedItemNames![1]
                self.itemNameArray[1] = fhoodie.selectedItemNames![1]
                self.priceTwo.text = formatter.stringFromNumber(fhoodie.selectedItemPrices![1] * Double(fhoodie.selectedItemCount![1]))
                self.priceTextArray[1] = self.priceTwo.text!
            } else if x == 2 && x < fhoodie.selectedItemCount!.count {
                self.quantityThree.text = String("\(fhoodie.selectedItemCount![2])")
                self.quantityArray[2] = fhoodie.selectedItemCount![2]
                self.itemThree.text = fhoodie.selectedItemNames![2]
                self.itemNameArray[2] = fhoodie.selectedItemNames![2]
                self.priceThree.text = formatter.stringFromNumber(fhoodie.selectedItemPrices![2] * Double(fhoodie.selectedItemCount![2]))
                self.priceTextArray[2] = self.priceThree.text!
            } else if x == 3 && x < fhoodie.selectedItemCount!.count {
                self.quantityFour.text = String("\(fhoodie.selectedItemCount![3])")
                self.quantityArray[3] = fhoodie.selectedItemCount![3]
                self.itemFour.text = fhoodie.selectedItemNames![3]
                self.itemNameArray[3] = fhoodie.selectedItemNames![3]
                self.priceFour.text = formatter.stringFromNumber(fhoodie.selectedItemPrices![3] * Double(fhoodie.selectedItemCount![3]))
                self.priceTextArray[3] = self.priceFour.text!
            } else if x == 4 && x < fhoodie.selectedItemCount!.count {
                self.quantityFive.text = String("\(fhoodie.selectedItemCount![4])")
                self.quantityArray[4] = fhoodie.selectedItemCount![4]
                self.itemFive.text = fhoodie.selectedItemNames![4]
                self.itemNameArray[4] = fhoodie.selectedItemNames![4]
                self.priceFive.text = formatter.stringFromNumber(fhoodie.selectedItemPrices![4] * Double(fhoodie.selectedItemCount![4]))
                self.priceTextArray[4] = self.priceFive.text!
            } else if x == 5 && x < fhoodie.selectedItemCount!.count {
                self.quantitySix.text = String("\(fhoodie.selectedItemCount![5])")
                self.quantityArray[5] = fhoodie.selectedItemCount![5]
                self.itemSix.text = fhoodie.selectedItemNames![5]
                self.itemNameArray[5] = fhoodie.selectedItemNames![5]
                self.priceSix.text = formatter.stringFromNumber(fhoodie.selectedItemPrices![5] * Double(fhoodie.selectedItemCount![5]))
                self.priceTextArray[5] = self.priceSix.text!
            } else if x == 6 && x < fhoodie.selectedItemCount!.count {
                self.quantitySeven.text = String("\(fhoodie.selectedItemCount![6])")
                self.quantityArray[6] = fhoodie.selectedItemCount![6]
                self.itemSeven.text = fhoodie.selectedItemNames![6]
                self.itemNameArray[6] = fhoodie.selectedItemNames![6]
                self.priceSeven.text = formatter.stringFromNumber(fhoodie.selectedItemPrices![6] * Double(fhoodie.selectedItemCount![6]))
                self.priceTextArray[6] = self.priceSeven.text!
            } else {
                return
            }
        }
        
        // Stripe fee (2.9% + 30 cents) and taxes (7.1% - Stripe) added to every order
        self.subTotal.text = formatter.stringFromNumber(fhoodie.selectedTotalItemPrice!)
        self.taxesAndFees.text = formatter.stringFromNumber(fhoodie.selectedTotalItemPrice! * 0.1 + 0.3)
        fhoodie.totalDue = fhoodie.selectedTotalItemPrice! + fhoodie.selectedTotalItemPrice! * 0.1 + 0.3
        self.totalAmountDue.text = formatter.stringFromNumber(fhoodie.totalDue!)


    
        // Time Picker
        self.timePicker.datePickerMode = UIDatePickerMode.Time // use time only
        let currentDate = NSDate()  // get the current date
        let newDate = NSDate(timeInterval: (15 * 60), sinceDate: currentDate)  // add 15 minutes
        self.timePicker.minimumDate = newDate // set the current date/time as a minimum
        self.timePicker.date = newDate // defaults to current time but shows how to use it.

    }
    
    @IBAction func completeOrder(sender: AnyObject) {
        let alert = UIAlertController(title: "Confirm your order", message:"The total amount of \(self.totalAmountDue.text!) will be charged to your account. Would you like to proceed?", preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "Cancel", style: .Default) { _ in}
        let proceed = UIAlertAction(title: "Proceed", style: .Default) { (action: UIAlertAction!) -> () in
            self.performSegueWithIdentifier("toOrderedView", sender: self)
        }
        alert.addAction(cancel)
        alert.addAction(proceed)
        self.presentViewController(alert, animated: true){}
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
