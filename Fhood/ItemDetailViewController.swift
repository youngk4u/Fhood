//
//  ItemDetailViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 10/23/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
//

import UIKit

class ItemDetailViewController: UIViewController {
    
    
    @IBOutlet var detailView: UIView!
    @IBOutlet var detailImage: UIImageView!
    @IBOutlet var detailBackImage: UIImageView!
    @IBOutlet var detailPreference: UIView!
    var preferenceSet: [String] = ["Aorganic", "Bvegan", "Cglutenfree", "Dnutsfree", "Esoyfree", "Fmsgfree", "Gdairyfree", "Hlowsodium"]
    
    @IBOutlet var imageOne: UIImageView!
    @IBOutlet var imageTwo: UIImageView!
    @IBOutlet var imageThree: UIImageView!
    @IBOutlet var imageFour: UIImageView!
    @IBOutlet var imageFive: UIImageView!
    @IBOutlet var imageSix: UIImageView!
    @IBOutlet var imageSeven: UIImageView!
    @IBOutlet var imageEight: UIImageView!
    
    @IBOutlet var detailDescription: UILabel!
    @IBOutlet var detailIngredients: UILabel!
    @IBOutlet var detailTitle: UILabel!
    @IBOutlet var detailPrice: UILabel!
    
    
    @IBOutlet var dailyQtyStepper: UIStepper!
    @IBOutlet var dailyQty: UILabel!
    var quantityAmount : Int = 0

    
    @IBOutlet var maxOrderLimitStepper: UIStepper!
    @IBOutlet var maxOrderLimit: UILabel!
    var maxOrderLimitAmount : Int = 0
    
    @IBOutlet var timeIntervalStepper: UIStepper!
    @IBOutlet var timeInterval: UILabel!
    var timeIntervalAmount : Int = 0
    
