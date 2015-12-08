//
//  SignUpViewController.swift
//  Fhood
//
//  Created by YOUNG on 11/25/15.
//  Copyright © 2015 YOUNG&YOUM. All rights reserved.
//

import UIKit
import Parse

final class SignUpViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var scrollViewHeight: NSLayoutConstraint!
    
    @IBOutlet var firstNameTextfield: UITextField!
    @IBOutlet var lastNameTextfield: UITextField!
    
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var profilePicButton: UIButton!
    
    @IBOutlet var phoneNumberTextfield: UITextField!
    @IBOutlet var emailTextfield: UITextField!
    
    @IBOutlet var streetAddressTextfield: UITextField!
    @IBOutlet var aptAddressTextfield: UITextField!
    @IBOutlet var cityAddressTextfield: UITextField!
    @IBOutlet var stateAddressTextfield: UITextField!
    @IBOutlet var zipAddressTextfield: UITextField!
    
    @IBOutlet var nameOfShopTextfield: UITextField!
    @IBOutlet var shopDescriptionButton: UIButton!
    
    @IBOutlet var foodTypeOneTextfield: UITextField!
    @IBOutlet var foodTypeTwoTextfield: UITextField!
    @IBOutlet var foodTypeThreeTextfield: UITextField!
    
    @IBOutlet var typeOfFhooderSegment: UISegmentedControl!
    
    
    var firstName: String?
    var lastName: String?
    var picture: UIImage?
    var phoneNum: String?
    var email: String?
    var streetAdd: String?
    var aptAdd: String?
    var cityAdd: String?
    var stateAdd: String?
    var zipAdd: String?
    var shopName: String?
    var shopDescription: String?
    var foodTypeOne: String?
    var foodTypeTwo: String?
    var foodTypeThree: String?
    var certified: Bool = false
    
    var kbHeight: CGFloat!
    var frame: CGRect!
    
    var describeFhooder: Bool?
    
    
    var statePicker: UIPickerView!
    let statePickerValues = ["", "AL","AK","AZ","AR","CA","CO","CT","DE","FL","GA","HI","ID","IL", "IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ","NM","NY","NC","ND","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VT","VA","WA","WV","WI","WY"]

    var foodTypeOnePicker: UIPickerView!
    let foodTypeOnePickerValues = ["", "Chinese", "Japanese", "Korean"]
    
    var foodTypeTwoPicker: UIPickerView!
    let foodTypeTwoPickerValues = ["", "Sandwich", "Rice", "Burgers"]

    var foodTypeThreePicker: UIPickerView!
    let foodTypeThreePickerValues = ["", "Fried Rice", "Gimbap", "Salmon Rice"]
    
    
    let rootViewController: UIViewController = UIApplication.sharedApplication().windows[1].rootViewController!
    
    
    
    
    func loadProfile(notification: NSNotification){
        loadProfilePic()
        loadAboutMe()
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Sign Up"
        
        
        // Reload data
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadProfile:",name:"loadProfileView", object: nil)
        
        
        self.statePicker = UIPickerView()
        self.foodTypeOnePicker = UIPickerView()
        self.foodTypeTwoPicker = UIPickerView()
        self.foodTypeThreePicker = UIPickerView()
        
        // Scroll View height by Phone size
        // iPhone 6+/6s+ = 736 - 64
        // iPhone 6/6s   = 667 - 64
        // iPhone 5/5s   = 568 - 64
        self.scrollViewHeight.constant = 736 - 64
        
        // Textfield Delegate
        self.firstNameTextfield.delegate = self
        self.lastNameTextfield.delegate = self
        self.phoneNumberTextfield.delegate = self
        self.emailTextfield.delegate = self
        self.streetAddressTextfield.delegate = self
        self.cityAddressTextfield.delegate = self
        self.stateAddressTextfield.delegate = self
        self.zipAddressTextfield.delegate = self
        self.nameOfShopTextfield.delegate = self
        self.foodTypeOneTextfield.delegate = self
        self.foodTypeTwoTextfield.delegate = self
        self.foodTypeThreeTextfield.delegate = self
        
        
        self.statePicker.delegate = self
        self.foodTypeOnePicker.delegate = self
        self.foodTypeTwoPicker.delegate = self
        self.foodTypeThreePicker.delegate = self
        
        self.stateAddressTextfield.inputView = self.statePicker
        self.stateAddressTextfield.text = ""
        
        self.foodTypeOneTextfield.inputView = self.foodTypeOnePicker
        self.foodTypeOneTextfield.text = ""
        
        self.foodTypeTwoTextfield.inputView = self.foodTypeTwoPicker
        self.foodTypeTwoTextfield.text = ""
        
        self.foodTypeThreeTextfield.inputView = self.foodTypeThreePicker
        self.foodTypeThreeTextfield.text = ""
        
        
        // Load data from parse
        if PFUser.currentUser()?.objectForKey("firstName") != nil {
            self.firstNameTextfield.text = "\(PFUser.currentUser()!.objectForKey("firstName")!)"
            self.firstName = self.firstNameTextfield.text
        }
        if PFUser.currentUser()?.objectForKey("lastName") != nil {
            self.lastNameTextfield.text = "\(PFUser.currentUser()!.objectForKey("lastName")!)"
            self.lastName = self.lastNameTextfield.text!
        }
        
        loadProfilePic()
        
        if PFUser.currentUser()?.objectForKey("phone") != nil {
            self.phoneNumberTextfield.text = "\(PFUser.currentUser()!.objectForKey("phone")!)"
            self.lastName = self.phoneNumberTextfield.text!
        }
        if PFUser.currentUser()?.objectForKey("email") != nil {
            self.emailTextfield.text = "\(PFUser.currentUser()!.objectForKey("email")!)"
            self.email = self.emailTextfield.text!
        }
        
        loadAddress()
        
        loadAboutMe()

        
    }

    func loadProfilePic() {
        // Get picture from file(Parse)
        if PFUser.currentUser()?.objectForKey("profilePhoto") != nil {
            let userImageFile = PFUser.currentUser()!["profilePhoto"] as! PFFile
            userImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        self.profilePic.image = UIImage(data:imageData)
                        self.picture = self.profilePic.image
                        
                        // Profile pic becomes round
                        let image = UIImageView(image: self.profilePic.image)
                        self.profilePic.image = nil
                        image.frame = CGRectMake(0, 0, 50, 50)
                        image.layer.masksToBounds = false
                        image.layer.cornerRadius = 13
                        image.layer.cornerRadius = image.frame.size.height/2
                        image.clipsToBounds = true
                        self.profilePic.addSubview(image)
                        
                    }
                }
            }
        }
        else {
            // Get picture from Facebook(Parse)
            if PFUser.currentUser()?.objectForKey("pictureUrl") != nil {
                if let picURL = NSURL(string: "\(PFUser.currentUser()!.objectForKey("pictureUrl")!)") {
                    if let data = NSData(contentsOfURL: picURL) {
                        self.profilePic.image = UIImage(data: data)
                        self.picture = self.profilePic.image
                        
                        // Profile pic becomes round with white border
                        let image = UIImageView(image: self.profilePic.image)
                        self.profilePic.image = nil // Get rid of the duplicate
                        image.frame = CGRectMake(0, 0, 60, 60)
                        image.layer.masksToBounds = false
                        image.layer.borderColor = UIColor.whiteColor().CGColor
                        image.layer.cornerRadius = 13
                        image.layer.cornerRadius = image.frame.size.height/2
                        image.clipsToBounds = true
                        self.profilePic.addSubview(image)
                        
                    }
                }
            }
        }
    }
    
    func loadAddress() {
        if PFUser.currentUser()?.objectForKey("streetAddress") != nil && PFUser.currentUser()?.objectForKey("city") != nil && PFUser.currentUser()?.objectForKey("state") != nil && PFUser.currentUser()?.objectForKey("zip") != nil && PFUser.currentUser()?.objectForKey("country") != nil {
            self.streetAddressTextfield.text = "\(PFUser.currentUser()!.objectForKey("streetAddress")!)"
            self.streetAdd = self.streetAddressTextfield.text
            
            if PFUser.currentUser()?.objectForKey("unit") != nil {
                self.aptAddressTextfield.text = "\(PFUser.currentUser()!.objectForKey("unit")!)"
                self.aptAdd = self.aptAddressTextfield.text
            }
            self.cityAddressTextfield.text = "\(PFUser.currentUser()!.objectForKey("city")!)"
            self.cityAdd = self.cityAddressTextfield.text
            
            self.stateAddressTextfield.text = "\(PFUser.currentUser()!.objectForKey("state")!)"
            self.stateAdd = self.stateAddressTextfield.text
            
            self.zipAddressTextfield.text = "\(PFUser.currentUser()!.objectForKey("zip")!)"
            self.zipAdd = self.zipAddressTextfield.text
        }
    }

    func loadAboutMe() {
        // Get about me from Parse
        if PFUser.currentUser()?.objectForKey("aboutMe") != nil {
            let aboutMe = String(PFUser.currentUser()!.objectForKey("aboutMe")!)
            self.shopDescriptionButton.setTitle(aboutMe, forState: .Normal)
            self.shopDescriptionButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            self.shopDescription = aboutMe
            
            if aboutMe == "" {
                self.shopDescriptionButton.setTitle("About me", forState: .Normal)
                self.shopDescriptionButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
            }
        }
    }

    
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.firstNameTextfield {
            textField.text = textField.text?.capitalizedString
        }
        else if textField == self.lastNameTextfield {
            textField.text = textField.text?.capitalizedString
        }
        self.view.endEditing(true)
        return true
    }
    
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        // Auto phone number formatter
        if textField == self.phoneNumberTextfield {
            let newString = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
            let components = newString.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
            
            let decimalString : String = components.joinWithSeparator("")
            let length = decimalString.characters.count
            let decimalStr = decimalString as NSString
            let hasLeadingOne = length > 0 && decimalStr.characterAtIndex(0) == (1 as unichar)
            
            if length == 0 || (length > 10 && !hasLeadingOne) || length > 11
            {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                
                return (newLength > 10) ? false : true
            }
            var index = 0 as Int
            let formattedString = NSMutableString()
            
            if hasLeadingOne
            {
                formattedString.appendString("1 ")
                index += 1
            }
            if (length - index) > 3
            {
                let areaCode = decimalStr.substringWithRange(NSMakeRange(index, 3))
                formattedString.appendFormat("(%@)", areaCode)
                index += 3
            }
            if length - index > 3
            {
                let prefix = decimalStr.substringWithRange(NSMakeRange(index, 3))
                formattedString.appendFormat("%@-", prefix)
                index += 3
            }
            
            let remainder = decimalStr.substringFromIndex(index)
            formattedString.appendString(remainder)
            textField.text = formattedString as String
            return false
        }
        
        
        if textField == self.zipAddressTextfield {
            guard let text = textField.text else { return true }
            
            let newLength = text.utf16.count + string.utf16.count - range.length
            return newLength <= 5 // Bool
        }
        return true
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
    
    
    
    @IBAction func cancelButton(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    // Picker view
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
       
        if pickerView == self.statePicker {
            return statePickerValues.count
        }
        else if pickerView == self.foodTypeOnePicker {
            return foodTypeOnePickerValues.count
        }
        else if pickerView == self.foodTypeTwoPicker {
            return foodTypeTwoPickerValues.count
        }
        else if pickerView == self.foodTypeThreePicker {
            return foodTypeThreePickerValues.count
        }
        return 0
    }
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
        if pickerView == self.statePicker {
            return statePickerValues[row]
        }
        else if pickerView == self.foodTypeOnePicker {
            return foodTypeOnePickerValues[row]
        }
        else if pickerView == self.foodTypeTwoPicker {
            return foodTypeTwoPickerValues[row]
        }
        else if pickerView == self.foodTypeThreePicker {
            return foodTypeThreePickerValues[row]
        }
        
        return ""
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        if pickerView == self.statePicker {
            stateAddressTextfield.text = statePickerValues[row]
        }
        else if pickerView == self.foodTypeOnePicker {
            self.foodTypeOneTextfield.text = foodTypeOnePickerValues[row]
        }
        else if pickerView == self.foodTypeTwoPicker {
            self.foodTypeTwoTextfield.text = foodTypeTwoPickerValues[row]
        }
        else if pickerView == self.foodTypeThreePicker {
            self.foodTypeThreeTextfield.text = foodTypeThreePickerValues[row]
        }
    }
    
    
    
    

    private func validateInput() -> Bool {
        
        
        guard let firstname = self.firstNameTextfield.text where !firstname.isEmpty else {
            self.showAlert(withMessage: "Please enter your name before continuing!")
            return false
        }
        guard let lastname = self.lastNameTextfield.text where !lastname.isEmpty else {
            self.showAlert(withMessage: "Please enter your last name before continuing!")
            return false
        }
        
        if self.picture == nil {
            self.showAlert(withMessage: "Please provide profile picture before continuing!")
            return false
        }
        guard let phone = self.phoneNumberTextfield.text where !phone.isEmpty else {
            self.showAlert(withMessage: "Please enter your phone number before continuing!")
            return false
        }
        guard let email = self.emailTextfield.text where !email.isEmpty else {
            self.showAlert(withMessage: "Please enter an email before continuing!")
            return false
        }
        if self.streetAddressTextfield.text == "" || self.cityAddressTextfield.text == "" || self.stateAddressTextfield.text == "" || self.zipAddressTextfield.text == "" {
            self.showAlert(withMessage: "Please enter your address before saving!")
            return false
        }
        guard let shopname = self.nameOfShopTextfield.text where !shopname.isEmpty else {
            self.showAlert(withMessage: "Please enter the shop name before continuing!")
            return false
        }
        guard let description = self.shopDescription where !description.isEmpty else {
            self.showAlert(withMessage: "Please fill out your description before continuing!")
            return false
        }
        guard let typeOne = self.foodTypeOneTextfield.text where !typeOne.isEmpty else {
            self.showAlert(withMessage: "Please select the food type before continuing!")
            return false
        }
        guard let typeTwo = self.foodTypeTwoTextfield.text where !typeTwo.isEmpty else {
            self.showAlert(withMessage: "Please select the food type before continuing!")
            return false
        }
        guard let typeThree = self.foodTypeThreeTextfield.text where !typeThree.isEmpty else {
            self.showAlert(withMessage: "Please select the food type before continuing!")
            return false
        }
        
        
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$"
        let pattern = try! NSRegularExpression(pattern: emailRegex, options: [])
        let strRange = NSRange(location: 0, length: email.characters.count)
        guard pattern.firstMatchInString(email, options: [], range: strRange) != nil else {
            self.showAlert(withMessage: "Please, enter a valid email before continuing!")
            return false
        }
        
        
        return true
    }
    
    @IBAction func typeOfFhooderSegment(sender: AnyObject) {
        
        switch typeOfFhooderSegment.selectedSegmentIndex {
        case 0:
            self.certified = false
            
        case 1:
            self.certified = true
        default:
            break;
        }
        
    }
    
    private func showAlert(withMessage message: String) {
        let alert = UIAlertController(title: "Oops", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        rootViewController.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func submitButton(sender: UIBarButtonItem) {
        
        if validateInput() {
            
            let user = PFUser.currentUser()
            
            
            let applicant = PFObject(className: "Fhooder")
            applicant["firstName"] = self.firstNameTextfield.text
            applicant["lastName"] = self.lastNameTextfield.text
            
            let imageData = self.picture!.lowestQualityJPEGNSData
            let imageFile = PFFile(name: "profile.png", data: imageData)
            applicant["profilePic"] = imageFile
            
            applicant["phone"] = self.phoneNumberTextfield.text
            applicant["email"] = self.emailTextfield.text
            
            applicant["country"] = "United States"
            applicant["streetAddress"] = self.streetAddressTextfield.text
            applicant["unitAddress"] = self.aptAddressTextfield.text
            applicant["city"] = self.cityAddressTextfield.text
            applicant["state"] = self.stateAddressTextfield.text
            applicant["zip"] = self.zipAddressTextfield.text
            
            applicant["shopName"] = self.nameOfShopTextfield.text
            applicant["shopDescription"] = self.shopDescription
            
            applicant["foodTypeOne"] = self.foodTypeOneTextfield.text
            applicant["foodTypeTwo"] = self.foodTypeTwoTextfield.text
            applicant["foodTypeThree"] = self.foodTypeThreeTextfield.text
            
            applicant["certified"] = self.certified
            
            applicant["status"] = "Pending"
            
            
            applicant.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                if success {
                    
                    self.view.endEditing(true)
                    
                    user!["applied"] = true
                    
                    do {
                        try user!.save()
                    }
                    catch {
                            let alert = UIAlertController(title: "", message:"There was an erro!", preferredStyle: .Alert)
                            let error = UIAlertAction(title: "Ok", style: .Default) { _ in}
                            alert.addAction(error)
                            self.rootViewController.presentViewController(alert, animated: true, completion: nil)

                    }
                    
                    
                    let alert = UIAlertController(title: "Submitted", message:"Thank you for your submission. We will contact you with further instructions soon.", preferredStyle: .Alert)
                    let saved = UIAlertAction(title: "Ok!", style: .Default) { _ in}
                    alert.addAction(saved)
                    self.rootViewController.presentViewController(alert, animated: true, completion: nil)
                    variables.fhooderSignedIn = false
                    Router.route(animated: true)

                }
                else {
                    self.showAlert(withMessage: "Something went wrong!")
                }
            }
        }
    }

}
