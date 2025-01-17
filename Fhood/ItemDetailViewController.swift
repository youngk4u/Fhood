//
//  ItemDetailViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 10/23/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
//

import UIKit
import Parse

final class ItemDetailViewController: UIViewController {
    
    
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
    
    var formatter = NumberFormatter()
    
    let rootViewController: UIViewController = UIApplication.shared.windows[0].rootViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.8)
        
        // Currency formatter
        self.formatter.numberStyle = .currency
      
        self.detailTitle.text = Fhooder.itemNames![Fhooder.itemIndex!]
        self.detailImage.image = Fhooder.itemPic!
        self.detailPrice.text = formatter.string(from: (Fhooder.itemPrices![Fhooder.itemIndex!]) as NSNumber)
        self.detailDescription.text = "Description: " + Fhooder.itemDescription![Fhooder.itemIndex!]
        self.detailIngredients.text = "Ingredients: " + Fhooder.itemIngredients![Fhooder.itemIndex!]
        
        
        // Set the prefernece images sorted
        for i in 0 ..< 8 {
            
            if Fhooder.itemPreferences![Fhooder.itemIndex!][i] == false {
                self.preferenceSet[i] = ""
            }
        }
        
        self.preferenceSet.sort { (a, b) -> Bool in
            if a.isEmpty {
                return false
            } else if b.isEmpty {
                return true
            } else {
                return a.localizedCaseInsensitiveCompare(b) == .orderedAscending
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

        
        self.quantityAmount = Fhooder.dailyQuantity![Fhooder.itemIndex!]
        self.dailyQtyStepper.value = Double(Fhooder.dailyQuantity![Fhooder.itemIndex!])
        self.dailyQty.text = "\(Int(self.dailyQtyStepper.value))"
        
        self.maxOrderLimitAmount = Fhooder.maxOrderLimit![Fhooder.itemIndex!]
        self.maxOrderLimitStepper.value = Double((Fhooder.maxOrderLimit![Fhooder.itemIndex!]))
        self.maxOrderLimit.text = "\(Int(self.maxOrderLimitStepper.value))"
        
        self.timeIntervalAmount = Fhooder.timeInterval![Fhooder.itemIndex!]
        self.timeIntervalStepper.value = Double(self.timeIntervalAmount / 5)
        self.timeInterval.text = "\(Int(self.timeIntervalStepper.value) * 5) Min"
        
        
        
        
        // Detail view image tap to see ingredients
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ItemDetailViewController.imageFlipped(_:)))
        self.detailImage.addGestureRecognizer(tapGesture)
        self.detailImage.isUserInteractionEnabled = true
        
        let tapGestureBack = UITapGestureRecognizer(target: self, action: #selector(ItemDetailViewController.imageFlipBack(_:)))
        self.detailBackImage.addGestureRecognizer(tapGestureBack)
        self.detailBackImage.isUserInteractionEnabled = true

        
    }
    
    
    // Detail image flip to show ingredients
    @objc func imageFlipped(_ gesture: UIGestureRecognizer) {
        self.detailImage.translatesAutoresizingMaskIntoConstraints = true
        UIView.transition(from: self.detailImage, to: self.detailBackImage, duration: 1,
            options: UIViewAnimationOptions.transitionFlipFromLeft, completion: nil)
        
        self.detailBackImage.alpha = 1
        self.detailPreference.alpha = 1
        self.detailDescription.alpha = 1
        self.detailIngredients.alpha = 1
    }
    
    @objc func imageFlipBack(_ gesture: UIGestureRecognizer) {
        self.detailBackImage.translatesAutoresizingMaskIntoConstraints = true
        UIView.transition(from: self.detailBackImage, to: self.detailImage, duration: 1,
            options: UIViewAnimationOptions.transitionFlipFromRight, completion: nil)
        
        self.detailBackImage.alpha = 0
        self.detailPreference.alpha = 0
        self.detailDescription.alpha = 0
        self.detailIngredients.alpha = 0
    }

    @IBAction func dailyQtyStepperPressed(_ sender: UIStepper) {
        self.quantityAmount = Int(self.dailyQtyStepper.value)
        Fhooder.dailyQuantity![Fhooder.itemIndex!] = self.quantityAmount
        self.dailyQty.text = "\(self.quantityAmount)"
        
    }
    
    @IBAction func maxOrderLimitStepperPressed(_ sender: UIStepper) {
        self.maxOrderLimitAmount = Int(self.maxOrderLimitStepper.value)
        Fhooder.maxOrderLimit![Fhooder.itemIndex!] = self.maxOrderLimitAmount
        self.maxOrderLimit.text = "\(self.maxOrderLimitAmount)"
    }
    
    @IBAction func timeIntervalStepperPressed(_ sender: UIStepper) {
        self.timeIntervalAmount = Int(self.timeIntervalStepper.value)
        Fhooder.timeInterval![Fhooder.itemIndex!] = self.timeIntervalAmount * 5
        self.timeInterval.text = "\(self.timeIntervalAmount * 5) Min"

    }
    
    @IBAction func deleteItem(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Delete item", message:"Are you sure you want to delete this item?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .default) { _ in}
        let proceed = UIAlertAction(title: "Delete", style: .default) { (action: UIAlertAction!) -> () in

            
            HUD.show()
            
            let query = PFQuery(className: "Items")
            let ID = Fhooder.itemID![Fhooder.itemIndex!]
            
            query.getObjectInBackground(withId: ID, block: { (item: PFObject?, error: Error?) -> Void in
                if error != nil {
                    print(error as Any)
                }
                else {
                    
                    let query2 = PFQuery(className: "Fhooder")
                    let ID2 = Fhooder.objectID!
                    
                    // If this is the only item, delete itemPic and itemPrice from Parse Fhooder class
                    if Fhooder.itemIndex == 0 && Fhooder.itemNames?.count == 1 {
                    
                        query2.getObjectInBackground(withId: ID2, block: { (fhooder: PFObject?, error2: Error?) -> Void in
                            
                            if error2 == nil {
                                fhooder?.remove(forKey: "itemPic")
                                fhooder?.remove(forKey: "itemPrice")
                                
                                fhooder?.saveInBackground()
                                
                                item?.deleteInBackground()
                                
                                HUD.dismiss()
                                    
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "load1"), object: nil)
                                
                                
                                let alert2 = UIAlertController(title: "", message:"You have no items. Please add some ;)", preferredStyle: .alert)
                                let saved2 = UIAlertAction(title: "Ok!", style: .default) { _ in}
                                alert2.addAction(saved2)
                                self.rootViewController.present(alert2, animated: true, completion: nil)
                                Fhooder.fhooderSignedIn = false
                                Router.route(true)
                                
                            }
                        })
                    }
                    else if Fhooder.itemIndex == 0 {
                        
                        let ID3 = Fhooder.itemID![1]
                        
                        query.getObjectInBackground(withId: ID3, block: { (item2: PFObject?, error3: Error?) -> Void in
                            if error3 == nil {
                                
                                query2.getObjectInBackground(withId: ID2, block: { (fhooder: PFObject?, error2: Error?) -> Void in
                                    
                                    if error2 == nil {
                                        
                                        fhooder!["itemPic"] = item2!["photo"] as? PFFile
                                        fhooder!["itemPrice"] = item2!["price"] as? Double
                                        
                                        fhooder?.saveInBackground()
                                        
                                        item?.deleteInBackground()
                                        
                                        HUD.dismiss()
                                        
                                        
                                        NotificationCenter.default.post(name: Notification.Name(rawValue: "load1"), object: nil)
                                        
                                        let alert2 = UIAlertController(title: "", message:"Item has been deleted.", preferredStyle: .alert)
                                        let saved2 = UIAlertAction(title: "Ok!", style: .default) { _ in}
                                        alert2.addAction(saved2)
                                        self.rootViewController.present(alert2, animated: true, completion: nil)
                                        self.dismiss(animated: true, completion: nil)
                                    }
                                })
                            }
                            
                        })
                        
                    }
                    else {
                        item?.deleteInBackground()
                        
                        HUD.dismiss()
                        
                        
                        let alert2 = UIAlertController(title: "", message:"Item has been deleted.", preferredStyle: .alert)
                        let saved2 = UIAlertAction(title: "Ok!", style: .default) { _ in}
                        alert2.addAction(saved2)
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "load1"), object: nil)
                        self.rootViewController.present(alert2, animated: true, completion: nil)
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                    
                }
                
            })
            
            
        }
        alert.addAction(cancel)
        alert.addAction(proceed)
        self.present(alert, animated: true){}
        
        
    }
    
    
    @IBAction func itemDetailViewClose(_ sender: AnyObject) {
        
        if self.maxOrderLimitAmount > self.quantityAmount {
            
            let alert = UIAlertController(title: "Excuse me", message:"Doesn't seem like you have enough daily quantity to set the maximum order limit", preferredStyle: .alert)
            let error1 = UIAlertAction(title: "OK", style: .default) { _ in}
            alert.addAction(error1)
            self.present(alert, animated: true){}
        }
        else if self.quantityAmount != 0 && self.maxOrderLimitAmount == 0 {
            
            let alert2 = UIAlertController(title: "Um...", message:"Please set the maximum order limit amount", preferredStyle: .alert)
            let error2 = UIAlertAction(title: "OK", style: .default) { _ in}
            alert2.addAction(error2)
            self.present(alert2, animated: true){}
        
        }
        else if self.quantityAmount != 0 && self.timeIntervalAmount == 0 {
            
            let alert3 = UIAlertController(title: "Almost there", message:"Please set the time interval", preferredStyle: .alert)
            let error3 = UIAlertAction(title: "OK", style: .default) { _ in}
            alert3.addAction(error3)
            self.present(alert3, animated: true){}
            
        }
        else {
            
            let query = PFQuery(className: "Items")
            let ID = Fhooder.itemID![Fhooder.itemIndex!]
            
            query.getObjectInBackground(withId: ID) { (stock: PFObject?, error: Error?) -> Void in
                if error != nil {
                }
                else if let stock = stock {
                    stock["dailyQuantity"] = Fhooder.dailyQuantity![Fhooder.itemIndex!]
                    stock["maxOrderLimit"] = Fhooder.maxOrderLimit![Fhooder.itemIndex!]
                    stock["timeInterval"] = Fhooder.timeInterval![Fhooder.itemIndex!]
                    
                    stock.saveInBackground(block: { (success, error) -> Void in
                        if success {
                           NotificationCenter.default.post(name: Notification.Name(rawValue: "load2"), object: nil)
                            self.dismiss(animated: true, completion: nil)
                        }
                        else {
                            print("error")
                        }
                    })
                }
            }
            
        }
    }



}