    var formatter = NSNumberFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.8)
        
        // Currency formatter
        self.formatter.numberStyle = .CurrencyStyle
        
        self.detailTitle.text = variables.itemNames![variables.itemIndex!]
        self.detailImage.image = UIImage(named: variables.itemNames![variables.itemIndex!])
        self.detailPrice.text = formatter.stringFromNumber(variables.itemPrices![variables.itemIndex!])
        self.detailDescription.text = "Description: " + variables.itemDescription![variables.itemIndex!]
        self.detailIngredients.text = "Ingredients: " + variables.itemIngredients![variables.itemIndex!]
        
        
        // Set the prefernece images sorted
        for var i = 0; i < 8; i++ {
            
            if variables.itemPrefernce![variables.itemIndex!][i] == 0 {
                self.preferenceSet[i] = ""
            }
        }
        
        self.preferenceSet.sortInPlace { (a, b) -> Bool in
            if a.isEmpty {
                return false
            } else if b.isEmpty {
                return true
            } else {
                return a.localizedCaseInsensitiveCompare(b) == .OrderedAscending
            }
        }
        
        if self.preferenceSet[0] != "" {
            self.imageOne.image = UIImage(named: self.preferenceSet[0])
        }
        if self.preferenceSet[1] != "" {
            self.imageTwo.image = UIImage(named: self.preferenceSet[1])
        }
        if self.preferenceSet[2] != "" {
            self.imageThree.image = UIImage(named: self.preferenceSet[2])
        }
        if self.preferenceSet[3] != "" {
            self.imageFour.image = UIImage(named: self.preferenceSet[3])
        }
        if self.preferenceSet[4] != "" {
            self.imageFive.image = UIImage(named: self.preferenceSet[4])
        }
        if self.preferenceSet[5] != "" {
            self.imageSix.image = UIImage(named: self.preferenceSet[5])
        }
        if self.preferenceSet[6] != "" {
            self.imageSeven.image = UIImage(named: self.preferenceSet[6])
        }
        if self.preferenceSet[7] != "" {
            self.imageEight.image = UIImage(named: self.preferenceSet[7])
        }

        
        self.quantityAmount = variables.dailyQuantity![variables.itemIndex!]
        self.dailyQtyStepper.value = Double(variables.dailyQuantity![variables.itemIndex!])
        self.dailyQty.text = "\(Int(self.dailyQtyStepper.value))"
        
        self.maxOrderLimitAmount = variables.maxOrderLimit![variables.itemIndex!]
        self.maxOrderLimitStepper.value = Double((variables.maxOrderLimit![variables.itemIndex!]))
        self.maxOrderLimit.text = "\(Int(self.maxOrderLimitStepper.value))"
        
        self.timeIntervalAmount = variables.timeInterval![variables.itemIndex!]
        self.timeIntervalStepper.value = Double(self.timeIntervalAmount / 5)
        self.timeInterval.text = "\(Int(self.timeIntervalStepper.value) * 5) Min"
        
        
        
        
        // Detail view image tap to see ingredients
        let tapGesture = UITapGestureRecognizer(target: self, action: "imageFlipped:")
        self.detailImage.addGestureRecognizer(tapGesture)
        self.detailImage.userInteractionEnabled = true
        
        let tapGestureBack = UITapGestureRecognizer(target: self, action: "imageFlipBack:")
        self.detailBackImage.addGestureRecognizer(tapGestureBack)
        self.detailBackImage.userInteractionEnabled = true

        
    }
    
    
    // Detail image flip to show ingredients
    func imageFlipped(gesture: UIGestureRecognizer) {
        self.detailImage.translatesAutoresizingMaskIntoConstraints = true
        UIView.transitionFromView(self.detailImage, toView: self.detailBackImage, duration: 1,
            options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: nil)
        
        self.detailBackImage.alpha = 1
        self.detailPreference.alpha = 1
        self.detailDescription.alpha = 1
        self.detailIngredients.alpha = 1
    }
    
    func imageFlipBack(gesture: UIGestureRecognizer) {
        self.detailBackImage.translatesAutoresizingMaskIntoConstraints = true
        UIView.transitionFromView(self.detailBackImage, toView: self.detailImage, duration: 1,
            options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
        
        self.detailBackImage.alpha = 0
        self.detailPreference.alpha = 0
        self.detailDescription.alpha = 0
        self.detailIngredients.alpha = 0
    }

    @IBAction func dailyQtyStepperPressed(sender: UIStepper) {
        self.quantityAmount = Int(self.dailyQtyStepper.value)
        variables.dailyQuantity![variables.itemIndex!] = self.quantityAmount
        self.dailyQty.text = "\(self.quantityAmount)"
        
    }
    
    @IBAction func maxOrderLimitStepperPressed(sender: UIStepper) {
        self.maxOrderLimitAmount = Int(self.maxOrderLimitStepper.value)
        variables.maxOrderLimit![variables.itemIndex!] = self.maxOrderLimitAmount
        self.maxOrderLimit.text = "\(self.maxOrderLimitAmount)"
    }
    
    @IBAction func timeIntervalStepperPressed(sender: UIStepper) {
        self.timeIntervalAmount = Int(self.timeIntervalStepper.value)
        variables.timeInterval![variables.itemIndex!] = self.timeIntervalAmount * 5
        self.timeInterval.text = "\(self.timeIntervalAmount * 5) Min"

    }
    
    
    
    @IBAction func itemDetailViewClose(sender: AnyObject) {
//        if variables.itemCount![fhoodie.selectedIndex!] != 0 {
//            fhoodie.isAnythingSelected = true
//        }
        
        if self.maxOrderLimitAmount > self.quantityAmount {
            
            let alert = UIAlertController(title: "Excuse me", message:"Doesn't seem like you have enough daily quantity to set the maximum order limit", preferredStyle: .Alert)
            let error1 = UIAlertAction(title: "OK", style: .Default) { _ in}
            alert.addAction(error1)
            self.presentViewController(alert, animated: true){}
        }
        else if self.quantityAmount != 0 && self.maxOrderLimitAmount == 0 {
            
            let alert2 = UIAlertController(title: "Um...", message:"Please set the maximum order limit amount", preferredStyle: .Alert)
            let error2 = UIAlertAction(title: "OK", style: .Default) { _ in}
            alert2.addAction(error2)
            self.presentViewController(alert2, animated: true){}
        
        }
        else if self.quantityAmount != 0 && self.timeIntervalAmount == 0 {
            
            let alert3 = UIAlertController(title: "Almost there", message:"Please set the time interval", preferredStyle: .Alert)
            let error3 = UIAlertAction(title: "OK", style: .Default) { _ in}
            alert3.addAction(error3)
            self.presentViewController(alert3, animated: true){}
            
        }
        else {
            NSNotificationCenter.defaultCenter().postNotificationName("load", object: nil)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }



}
