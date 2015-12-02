//
//  AddItemViewController.swift
//  Fhood
//
//  Created by YOUNG on 11/28/15.
//  Copyright © 2015 YOUNG&YOUM. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var scrollViewHeight: NSLayoutConstraint!
    
    @IBOutlet var menuNameTextfield: UITextField!
    @IBOutlet var priceTextfield: UITextField!
    @IBOutlet var descriptionTextfield: UITextField!
    @IBOutlet var ingredientsTextfield: UITextField!
    
    @IBOutlet var eatInButton: UIButton!
    var eatInBtnState: Bool = false
    @IBOutlet var pickupDeliveryButton: UIButton!
    var pickupDeliveryState: Bool = false
    
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var saveButton: UIBarButtonItem!
    
    var questionArray =
        ["Are you using organic ingredients?",
         "Is this vegan?",
         "Does this menu contain any gluten?",
         "Does this menu contain any nuts?",
         "Does this menu contain any soy?",
         "Does this menu contain any MSG?",
         "Does this menu contain any dairy?",
         "Does this menu contain low sodium?"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add item"
        
        // Scroll View height by Phone size
        // iPhone 6+/6s+ = 736
        // iPhone 6/6s   = 667
        // iPhone 5/5s   = 568
        self.scrollViewHeight.constant = 568
        
        // Textfield Delegate
        self.menuNameTextfield.delegate = self
        self.priceTextfield.delegate = self
        
        // Buttons unselected
        self.eatInButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        self.pickupDeliveryButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        
        
        // TableView Delegate
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.layoutMargins = UIEdgeInsetsZero
        
        
        // Placeholder custom insets
        let paddingView = UIView(frame: CGRectMake(0, 0, 10, 0))
        let paddingView2 = UIView(frame: CGRectMake(0, 0, 10, 0))
        let paddingView3 = UIView(frame: CGRectMake(0, 0, 10, 0))
        
        self.priceTextfield.rightView = paddingView
        self.descriptionTextfield.rightView = paddingView2
        self.ingredientsTextfield.rightView = paddingView3
        self.priceTextfield.rightViewMode = UITextFieldViewMode.Always
        self.descriptionTextfield.rightViewMode = UITextFieldViewMode.Always
        self.ingredientsTextfield.rightViewMode = UITextFieldViewMode.Always
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        if textField == self.priceTextfield {
            
            // Create a button bar for the number pad
            let keyboardDoneButtonView = UIToolbar()
            keyboardDoneButtonView.sizeToFit()
            
            // Setup the buttons to be put in the system.
            let item = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("doneButton") )
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
            item.tintColor = UIColor.blackColor()
            let toolbarButtons = [flexibleSpace, item, flexibleSpace]
            
            //Put the buttons into the ToolBar and display the tool bar
            keyboardDoneButtonView.setItems(toolbarButtons, animated: false)
            textField.inputAccessoryView = keyboardDoneButtonView
            
        }
        
        return true
    }
    
    func doneButton() {
        self.view.endEditing(true)
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        

        if textField == self.priceTextfield {
            
            // Construct the text that will be in the field if this change is accepted
            let oldText = textField.text! as NSString
            var newText = oldText.stringByReplacingCharactersInRange(range, withString: string) as String!
            var newTextString = String(newText)
            
            let digits = NSCharacterSet.decimalDigitCharacterSet()
            var digitText = ""
            for c in newTextString.unicodeScalars {
                if digits.longCharacterIsMember(c.value) {
                    digitText.append(c)
                }
            }
            
            let formatter = NSNumberFormatter()
            formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
            formatter.locale = NSLocale(localeIdentifier: "en_US")
            let numberFromField = (NSString(string: digitText).doubleValue)/100
            newText = formatter.stringFromNumber(numberFromField)
            
            textField.text = newText
            
            return false
        }
        
        return true
    }
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    
    // TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NutritionalInfoCell") as! NutritionalInfoCell
        
        // Get the questions
        cell.questionLabel.text = self.questionArray[indexPath.row]
        cell.answerSegment.selectedSegmentIndex = 2
        
        
        // Make the insets to zero
        cell.layoutMargins = UIEdgeInsetsZero

        return cell
    }
    
    @IBAction func eatInButton(sender: UIButton) {
        
        if self.eatInBtnState == false {
            self.eatInBtnState = true
            self.pickupDeliveryState = false
            self.eatInButton.setTitleColor(UIColor(red:0.00, green:0.79, blue:0.73, alpha:1.0), forState: .Normal)
            self.pickupDeliveryButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
            
        }
        else {
            self.eatInBtnState = false
            self.eatInButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
            
        }
    }
    
    @IBAction func pickupDeliveryButton(sender: UIButton) {
        
        if self.pickupDeliveryState == false {
            self.pickupDeliveryState = true
            self.eatInBtnState = false
            self.pickupDeliveryButton.setTitleColor(UIColor(red:0.00, green:0.79, blue:0.73, alpha:1.0), forState: .Normal)
            self.eatInButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
            
        }
        else {
            self.pickupDeliveryState = false
            self.pickupDeliveryButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
            
        }
        
    }
    
    
    @IBAction func closeAdd(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func saveItem(sender: AnyObject) {
        
    }
}
