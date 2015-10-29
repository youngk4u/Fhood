//
//  DetailViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 10/28/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
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
    @IBOutlet var detailInstructions: UITextField!
    @IBOutlet var detailIngredients: UILabel!
    
    var quantityLabel : Int = 0
    var formatter = NSNumberFormatter()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.8)
        
        // Currency formatter
        self.formatter.numberStyle = .CurrencyStyle
        
        self.detailStepper.value = Double(variables.itemCount![fhoodie.selectedIndex!])
        self.detailQuantity.text = "\(Int(self.detailStepper.value))"
        self.detailTitle.text = variables.itemNames![fhoodie.selectedIndex!]
        self.detailImage.image = UIImage(named: variables.itemNames![fhoodie.selectedIndex!])
        self.detailPrice.text = formatter.stringFromNumber(variables.itemPrices![fhoodie.selectedIndex!])
        self.detailIngredients.text = "Ingredients: " + variables.itemIngredients![fhoodie.selectedIndex!]

        
        
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
        self.detailIngredients.alpha = 1
    }
    
    func imageFlipBack(gesture: UIGestureRecognizer) {
        self.detailBackImage.translatesAutoresizingMaskIntoConstraints = true
        UIView.transitionFromView(self.detailBackImage, toView: self.detailImage, duration: 1,
            options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
        
        self.detailBackImage.alpha = 0
        self.detailIngredients.alpha = 0
    }

    
    // Stepper Button
    @IBAction func stepperPressed(sender: UIStepper) {
        self.quantityLabel = Int(self.detailStepper.value)
        variables.itemCount![fhoodie.selectedIndex!] = self.quantityLabel
        self.detailQuantity.text = "\(self.quantityLabel)"
    }

    @IBAction func detailViewClose(sender: AnyObject) {
        if variables.itemCount![fhoodie.selectedIndex!] != 0 {
            fhoodie.isAnythingSelected = true
        }
        NSNotificationCenter.defaultCenter().postNotificationName("load", object: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
