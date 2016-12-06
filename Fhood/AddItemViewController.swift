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
    var pickupBtnState: Bool? = false
    @IBOutlet var eatInButton: UIButton!
    var eatInBtnState: Bool? = false
    @IBOutlet var deliveryButton: UIButton!
    var deliveryBtnState: Bool? = false
    
    
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
    
    let rootViewController: UIViewController = UIApplication.shared.windows[0].rootViewController!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add item"
        
        // Scroll View height by Phone size
        // iPhone 6+/6s+ = 736
        // iPhone 6/6s   = 667
        // iPhone 5/5s   = 568
        self.scrollViewHeight.constant = 667
        
        
        // Reload data
        NotificationCenter.default.addObserver(self, selector: #selector(AddItemViewController.loadInfo(_:)),name:NSNotification.Name(rawValue: "loadInfoView"), object: nil)
        
        // Textfield Delegate
        self.menuNameTextfield.delegate = self
        self.priceTextfield.delegate = self
        self.cuisinTypeTextfield.delegate = self
        
        self.cuisinTypePicker = UIPickerView()
        self.cuisinTypePicker.delegate = self
        
        self.cuisinTypeTextfield.inputView = self.cuisinTypePicker
        self.cuisinTypeTextfield.text = ""
        
        // Buttons unselected
        self.eatInButton.setTitleColor(UIColor.lightGray, for: UIControlState())
        self.pickupButton.setTitleColor(UIColor.lightGray, for: UIControlState())
        self.deliveryButton.setTitleColor(UIColor.lightGray, for: UIControlState())
        
        // TableView Delegate
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.layoutMargins = UIEdgeInsets.zero
        
        
        // Placeholder custom insets
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        let paddingView2 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        let paddingView3 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        let paddingView4 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        
        self.priceTextfield.rightView = paddingView
        self.descriptionTextfield.rightView = paddingView2
        self.ingredientsTextfield.rightView = paddingView3
        self.cuisinTypeTextfield.rightView = paddingView4
        
        self.priceTextfield.rightViewMode = UITextFieldViewMode.always
        self.descriptionTextfield.rightViewMode = UITextFieldViewMode.always
        self.ingredientsTextfield.rightViewMode = UITextFieldViewMode.always
        self.cuisinTypeTextfield.rightViewMode = UITextFieldViewMode.always
    }
    
    
    // Reload Picture and name to reload from other controllers
    func loadInfo(_ notification: Notification){
        
        self.currentItemIndex = (Fhooder.itemNames?.count)!
        toPhotoButton.setImage(Fhooder.itemPic, for: UIControlState())
        
        self.descriptionTextfield.text = Fhooder.descriptionText
        self.ingredientsTextfield.text = Fhooder.ingredientsText
    }
    
    
    
    
    
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == self.priceTextfield || textField == self.cuisinTypeTextfield {
            
            // Create a button bar for the number pad or cuisine type picker
            let keyboardDoneButtonView = UIToolbar()
            keyboardDoneButtonView.sizeToFit()
            
            // Setup the buttons to be put in the system.
            let item = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AddItemViewController.doneButton) )
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
            item.tintColor = UIColor.black
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
    
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddItemViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddItemViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    func keyboardWillShow(_ notification: Notification) {
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 100
        self.scrollView.contentInset = contentInset
    }
    
    
    func keyboardWillHide(_ notification: Notification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        

        if textField == self.priceTextfield {
            
            // Construct the text that will be in the field if this change is accepted
            let oldText = textField.text! as NSString
            var newText = oldText.replacingCharacters(in: range, with: string) as String!
            var newTextString = String(describing: newText)
            
            let digits = CharacterSet.decimalDigits
            var digitText = ""
            for c in newTextString.unicodeScalars {
                if digits.contains(UnicodeScalar(c.value)!) {
                    digitText.append(String(c))
                }
            }
            
            let formatter = NumberFormatter()
            formatter.numberStyle = NumberFormatter.Style.currency
            formatter.locale = Locale(identifier: "en_US")
            let numberFromField = (NSString(string: digitText).doubleValue)/100
            newText = formatter.string(from: (numberFromField) as NSNumber)
            
            textField.text = newText
            
            return false
        }
        
        return true
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == menuNameTextfield {
            textField.text = textField.text?.capitalized
        }
        self.view.endEditing(true)
        return false
    }
    
    
    
    
    // Picker view
    private func numberOfComponentsInPickerView(_ pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        if pickerView == self.cuisinTypePicker {
            return cuisinTypePickerValues.count
        }
        return 0
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == self.cuisinTypePicker {
            return cuisinTypePickerValues[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        if pickerView == self.cuisinTypePicker {
            cuisinTypeTextfield.text = cuisinTypePickerValues[row]
        }
    }
    
    
    // TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NutritionalInfoCell") as! NutritionalInfoCell
        
        // Get the questions
        cell.questionLabel.text = self.questionArray[indexPath.row]
        
        cell.answerSegment.layer.setValue(indexPath.row, forKey: "index")
        cell.answerSegment.addTarget(self, action: #selector(AddItemViewController.segment(_:)), for: .valueChanged)
        cell.answerSegment.selectedSegmentIndex = 2
        
        // Make the insets to zero
        cell.layoutMargins = UIEdgeInsets.zero

        return cell
    }
    
    
    func segment (_ sender: UISegmentedControl) {
        let i = sender.layer.value(forKey: "index") as! Int
        
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
    
    
    @IBAction func pickupButton(_ sender: UIButton) {
        if self.pickupBtnState == false {
            self.pickupBtnState = true
            self.pickupButton.setTitleColor(UIColor(red:0.00, green:0.79, blue:0.73, alpha:1.0), for: UIControlState())
        }
        else {
            self.pickupBtnState = false
            self.pickupButton.setTitleColor(UIColor.lightGray, for: UIControlState())
        }

    }
    
    @IBAction func eatinButton(_ sender: UIButton) {
        if self.eatInBtnState == false {
            self.eatInBtnState = true
            self.eatInButton.setTitleColor(UIColor(red:0.00, green:0.79, blue:0.73, alpha:1.0), for: UIControlState())
        }
        else {
            self.eatInBtnState = false
            self.eatInButton.setTitleColor(UIColor.lightGray, for: UIControlState())
        }
    }
    

    @IBAction func deliveryButton(_ sender: UIButton) {
        if self.deliveryBtnState == false {
            self.deliveryBtnState = true
            self.deliveryButton.setTitleColor(UIColor(red:0.00, green:0.79, blue:0.73, alpha:1.0), for: UIControlState())
        }
        else {
            self.deliveryBtnState = false
            self.deliveryButton.setTitleColor(UIColor.lightGray, for: UIControlState())
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if (segue.identifier == "toDescriptionView") {
            let destViewController = segue.destination as! DescriptionIngredientsViewController
            let titleString = "Description"
            destViewController.navTitle = titleString
        }
        else if (segue.identifier == "toIngredientsView") {
            let destViewController = segue.destination as! DescriptionIngredientsViewController
            let titleString = "Ingredients"
            destViewController.navTitle = titleString
        }

    }

    @IBAction func descriptionButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toDescriptionView", sender: self)
    }
    
    @IBAction func ingredientsButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toIngredientsView", sender: self)
    }
    
    
    
    @IBAction func closeAdd(_ sender: AnyObject) {
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "loadInfoView"), object: nil)
        
        Fhooder.descriptionText = ""
        Fhooder.ingredientsText = ""
        
        
        if toPhotoButton.imageView != nil {
            
        }
        dismiss(animated: true, completion: nil)
    }

    
    
    
    @IBAction func saveItem(_ sender: AnyObject) {
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "loadInfoView"), object: nil)
        
        if validateInput() {
            
            HUD.show()
            
            if PFUser.current() != nil {
                let fhooderID = ((PFUser.current()!.value(forKey: "fhooder") as AnyObject).objectId)!! as String
                let fhooder = PFQuery(className: "Fhooder")
                fhooder.getObjectInBackground(withId: fhooderID, block: { (fhooder, error) -> Void in
                    
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
                    item["itemName"] = self.menuNameTextfield.text!.capitalized
                    
                    let imageData = self.toPhotoButton.imageView!.image?.lowestQualityJPEGNSData
                    let imageFile = PFFile(name: "item.png", data: imageData! as Data)
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
                    Fhooder.pickup? = self.pickupBtnState!
                    Fhooder.delivery? = self.deliveryBtnState!
                    Fhooder.eatin? = self.eatInBtnState!
                    Fhooder.itemPrices?.append(priceNumber!)
                    Fhooder.itemDescription?.append(self.descriptionTextfield.text!)
                    Fhooder.itemIngredients?.append(self.ingredientsTextfield.text!)
                    Fhooder.itemCuisineType? = self.cuisinTypeTextfield.text!
                    Fhooder.itemPreferences?.append(self.answerArray)
                    
                    
                    item.saveInBackground { (success: Bool, error: Error?) -> Void in
                        if success {
                            
                            self.view.endEditing(true)
                        
                            let relation = fhooder?.relation(forKey: "items")
                            relation?.add(item)
                            
                            do {
                                try fhooder!.save()
                                
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "load1"), object: nil)
                                
                                HUD.dismiss()
                                
                                let alert = UIAlertController(title: "Item added", message:"New item has been added!", preferredStyle: .alert)
                                let added = UIAlertAction(title: "Ok!", style: .default) { _ in}
                                alert.addAction(added)
                                self.dismiss(animated: true, completion: nil)
                                self.rootViewController.present(alert, animated: true, completion: nil)

                            }
                            catch {
                                
                                HUD.dismiss()
                                
                                let alert = UIAlertController(title: "", message:"There was an error!", preferredStyle: .alert)
                                let error = UIAlertAction(title: "Ok", style: .default) { _ in}
                                alert.addAction(error)
                                self.rootViewController.present(alert, animated: true, completion: nil)
                                
                            }
                            
                        }
                    }
                })
            }
        }
    }
    
    
    func validateInput() -> Bool {
        
        guard let firstname = self.menuNameTextfield.text, !firstname.isEmpty else {
            self.showAlert(withMessage: "Please enter the menu name before continuing!")
            return false
        }
        
        guard let photo = self.toPhotoButton.imageView!.image, photo == Fhooder.itemPic else {
            self.showAlert(withMessage: "Please provide item picture before continuing!")
            return false
        }
        
        let servingMethod = [self.pickupBtnState!, self.eatInBtnState!, self.deliveryBtnState!]
        if (servingMethod != [false, false, false]) {
        } else {
            self.showAlert(withMessage: "Please choose the serving method before continuing!")
            return false
        }
        
        guard let price = self.priceTextfield.text, !price.isEmpty else {
            self.showAlert(withMessage: "Please enter the item price before continuing!")
            return false
        }
        
        guard let descrip = self.descriptionTextfield.text, !descrip.isEmpty else {
            self.showAlert(withMessage: "Please enter the item description before continuing!")
            return false
        }
        
        guard let ingred = self.ingredientsTextfield.text, !ingred.isEmpty else {
            self.showAlert(withMessage: "Please enter the item ingredients before continuing!")
            return false
        }
        
        guard let type = self.cuisinTypeTextfield.text, !type.isEmpty else {
            self.showAlert(withMessage: "Please pick the cuisine type before continuing!")
            return false
        }
        
        return true
    }
    
    fileprivate func showAlert(withMessage message: String) {
        let alert = UIAlertController(title: "Oops", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        rootViewController.present(alert, animated: true, completion: nil)
    }
}
