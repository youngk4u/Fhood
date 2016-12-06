//
//  SignUpViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 11/25/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
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
    
    let foodType = ["", "American", "Argentinian", "Asian", "BBQ", "Bagels", "Bakery", "Bento", "Brazilian", "Breakfast", "Californian", "Calzones", "Cantonese", "Caribbean", "Cheesesteaks", "Chicken", "Chinese", "Coffee", "Cold Pressed", "Crepes", "Cuban", "Deli", "Dessert", "Dim Sum", "Diner", "Dinner", "Eclectic", "Empanadas", "European", "Fish and Chips", "French", "Fusion", "German", "Gluten-Free", "Greek", "Grill", "Grilled Cheese", "Gyro", "Halal", "Hamburgers", "Hawaiian", "Healthy", "Hoagies", "Hot Dogs", "Ice Cream", "Indian", "Indonesian", "Italian", "Japanese", "Kids Menu", "Korean", "Kosher", "Kosher-Style", "Late Night", "Latin American", "Lebanese", "Lemonade", "Low Carb", "Low Fat", "Lunch", "Mandarin", "Meatloaf", "Mediterranean", "Mexican", "Middle Eastern", "Mini Sliders", "New American", "Noodles", "Organic", "Pasta", "Persian", "Peruvian", "Pitas", "Pizza", "Pork Buns", "Potato", "Pub Food", "Ribs", "Rice Bowl", "Russian", "Salads", "Sandwiches", "Seafood", "Smoothies and Juices", "Soul Food", "Soup", "Steak", "Subs", "Sushi", "Shawarma", "Szechwan", "Tapas", "Tea", "Thai", "Vegan", "Vegetarian", "Vietnamese", "Water", "Wings", "Wraps", "Other"]
    
    var foodTypeOnePicker: UIPickerView!
    var foodTypeOnePickerValues : [String]!
    var foodTypeTwoPicker: UIPickerView!
    var foodTypeTwoPickerValues : [String]!
    var foodTypeThreePicker: UIPickerView!
    var foodTypeThreePickerValues : [String]!
    
    let rootViewController: UIViewController = UIApplication.shared.windows[1].rootViewController!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Sign Up"
        
        
        // Reload data
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.loadProfile(_:)),name:NSNotification.Name(rawValue: "loadProfileView"), object: nil)
        
        
        self.statePicker = UIPickerView()
        self.foodTypeOnePicker = UIPickerView()
        self.foodTypeTwoPicker = UIPickerView()
        self.foodTypeThreePicker = UIPickerView()
        
        // Scroll View height by Phone size
        // iPhone 6+/6s+ = 736 - 64
        // iPhone 6/6s   = 667 - 64
        // iPhone 5/5s   = 568 - 64
        self.scrollViewHeight.constant = 667 - 64
        
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
        self.foodTypeOnePickerValues = self.foodType
        
        self.foodTypeTwoTextfield.inputView = self.foodTypeTwoPicker
        self.foodTypeTwoTextfield.text = ""
        self.foodTypeTwoPickerValues = self.foodType
        
        self.foodTypeThreeTextfield.inputView = self.foodTypeThreePicker
        self.foodTypeThreeTextfield.text = ""
        self.foodTypeThreePickerValues = self.foodType
        
        
        // Load data from parse
        if PFUser.current()?.object(forKey: "firstName") != nil {
            self.firstNameTextfield.text = "\(PFUser.current()!.object(forKey: "firstName")!)"
            self.firstName = self.firstNameTextfield.text
        }
        if PFUser.current()?.object(forKey: "lastName") != nil {
            self.lastNameTextfield.text = "\(PFUser.current()!.object(forKey: "lastName")!)"
            self.lastName = self.lastNameTextfield.text!
        }
        
        loadProfilePic()
        
        if PFUser.current()?.object(forKey: "phone") != nil {
            self.phoneNumberTextfield.text = "\(PFUser.current()!.object(forKey: "phone")!)"
            self.lastName = self.phoneNumberTextfield.text!
        }
        if PFUser.current()?.object(forKey: "email") != nil {
            self.emailTextfield.text = "\(PFUser.current()!.object(forKey: "email")!)"
            self.email = self.emailTextfield.text!
        }
        
        loadAddress()
        
        loadAboutMe()

        
    }
    
    
    func loadProfile(_ notification: Notification){
        loadProfilePic()
        loadAboutMe()
    }
    

    func loadProfilePic() {
        // Get picture from file(Parse)
        if PFUser.current()?.object(forKey: "profilePhoto") != nil {
            let userImageFile = PFUser.current()!["profilePhoto"] as! PFFile
            userImageFile.getDataInBackground {
                (imageData: Data?, error: Error?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        self.profilePic.image = UIImage(data:imageData)
                        self.picture = self.profilePic.image
                        
                        // Profile pic becomes round
                        let image = UIImageView(image: self.profilePic.image)
                        self.profilePic.image = nil
                        image.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
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
            if PFUser.current()?.object(forKey: "pictureUrl") != nil {
                if let picURL = URL(string: "\(PFUser.current()!.object(forKey: "pictureUrl")!)") {
                    if let data = try? Data(contentsOf: picURL) {
                        self.profilePic.image = UIImage(data: data)
                        self.picture = self.profilePic.image
                        
                        // Profile pic becomes round with white border
                        let image = UIImageView(image: self.profilePic.image)
                        self.profilePic.image = nil // Get rid of the duplicate
                        image.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
                        image.layer.masksToBounds = false
                        image.layer.borderColor = UIColor.white.cgColor
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
        if PFUser.current()?.object(forKey: "streetAddress") != nil && PFUser.current()?.object(forKey: "city") != nil && PFUser.current()?.object(forKey: "stateProvince") != nil && PFUser.current()?.object(forKey: "zip") != nil && PFUser.current()?.object(forKey: "country") != nil {
            self.streetAddressTextfield.text = "\(PFUser.current()!.object(forKey: "streetAddress")!)"
            self.streetAdd = self.streetAddressTextfield.text
            
            if PFUser.current()?.object(forKey: "unit") != nil {
                self.aptAddressTextfield.text = "\(PFUser.current()!.object(forKey: "unit")!)"
                self.aptAdd = self.aptAddressTextfield.text
            }
            self.cityAddressTextfield.text = "\(PFUser.current()!.object(forKey: "city")!)"
            self.cityAdd = self.cityAddressTextfield.text
            
            self.stateAddressTextfield.text = "\(PFUser.current()!.object(forKey: "stateProvince")!)"
            self.stateAdd = self.stateAddressTextfield.text
            
            self.zipAddressTextfield.text = "\(PFUser.current()!.object(forKey: "zip")!)"
            self.zipAdd = self.zipAddressTextfield.text
        }
    }

    func loadAboutMe() {
        // Get about me from Parse
        if PFUser.current()?.object(forKey: "aboutMe") != nil {
            let aboutMe = String(describing: PFUser.current()!.object(forKey: "aboutMe")!)
            self.shopDescriptionButton.setTitle(aboutMe, for: UIControlState())
            self.shopDescriptionButton.setTitleColor(UIColor.black, for: UIControlState())
            self.shopDescription = aboutMe
            
            if aboutMe == "" {
                self.shopDescriptionButton.setTitle("About me", for: UIControlState())
                self.shopDescriptionButton.setTitleColor(UIColor.lightGray, for: UIControlState())
            }
        }
    }

    
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.firstNameTextfield {
            textField.text = textField.text?.capitalized
        }
        else if textField == self.lastNameTextfield {
            textField.text = textField.text?.capitalized
        }
        else if textField == self.nameOfShopTextfield {
            textField.text = textField.text?.capitalized
        }
        self.view.endEditing(true)
        return true
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Auto phone number formatter
        if textField == self.phoneNumberTextfield {
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let components = newString.components(separatedBy: CharacterSet.decimalDigits.inverted)
            
            let decimalString : String = components.joined(separator: "")
            let length = decimalString.characters.count
            let decimalStr = decimalString as NSString
            let hasLeadingOne = length > 0 && decimalStr.character(at: 0) == (1 as unichar)
            
            if length == 0 || (length > 10 && !hasLeadingOne) || length > 11
            {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                
                return (newLength > 10) ? false : true
            }
            var index = 0 as Int
            let formattedString = NSMutableString()
            
            if hasLeadingOne
            {
                formattedString.append("1 ")
                index += 1
            }
            if (length - index) > 3
            {
                let areaCode = decimalStr.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat("(%@)", areaCode)
                index += 3
            }
            if length - index > 3
            {
                let prefix = decimalStr.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat("%@-", prefix)
                index += 3
            }
            
            let remainder = decimalStr.substring(from: index)
            formattedString.append(remainder)
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
    
    
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    // Picker view
    func numberOfComponentsInPickerView(_ pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
       
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
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
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
    
    
    
    

    fileprivate func validateInput() -> Bool {
        
        
        guard let firstname = self.firstNameTextfield.text, !firstname.isEmpty else {
            self.showAlert(withMessage: "Please enter your name before continuing!")
            return false
        }
        guard let lastname = self.lastNameTextfield.text, !lastname.isEmpty else {
            self.showAlert(withMessage: "Please enter your last name before continuing!")
            return false
        }
        
        if self.picture == nil {
            self.showAlert(withMessage: "Please provide profile picture before continuing!")
            return false
        }
        guard let phone = self.phoneNumberTextfield.text, !phone.isEmpty else {
            self.showAlert(withMessage: "Please enter your phone number before continuing!")
            return false
        }
        guard let email = self.emailTextfield.text, !email.isEmpty else {
            self.showAlert(withMessage: "Please enter an email before continuing!")
            return false
        }
        if self.streetAddressTextfield.text == "" || self.cityAddressTextfield.text == "" || self.stateAddressTextfield.text == "" || self.zipAddressTextfield.text == "" {
            self.showAlert(withMessage: "Please enter your address before saving!")
            return false
        }
        guard let shopname = self.nameOfShopTextfield.text, !shopname.isEmpty else {
            self.showAlert(withMessage: "Please enter the shop name before continuing!")
            return false
        }
        guard let description = self.shopDescription, !description.isEmpty else {
            self.showAlert(withMessage: "Please fill out your description before continuing!")
            return false
        }
        guard let typeOne = self.foodTypeOneTextfield.text, !typeOne.isEmpty else {
            self.showAlert(withMessage: "Please select the food type before continuing!")
            return false
        }
        guard let typeTwo = self.foodTypeTwoTextfield.text, !typeTwo.isEmpty else {
            self.showAlert(withMessage: "Please select the food type before continuing!")
            return false
        }
        guard let typeThree = self.foodTypeThreeTextfield.text, !typeThree.isEmpty else {
            self.showAlert(withMessage: "Please select the food type before continuing!")
            return false
        }
        
        
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$"
        let pattern = try! NSRegularExpression(pattern: emailRegex, options: [])
        let strRange = NSRange(location: 0, length: email.characters.count)
        guard pattern.firstMatch(in: email, options: [], range: strRange) != nil else {
            self.showAlert(withMessage: "Please, enter a valid email before continuing!")
            return false
        }
        
        
        return true
    }
    
    @IBAction func typeOfFhooderSegment(_ sender: AnyObject) {
        
        self.view.endEditing(true)
        
        switch typeOfFhooderSegment.selectedSegmentIndex {
        case 0:
            self.certified = false
            
        case 1:
            self.certified = true
        default:
            break;
        }
        
    }
    
    fileprivate func showAlert(withMessage message: String) {
        let alert = UIAlertController(title: "Oops", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        rootViewController.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func submitButton(_ sender: UIBarButtonItem) {
        
        if validateInput() {
            
            let user = PFUser.current()
            
            // Make a new object under Fhooder class in Parse
            let applicant = PFObject(className: "Fhooder")
            applicant["firstName"] = self.firstNameTextfield.text
            applicant["lastName"] = self.lastNameTextfield.text
            
            let imageData = self.picture!.lowestQualityJPEGNSData
            let imageFile = PFFile(name: "profile.png", data: imageData as Data)
            applicant["profilePic"] = imageFile
            
            applicant["phone"] = self.phoneNumberTextfield.text
            applicant["email"] = self.emailTextfield.text
            
            applicant["country"] = "United States"
            applicant["streetAddress"] = self.streetAddressTextfield.text
            applicant["unitAddress"] = self.aptAddressTextfield.text
            applicant["city"] = self.cityAddressTextfield.text
            applicant["stateProvince"] = self.stateAddressTextfield.text
            applicant["zip"] = self.zipAddressTextfield.text
            
            let address = "\(self.streetAddressTextfield.text), \(self.cityAddressTextfield.text), \(self.stateAddressTextfield.text), \(self.zipAddressTextfield.text), USA"
            let geocoder = CLGeocoder()
            
            geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
                if ((error) != nil) {
                    
                    let alert = UIAlertController(title: "", message:"There was an error!", preferredStyle: .alert)
                    let error = UIAlertAction(title: "Ok", style: .default) { _ in}
                    alert.addAction(error)

                }
                if let placemark = placemarks?.first {
                    let coordinates: CLLocationCoordinate2D = placemark.location!.coordinate
                    let geolocation = PFGeoPoint(latitude: coordinates.latitude, longitude: coordinates.longitude)
                    applicant["location"] = geolocation
                }
                })
            
            applicant["shopName"] = self.nameOfShopTextfield.text
            applicant["shopDescription"] = self.shopDescription
            
            applicant["foodTypeOne"] = self.foodTypeOneTextfield.text
            applicant["foodTypeTwo"] = self.foodTypeTwoTextfield.text
            applicant["foodTypeThree"] = self.foodTypeThreeTextfield.text
            
            applicant["certified"] = self.certified
            
            applicant["status"] = "Pending"
            applicant["userID"] = PFUser.current()?.objectId
            
            applicant["ratings"] = 0
            applicant["reviews"] = 0
            applicant["isOpen"] = false
            applicant["isPickup"] = false
            applicant["isDeliver"] = false
            applicant["isEatin"] = false
            
            let acl = PFACL()
            acl.getPublicReadAccess = true
            acl.getPublicWriteAccess = true
            
            applicant.acl = acl
            
            
            applicant.saveInBackground { (success: Bool, error: Error?) -> Void in
                if success {
                    
                    self.view.endEditing(true)
                    
                    user!["fhooder"] = applicant
                    user!["applied"] = true
                    user!["fhooderId"] = applicant.objectId
                    
                    do {
                        try user!.save()
                    }
                    catch {
                            let alert = UIAlertController(title: "", message:"There was an error!", preferredStyle: .alert)
                            let error = UIAlertAction(title: "Ok", style: .default) { _ in}
                            alert.addAction(error)
                            self.rootViewController.present(alert, animated: true, completion: nil)

                    }
                    
                    // Push notification to admin
                    let push = PFPush()
                    push.setChannel("admin")
                    push.setMessage("You have a new Fhooder: \(self.firstNameTextfield.text!) \(self.lastNameTextfield.text!) \(self.phoneNumberTextfield.text!)")
                    push.sendInBackground()
                    
                    let alert = UIAlertController(title: "Submitted", message:"Thank you for your submission. We will contact you with further instructions soon.", preferredStyle: .alert)
                    let saved = UIAlertAction(title: "Ok!", style: .default) { _ in}
                    alert.addAction(saved)
                    self.rootViewController.present(alert, animated: true, completion: nil)
                    Fhooder.fhooderSignedIn = false
                    Router.route(true)

                }
                else {
                    self.showAlert(withMessage: "Something went wrong!")
                }
            }
        }
    }

}
