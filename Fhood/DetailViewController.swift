//
//  DetailViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 10/28/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
//

import UIKit

final class DetailViewController: UIViewController {
    
    @IBOutlet var detailView: UIView!
    @IBOutlet var detailTitle: UILabel!
    @IBOutlet var detailImage: UIImageView!
    @IBOutlet var detailBackImage: UIImageView!
    @IBOutlet var detailPrice: UILabel!
    @IBOutlet var detailQuantity: UILabel!
    @IBOutlet var detailStepper: UIStepper!
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
    
    @IBOutlet var detailInstructions: UITextField!
    
    @IBOutlet var soldOutLabel: UILabel!
    
    
    var quantityLabel : Int = 0
    var formatter = NumberFormatter()
    
    var passedItemCount: [Int]!
    var delegate: VCTwoDelegate?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Currency formatter
        self.formatter.numberStyle = .currency
        
        self.detailStepper.value = Double(self.passedItemCount[Fhoodie.selectedIndex!])
        self.detailQuantity.text = "\(Int(self.detailStepper.value))"
        self.detailTitle.text = Fhooder.itemNames![Fhoodie.selectedIndex!]
        self.detailTitle.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.detailTitle.textColor = UIColor.white
        self.detailImage.image = Fhooder.itemPics![Fhoodie.selectedIndex!]
        self.detailPrice.text = formatter.string(from: (Fhooder.itemPrices![Fhoodie.selectedIndex!]) as NSNumber)
        self.detailDescription.text = "Description: " + Fhooder.itemDescription![Fhoodie.selectedIndex!]
        self.detailIngredients.text = "Ingredients: " + Fhooder.itemIngredients![Fhoodie.selectedIndex!]
        
        
        let newQuantity = Fhooder.dailyQuantity![Fhoodie.selectedIndex!] - Int(self.detailStepper.value)
        if newQuantity == 0 {
            self.soldOutLabel.isHidden = false
        }
        

        // Set the preference images sorted
        for i in 0 ..< 8 {
            
            if Fhooder.itemPreferences![Fhoodie.selectedIndex!][i] == false {
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

        
        // Detail view image tap to see ingredients
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(DetailViewController.imageFlipped(_:)))
        self.detailImage.addGestureRecognizer(tapGesture)
        self.detailImage.isUserInteractionEnabled = true
        
        let tapGestureBack = UITapGestureRecognizer(target: self, action: #selector(DetailViewController.imageFlipBack(_:)))
        self.detailBackImage.addGestureRecognizer(tapGestureBack)
        self.detailBackImage.isUserInteractionEnabled = true
        
    }
    
    // Detail image flip to show ingredients
    func imageFlipped(_ gesture: UIGestureRecognizer) {
        self.detailImage.translatesAutoresizingMaskIntoConstraints = true
        UIView.transition(from: self.detailImage, to: self.detailBackImage, duration: 1,
            options: UIViewAnimationOptions.transitionFlipFromLeft, completion: nil)
        
        self.detailBackImage.alpha = 1
        self.detailPreference.alpha = 1
        self.detailDescription.alpha = 1
        self.detailIngredients.alpha = 1
    }
    
    func imageFlipBack(_ gesture: UIGestureRecognizer) {
        self.detailBackImage.translatesAutoresizingMaskIntoConstraints = true
        UIView.transition(from: self.detailBackImage, to: self.detailImage, duration: 1,
            options: UIViewAnimationOptions.transitionFlipFromRight, completion: nil)
        
        self.detailBackImage.alpha = 0
        self.detailPreference.alpha = 0
        self.detailDescription.alpha = 0
        self.detailIngredients.alpha = 0
    }

    
    // Stepper Button
    @IBAction func stepperPressed(_ sender: UIStepper) {
        
        self.quantityLabel = Int(self.detailStepper.value)
        let newMax = Fhooder.maxOrderLimit![Fhoodie.selectedIndex!] - self.quantityLabel
        let newQuantity = Fhooder.dailyQuantity![Fhoodie.selectedIndex!] - self.quantityLabel
        
        // If it's sold out, show sold out.  And if it reaches max limit, stops incrementing
        if newMax > 0 {
        
            if newQuantity > 0 {
            
                self.soldOutLabel.isHidden = true
                
                self.passedItemCount[Fhoodie.selectedIndex!] = self.quantityLabel
                self.detailQuantity.text = "\(self.quantityLabel)"
                
            }
            else if newQuantity == 0 {
                self.soldOutLabel.isHidden = false
                
                self.passedItemCount[Fhoodie.selectedIndex!] = self.quantityLabel
                self.detailQuantity.text = "\(self.quantityLabel)"
            }
            else if newQuantity < 0 {
                self.detailStepper.value = self.detailStepper.value - 1
            }
        }
        else if newMax == 0 {
            
            self.passedItemCount[Fhoodie.selectedIndex!] = self.quantityLabel
            self.detailQuantity.text = "\(self.quantityLabel)"
            
        }
        else {
            self.detailStepper.value = self.detailStepper.value - 1
            
            let alert = UIAlertController(title: "", message:"You've reached maximum order limit.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { _ in}
            alert.addAction(action)
            self.present(alert, animated: true){}
        }
    }

    @IBAction func detailViewClose(_ sender: AnyObject) {
        if self.passedItemCount[Fhoodie.selectedIndex!] != 0 {
            Fhoodie.isAnythingSelected = true
        }
        
        self.delegate?.updateData(self.passedItemCount  )
        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
}


protocol VCTwoDelegate {
    func updateData(_ data: [Int])
}
