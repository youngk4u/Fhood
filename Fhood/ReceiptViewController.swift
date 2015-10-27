//
//  ReceiptViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 10/26/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
//

import UIKit

class ReceiptViewController: UIViewController {
    
    @IBOutlet weak var totalDue: UILabel!
    
    @IBOutlet weak var quantityOne: UILabel!
    @IBOutlet weak var quantityTwo: UILabel!
    @IBOutlet weak var quantityThree: UILabel!
    @IBOutlet weak var quantityFour: UILabel!
    @IBOutlet weak var quantityFive: UILabel!
    @IBOutlet weak var quantitySix: UILabel!
    @IBOutlet weak var quantitySeven: UILabel!
    
    @IBOutlet weak var itemOne: UILabel!
    @IBOutlet weak var itemTwo: UILabel!
    @IBOutlet weak var itemThree: UILabel!
    @IBOutlet weak var itemFour: UILabel!
    @IBOutlet weak var itemFive: UILabel!
    @IBOutlet weak var itemSix: UILabel!
    @IBOutlet weak var itemSeven: UILabel!
    
    @IBOutlet weak var priceOne: UILabel!
    @IBOutlet weak var priceTwo: UILabel!
    @IBOutlet weak var priceThree: UILabel!
    @IBOutlet weak var priceFour: UILabel!
    @IBOutlet weak var priceFive: UILabel!
    @IBOutlet weak var priceSix: UILabel!
    @IBOutlet weak var priceSeven: UILabel!

    @IBOutlet weak var timePicker: UIDatePicker!
    
    var formatter = NSNumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.8)
        
        // Currency formatter
        self.formatter.numberStyle = .CurrencyStyle

        // Put the order list on the receipt
        for var x = 0; x < fhoodie.selectedItemCount!.count; x++ {
            if x == 0 && x < fhoodie.selectedItemCount!.count {
                self.quantityOne.text = String("\(fhoodie.selectedItemCount![0])")
                self.itemOne.text = fhoodie.selectedItemNames![0]
                self.priceOne.text = formatter.stringFromNumber(fhoodie.selectedItemPrices![0] * Double(fhoodie.selectedItemCount![0]))
            } else if x == 1 && x < fhoodie.selectedItemCount!.count {
                self.quantityTwo.text = String("\(fhoodie.selectedItemCount![1])")
                self.itemTwo.text = fhoodie.selectedItemNames![1]
                self.priceTwo.text = formatter.stringFromNumber(fhoodie.selectedItemPrices![1] * Double(fhoodie.selectedItemCount![1]))
            } else if x == 2 && x < fhoodie.selectedItemCount!.count {
                self.quantityThree.text = String("\(fhoodie.selectedItemCount![2])")
                self.itemThree.text = fhoodie.selectedItemNames![2]
                self.priceThree.text = formatter.stringFromNumber(fhoodie.selectedItemPrices![2] * Double(fhoodie.selectedItemCount![2]))
            } else if x == 3 && x < fhoodie.selectedItemCount!.count {
                self.quantityFour.text = String("\(fhoodie.selectedItemCount![3])")
                self.itemFour.text = fhoodie.selectedItemNames![3]
                self.priceFour.text = formatter.stringFromNumber(fhoodie.selectedItemPrices![3] * Double(fhoodie.selectedItemCount![3]))
            } else if x == 4 && x < fhoodie.selectedItemCount!.count {
                self.quantityFive.text = String("\(fhoodie.selectedItemCount![4])")
                self.itemFive.text = fhoodie.selectedItemNames![4]
                self.priceFive.text = formatter.stringFromNumber(fhoodie.selectedItemPrices![4] * Double(fhoodie.selectedItemCount![4]))
            } else if x == 5 && x < fhoodie.selectedItemCount!.count {
                self.quantitySix.text = String("\(fhoodie.selectedItemCount![5])")
                self.itemSix.text = fhoodie.selectedItemNames![5]
                self.priceSix.text = formatter.stringFromNumber(fhoodie.selectedItemPrices![5] * Double(fhoodie.selectedItemCount![5]))
            } else if x == 6 && x < fhoodie.selectedItemCount!.count {
                self.quantitySeven.text = String("\(fhoodie.selectedItemCount![6])")
                self.itemSeven.text = fhoodie.selectedItemNames![6]
                self.priceSeven.text = formatter.stringFromNumber(fhoodie.selectedItemPrices![6] * Double(fhoodie.selectedItemCount![6]))
            } else {
                return
            }
        }
        
        self.totalDue.text = formatter.stringFromNumber(fhoodie.selectedTotalItemPrice!)


    
        // Time Picker
        self.timePicker.datePickerMode = UIDatePickerMode.Time // use time only
        let currentDate = NSDate()  // get the current date
        let newDate = NSDate(timeInterval: (15 * 60), sinceDate: currentDate)  // add 15 minutes
        self.timePicker.minimumDate = newDate // set the current date/time as a minimum
        self.timePicker.date = newDate // defaults to current time but shows how to use it.

    }

    // Close receipt
    @IBAction func closeReceiptView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
