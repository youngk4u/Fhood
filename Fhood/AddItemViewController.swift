//
//  AddItemViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 11/28/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
//

import UIKit
import Parse

final class AddItemViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate {

    @IBOutlet var scrollViewHeight: NSLayoutConstraint!
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var menuNameTextfield: UITextField!
    @IBOutlet var priceTextfield: UITextField!
    @IBOutlet var descriptionTextfield: UITextField!
    @IBOutlet var ingredientsTextfield: UITextField!
    @IBOutlet var cuisinTypeTextfield: UITextField!
    
    var cuisinTypePicker: UIPickerView!
    let cuisinTypePickerValues = ["", "American", "Argentinian", "Asian", "BBQ", "Bagels", "Bakery", "Bento", "Brazilian", "Breakfast", "Californian", "Calzones", "Cantonese", "Caribbean", "Cheesesteaks", "Chicken", "Chinese", "Coffee", "Cold Pressed", "Crepes", "Cuban", "Curry", "Deli", "Dessert", "Dim Sum", "Diner", "Dinner", "Eclectic", "Empanadas", "European", "Fish and Chips", "French", "Fusion", "German", "Gluten-Free", "Greek", "Grill", "Grilled Cheese", "Gyro", "Halal", "Hamburgers", "Hawaiian", "Healthy", "Hoagies", "Hot Dogs", "Ice Cream", "Indian", "Indonesian", "Italian", "Japanese", "Kids Menu", "Korean", "Kosher", "Kosher-Style", "Late Night", "Latin American", "Lebanese", "Lemonade", "Low Carb", "Low Fat", "Lunch", "Mandarin", "Meatloaf", "Mediterranean", "Mexican", "Middle Eastern", "Mini Sliders", "New American", "Noodles", "Organic", "Pasta", "Persian", "Peruvian", "Pitas", "Pizza", "Pork Buns", "Potato", "Pub Food", "Ribs", "Rice Bowl", "Russian", "Salads", "Sandwiches", "Seafood", "Smoothies and Juices", "Soul Food", "Soup", "Steak", "Subs", "Sushi", "Shawarma", "Szechwan", "Tapas", "Tea", "Thai", "Vegan", "Vegetarian", "Vietnamese", "Water", "Wings", "Wraps", "Other"]
    
    @IBOutlet var pickupButton: UIButton!
    var pickupBtnState: Bool = false
    @IBOutlet var eatInButton: UIButton!
    var eatInBtnState: Bool = false
    @IBOutlet var deliveryButton: UIButton!
    var deliveryBtnState: Bool = false
    
    
    @IBOutlet var toPhotoButton: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var saveButton: UIBarButtonItem!
    
    var currentItemIndex: Int = 0
    
    var questionArray =
        ["Are you using organic ingredients?",
         "Is this vegan?",
         "Is this gluten free?",
         "Is this nut free?",
         "Is this soy free?",
         "Is this MSG free?",
         "Is this Dairy Free?",
         "Is this low sodium?"]
    
    var answerArray = [false, false, false, false, false, false, false, false]
    
    let rootViewController: UIViewController = UIApplication.sharedApplication().windows[0].rootViewController!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add item"
        
