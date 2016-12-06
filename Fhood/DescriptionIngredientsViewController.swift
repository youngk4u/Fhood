//
//  DescriptionIngredientsViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 12/1/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
//

import UIKit

final class DescriptionIngredientsViewController: UIViewController, UITextViewDelegate {

    
    @IBOutlet var navBar: UINavigationBar!
    var navTitle: String?

    @IBOutlet var textView: UITextView!
    
    let rootViewController: UIViewController = UIApplication.shared.windows[0].rootViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navBar.topItem?.title = navTitle
        
        self.textView.becomeFirstResponder()
        
        if navTitle == "Description" {
            self.textView.text = Fhooder.descriptionText
        }
        else if navTitle == "Ingredients" {
            self.textView.text = Fhooder.ingredientsText
        }
        
    }
    
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        
        self.textView.resignFirstResponder()
        
        if navTitle == "Description" {
            Fhooder.descriptionText = self.textView.text
        }
        else if navTitle == "Ingredients" {
            Fhooder.ingredientsText = self.textView.text
        }
        
        // Reload tableview from previous controller
        NotificationCenter.default.post(name: Notification.Name(rawValue: "loadInfoView"), object: nil)
        
        dismiss(animated: true, completion: nil)

    }
    
    
    @IBAction func closeView(_ sender: AnyObject) {
        self.textView.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }

}
