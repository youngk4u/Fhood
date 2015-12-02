//
//  DescriptionIngredientsViewController.swift
//  Fhood
//
//  Created by YOUNG on 12/1/15.
//  Copyright © 2015 YOUNG&YOUM. All rights reserved.
//

import UIKit

class DescriptionIngredientsViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var textView: UITextView!
    
    let rootViewController: UIViewController = UIApplication.sharedApplication().windows[1].rootViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.textView.becomeFirstResponder()
        
    }
    
    
    @IBAction func saveButton(sender: UIBarButtonItem) {
        
        self.textView.resignFirstResponder()
        
        let alert = UIAlertController(title: "", message:"Your description/ingredients has been saved!", preferredStyle: .Alert)
        let saved = UIAlertAction(title: "Nice!", style: .Default) { _ in}
        alert.addAction(saved)
        rootViewController.presentViewController(alert, animated: true, completion: nil)
        
        // Reload tableview from previous controller
        //NSNotificationCenter.defaultCenter().postNotificationName("loadSettings", object: nil)
        
        dismissViewControllerAnimated(true, completion: nil)

    }
    
    
    @IBAction func closeView(sender: AnyObject) {
        self.textView.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
    }

}