        // Scroll View height by Phone size
        // iPhone 6+/6s+ = 736
        // iPhone 6/6s   = 667
        // iPhone 5/5s   = 568
        self.scrollViewHeight.constant = 667
        
        
        // Reload data
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddItemViewController.loadInfo(_:)),name:"loadInfoView", object: nil)
        
        // Textfield Delegate
        self.menuNameTextfield.delegate = self
        self.priceTextfield.delegate = self
        self.cuisinTypeTextfield.delegate = self
        
        self.cuisinTypePicker = UIPickerView()
        self.cuisinTypePicker.delegate = self
        
        self.cuisinTypeTextfield.inputView = self.cuisinTypePicker
        self.cuisinTypeTextfield.text = ""
        
        // Buttons unselected
        self.eatInButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        self.pickupButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        self.deliveryButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        
        // TableView Delegate
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.layoutMargins = UIEdgeInsetsZero
        
        
        // Placeholder custom insets
        let paddingView = UIView(frame: CGRectMake(0, 0, 10, 0))
        let paddingView2 = UIView(frame: CGRectMake(0, 0, 10, 0))
        let paddingView3 = UIView(frame: CGRectMake(0, 0, 10, 0))
        let paddingView4 = UIView(frame: CGRectMake(0, 0, 10, 0))
        
        self.priceTextfield.rightView = paddingView
        self.descriptionTextfield.rightView = paddingView2
        self.ingredientsTextfield.rightView = paddingView3
        self.cuisinTypeTextfield.rightView = paddingView4
        
        self.priceTextfield.rightViewMode = UITextFieldViewMode.Always
        self.descriptionTextfield.rightViewMode = UITextFieldViewMode.Always
        self.ingredientsTextfield.rightViewMode = UITextFieldViewMode.Always
        self.cuisinTypeTextfield.rightViewMode = UITextFieldViewMode.Always
    }
    
    
    // Reload Picture and name to reload from other controllers
    func loadInfo(notification: NSNotification){
        
        self.currentItemIndex = (Fhooder.itemNames?.count)!
        toPhotoButton.setImage(Fhooder.itemPic, forState: .Normal)
        
        self.descriptionTextfield.text = Fhooder.descriptionText
        self.ingredientsTextfield.text = Fhooder.ingredientsText
    }
    
    
    
    
    
    
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        if textField == self.priceTextfield || textField == self.cuisinTypeTextfield {
            
            // Create a button bar for the number pad or cuisine type picker
            let keyboardDoneButtonView = UIToolbar()
            keyboardDoneButtonView.sizeToFit()
            
            // Setup the buttons to be put in the system.
            let item = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AddItemViewController.doneButton) )
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
    
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddItemViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddItemViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        keyboardFrame = self.view.convertRect(keyboardFrame, fromView: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 100
        self.scrollView.contentInset = contentInset
    }
    
    
    func keyboardWillHide(notification: NSNotification) {
        let contentInset:UIEdgeInsets = UIEdgeInsetsZero
        self.scrollView.contentInset = contentInset
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
        if textField == menuNameTextfield {
            textField.text = textField.text?.capitalizedString
        }
        self.view.endEditing(true)
        return false
    }
    
    
    
    
    // Picker view
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        if pickerView == self.cuisinTypePicker {
            return cuisinTypePickerValues.count
        }
        return 0
    }
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == self.cuisinTypePicker {
            return cuisinTypePickerValues[row]
        }
        return ""
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        if pickerView == self.cuisinTypePicker {
            cuisinTypeTextfield.text = cuisinTypePickerValues[row]
        }
    }
    
    
    // TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NutritionalInfoCell") as! NutritionalInfoCell
        
        // Get the questions
        cell.questionLabel.text = self.questionArray[indexPath.row]
        
        cell.answerSegment.layer.setValue(indexPath.row, forKey: "index")
        cell.answerSegment.addTarget(self, action: #selector(AddItemViewController.segment(_:)), forControlEvents: .ValueChanged)
        cell.answerSegment.selectedSegmentIndex = 2
        
        // Make the insets to zero
        cell.layoutMargins = UIEdgeInsetsZero

        return cell
    }
    
    
    func segment (sender: UISegmentedControl) {
        let i = sender.layer.valueForKey("index") as! Int
        
        switch sender.selectedSegmentIndex {
        case 0:
            self.answerArray[i] = true
        case 1:
            self.answerArray[i] = false
        case 2:
            self.answerArray[i] = false
        default:
            break
        }
    }
    
    
    @IBAction func pickupButton(sender: UIButton) {
        if self.pickupBtnState == false {
            self.pickupBtnState = true
            self.pickupButton.setTitleColor(UIColor(red:0.00, green:0.79, blue:0.73, alpha:1.0), forState: .Normal)
        }
        else {
            self.pickupBtnState = false
            self.pickupButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        }

    }
    
    @IBAction func eatinButton(sender: UIButton) {
        if self.eatInBtnState == false {
            self.eatInBtnState = true
            self.eatInButton.setTitleColor(UIColor(red:0.00, green:0.79, blue:0.73, alpha:1.0), forState: .Normal)
        }
        else {
            self.eatInBtnState = false
            self.eatInButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        }
    }
    

    @IBAction func deliveryButton(sender: UIButton) {
        if self.deliveryBtnState == false {
            self.deliveryBtnState = true
            self.deliveryButton.setTitleColor(UIColor(red:0.00, green:0.79, blue:0.73, alpha:1.0), forState: .Normal)
        }
        else {
            self.deliveryBtnState = false
            self.deliveryButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if (segue.identifier == "toDescriptionView") {
            let destViewController = segue.destinationViewController as! DescriptionIngredientsViewController
            let titleString = "Description"
            destViewController.navTitle = titleString
        }
        else if (segue.identifier == "toIngredientsView") {
            let destViewController = segue.destinationViewController as! DescriptionIngredientsViewController
            let titleString = "Ingredients"
            destViewController.navTitle = titleString
        }

    }

    @IBAction func descriptionButton(sender: UIButton) {
        performSegueWithIdentifier("toDescriptionView", sender: self)
    }
    
    @IBAction func ingredientsButton(sender: UIButton) {
        performSegueWithIdentifier("toIngredientsView", sender: self)
    }
    
    
    
    @IBAction func closeAdd(sender: AnyObject) {
        
        NSNotificationCenter.defaultCenter().postNotificationName("loadInfoView", object: nil)
        
        Fhooder.descriptionText = ""
        Fhooder.ingredientsText = ""
        
        
        if toPhotoButton.imageView != nil {
            
        }
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    
    
    @IBAction func saveItem(sender: AnyObject) {
        
        NSNotificationCenter.defaultCenter().postNotificationName("loadInfoView", object: nil)
        
        if validateInput() {
            
            HUD.show()
            
            if PFUser.currentUser() != nil {
                let fhooderID = (PFUser.currentUser()!.valueForKey("fhooder")?.objectId)! as String
                let fhooder = PFQuery(className: "Fhooder")
                fhooder.getObjectInBackgroundWithId(fhooderID, block: { (fhooder, error) -> Void in
                    
                    // If there's no item set the picture and price in Parse Fhooder class so it'll show on the map
                    var itemPicExist : Bool = true
                    if fhooder!["itemPic"] != nil {
                        itemPicExist = true
                    }
                    else {
                        itemPicExist = false
                    }
                    
                    if self.pickupBtnState == true {
                        fhooder!["isPickup"] = self.pickupBtnState
                    }
                    if self.deliveryBtnState == true {
                        fhooder!["isDeliver"] = self.deliveryBtnState
                    }
                    if self.eatInBtnState == true {
                        fhooder!["isEatin"] = self.eatInBtnState
                    }
            
                    let item = PFObject(className: "Items")
                    item["itemName"] = self.menuNameTextfield.text!.capitalizedString
                    
                    let imageData = self.toPhotoButton.imageView!.image?.lowestQualityJPEGNSData
                    let imageFile = PFFile(name: "item.png", data: imageData!)
                    if itemPicExist == true {
                        item["photo"] = imageFile
                    }
                    else {
                        item["photo"] = imageFile
                        fhooder!["itemPic"] = imageFile
                    }
                    
                    
                    let priceInString = self.priceTextfield.text!
                    let priceString = String(priceInString.characters.dropFirst())
                    let priceNumber = Double(priceString)
                    
                    if itemPicExist == true {
                        item["price"] = priceNumber
                    }
                    else {
                        item["price"] = priceNumber
                        fhooder!["itemPrice"] = priceNumber
                    }
                    
                    item["description"] = self.descriptionTextfield.text!
                    item["ingredients"] = self.ingredientsTextfield.text!
                    item["cuisineType"] = self.cuisinTypeTextfield.text!
                    item["organic"] = self.answerArray[0]
                    item["vegan"] = self.answerArray[1]
                    item["glutenFree"] = self.answerArray[2]
                    item["nutFree"] = self.answerArray[3]
                    item["soyFree"] = self.answerArray[4]
                    item["msgFree"] = self.answerArray[5]
                    item["dairyFree"] = self.answerArray[6]
                    item["lowSodium"] = self.answerArray[7]
                    item["dailyQuantity"] = 0
                    item["maxOrderLimit"] = 0
                    item["timeInterval"] = 0
                    
                    
                    Fhooder.itemNames?.append(self.menuNameTextfield.text!)
                    Fhooder.itemPics?.append(Fhooder.itemPic!)
                    Fhooder.pickup? = self.pickupBtnState
                    Fhooder.delivery? = self.deliveryBtnState
                    Fhooder.eatin? = self.eatInBtnState
                    Fhooder.itemPrices?.append(priceNumber!)
                    Fhooder.itemDescription?.append(self.descriptionTextfield.text!)
                    Fhooder.itemIngredients?.append(self.ingredientsTextfield.text!)
                    Fhooder.itemCuisineType? = self.cuisinTypeTextfield.text!
                    Fhooder.itemPreferences?.append(self.answerArray)
                    
                    
                    item.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                        if success {
                            
                            self.view.endEditing(true)
                        
                            let relation = fhooder?.relationForKey("items")
                            relation?.addObject(item)
                            
                            do {
                                try fhooder!.save()
                                
                                NSNotificationCenter.defaultCenter().postNotificationName("load1", object: nil)
                                
                                HUD.dismiss()
                                
                                let alert = UIAlertController(title: "Item added", message:"New item has been added!", preferredStyle: .Alert)
                                let added = UIAlertAction(title: "Ok!", style: .Default) { _ in}
                                alert.addAction(added)
                                self.dismissViewControllerAnimated(true, completion: nil)
                                self.rootViewController.presentViewController(alert, animated: true, completion: nil)

                            }
                            catch {
                                
                                HUD.dismiss()
                                
                                let alert = UIAlertController(title: "", message:"There was an error!", preferredStyle: .Alert)
                                let error = UIAlertAction(title: "Ok", style: .Default) { _ in}
                                alert.addAction(error)
                                self.rootViewController.presentViewController(alert, animated: true, completion: nil)
                                
                            }
                            
                        }
                    }
                })
            }
        }
    }
    
    
    func validateInput() -> Bool {
        
        guard let firstname = self.menuNameTextfield.text  where !firstname.isEmpty else {
            self.showAlert(withMessage: "Please enter the menu name before continuing!")
            return false
        }
        
        guard let photo = self.toPhotoButton.imageView!.image  where photo == Fhooder.itemPic else {
            self.showAlert(withMessage: "Please provide item picture before continuing!")
            return false
        }
        
        guard let servingMethod: [Bool] = [self.pickupBtnState, self.eatInBtnState, self.deliveryBtnState]  where servingMethod != [false, false, false] else {
            self.showAlert(withMessage: "Please choose the serving method before continuing!")
            return false
        }
        
        guard let price = self.priceTextfield.text  where !price.isEmpty else {
            self.showAlert(withMessage: "Please enter the item price before continuing!")
            return false
        }
        
        guard let descrip = self.descriptionTextfield.text  where !descrip.isEmpty else {
            self.showAlert(withMessage: "Please enter the item description before continuing!")
            return false
        }
        
        guard let ingred = self.ingredientsTextfield.text  where !ingred.isEmpty else {
            self.showAlert(withMessage: "Please enter the item ingredients before continuing!")
            return false
        }
        
        guard let type = self.cuisinTypeTextfield.text  where !type.isEmpty else {
            self.showAlert(withMessage: "Please pick the cuisine type before continuing!")
            return false
        }
        
        return true
    }
    
    private func showAlert(withMessage message: String) {
        let alert = UIAlertController(title: "Oops", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        rootViewController.presentViewController(alert, animated: true, completion: nil)
    }
}
