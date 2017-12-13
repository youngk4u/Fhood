//
//  ReceiptViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 10/26/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
//

import UIKit
import Parse
import Braintree
import PassKit
import OneSignal

final class ReceiptViewController: UIViewController, BTDropInViewControllerDelegate, PKPaymentAuthorizationViewControllerDelegate  {
    
    @IBOutlet weak var fhooderName: UILabel!
    
    @IBOutlet weak var subTotal: UILabel!
    @IBOutlet weak var taxesAndFees: UILabel!
    @IBOutlet weak var totalAmountDue: UILabel!
    
    @IBOutlet weak var quantityOne: UILabel!
    @IBOutlet weak var quantityTwo: UILabel!
    @IBOutlet weak var quantityThree: UILabel!
    @IBOutlet weak var quantityFour: UILabel!
    @IBOutlet weak var quantityFive: UILabel!
    @IBOutlet weak var quantitySix: UILabel!
    @IBOutlet weak var quantitySeven: UILabel!
    var quantityArray: [Int] = []
    
    @IBOutlet weak var itemOne: UILabel!
    @IBOutlet weak var itemTwo: UILabel!
    @IBOutlet weak var itemThree: UILabel!
    @IBOutlet weak var itemFour: UILabel!
    @IBOutlet weak var itemFive: UILabel!
    @IBOutlet weak var itemSix: UILabel!
    @IBOutlet weak var itemSeven: UILabel!
    var itemNameArray: [String] = []
    
    @IBOutlet weak var priceOne: UILabel!
    @IBOutlet weak var priceTwo: UILabel!
    @IBOutlet weak var priceThree: UILabel!
    @IBOutlet weak var priceFour: UILabel!
    @IBOutlet weak var priceFive: UILabel!
    @IBOutlet weak var priceSix: UILabel!
    @IBOutlet weak var priceSeven: UILabel!
    var priceTextArray: [String] = ["","","","","","",""]
    var priceArrayDouble: [Double] = []
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    var currentDate: Date!
    var newDate: Date!
    var newDate2: Date!
    var closeDate: Date!
    var userImageFile: PFFile!
    
    var braintreeClient: BTAPIClient?
    var orderSuccess: Bool = false
    var formatter = NumberFormatter()
    
    @IBOutlet weak var completOrderButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.8)
        
        
        self.fhooderName.text = Fhooder.shopName!
        
        // Currency formatter
        self.formatter.numberStyle = .currency
        
        // Put the order list on the receipt
        for x in 0 ..< Fhoodie.selectedItemCount!.count {
            
            if x == 0 && x < Fhoodie.selectedItemCount!.count {
                self.quantityOne.text = String("\(Fhoodie.selectedItemCount![0])")
                self.quantityArray.append(Fhoodie.selectedItemCount![0])
                self.itemOne.text = Fhoodie.selectedItemNames![0]
                self.itemNameArray.append(Fhoodie.selectedItemNames![0])
                self.priceOne.text = formatter.string(from: (Fhoodie.selectedItemPrices![0] * Double(Fhoodie.selectedItemCount![0]) as NSNumber))
                self.priceTextArray[0] = self.priceOne.text!
            } else if x == 1 && x < Fhoodie.selectedItemCount!.count {
                self.quantityTwo.text = String("\(Fhoodie.selectedItemCount![1])")
                self.quantityArray.append(Fhoodie.selectedItemCount![1])
                self.itemTwo.text = Fhoodie.selectedItemNames![1]
                self.itemNameArray.append(Fhoodie.selectedItemNames![1])
                self.priceTwo.text = formatter.string(from: (Fhoodie.selectedItemPrices![1] * Double(Fhoodie.selectedItemCount![1]) as NSNumber))
                self.priceTextArray[1] = self.priceTwo.text!
            } else if x == 2 && x < Fhoodie.selectedItemCount!.count {
                self.quantityThree.text = String("\(Fhoodie.selectedItemCount![2])")
                self.quantityArray.append(Fhoodie.selectedItemCount![2])
                self.itemThree.text = Fhoodie.selectedItemNames![2]
                self.itemNameArray.append(Fhoodie.selectedItemNames![2])
                self.priceThree.text = formatter.string(from: (Fhoodie.selectedItemPrices![2] * Double(Fhoodie.selectedItemCount![2]) as NSNumber))
                self.priceTextArray[2] = self.priceThree.text!
            } else if x == 3 && x < Fhoodie.selectedItemCount!.count {
                self.quantityFour.text = String("\(Fhoodie.selectedItemCount![3])")
                self.quantityArray.append(Fhoodie.selectedItemCount![3])
                self.itemFour.text = Fhoodie.selectedItemNames![3]
               self.itemNameArray.append(Fhoodie.selectedItemNames![3])
                self.priceFour.text = formatter.string(from: (Fhoodie.selectedItemPrices![3] * Double(Fhoodie.selectedItemCount![3]) as NSNumber))
                self.priceTextArray[3] = self.priceFour.text!
            } else if x == 4 && x < Fhoodie.selectedItemCount!.count {
                self.quantityFive.text = String("\(Fhoodie.selectedItemCount![4])")
                self.quantityArray.append(Fhoodie.selectedItemCount![4])
                self.itemFive.text = Fhoodie.selectedItemNames![4]
                self.itemNameArray.append(Fhoodie.selectedItemNames![4])
                self.priceFive.text = formatter.string(from: (Fhoodie.selectedItemPrices![4] * Double(Fhoodie.selectedItemCount![4]) as NSNumber))
                self.priceTextArray[4] = self.priceFive.text!
            } else if x == 5 && x < Fhoodie.selectedItemCount!.count {
                self.quantitySix.text = String("\(Fhoodie.selectedItemCount![5])")
                self.quantityArray.append(Fhoodie.selectedItemCount![5])
                self.itemSix.text = Fhoodie.selectedItemNames![5]
                self.itemNameArray.append(Fhoodie.selectedItemNames![5])
                self.priceSix.text = formatter.string(from: (Fhoodie.selectedItemPrices![5] * Double(Fhoodie.selectedItemCount![5]) as NSNumber))
                self.priceTextArray[5] = self.priceSix.text!
            } else if x == 6 && x < Fhoodie.selectedItemCount!.count {
                self.quantitySeven.text = String("\(Fhoodie.selectedItemCount![6])")
                self.quantityArray.append(Fhoodie.selectedItemCount![6])
                self.itemSeven.text = Fhoodie.selectedItemNames![6]
                self.itemNameArray.append(Fhoodie.selectedItemNames![6])
                self.priceSeven.text = formatter.string(from: (Fhoodie.selectedItemPrices![6] * Double(Fhoodie.selectedItemCount![6]) as NSNumber))
                self.priceTextArray[6] = self.priceSeven.text!
            } else {
                return
            }
            
        }
        
        // Braintree fee (2.9% + 30 cents) and taxes (7.1% - Stripe) added to every order
        self.subTotal.text = formatter.string(from: Fhoodie.selectedTotalItemPrice! as NSNumber)
        self.taxesAndFees.text = formatter.string(from: (Fhoodie.selectedTotalItemPrice! * 0.1 + 0.3) as NSNumber)
        Fhoodie.totalDue = Fhoodie.selectedTotalItemPrice! + Fhoodie.selectedTotalItemPrice! * 0.1 + 0.3
        self.totalAmountDue.text = formatter.string(from: Fhoodie.totalDue! as NSNumber)
        
        
        
        let query = PFQuery(className: "Fhooder")
        query.getObjectInBackground(withId: Fhooder.objectID!) { (fhooder: PFObject?, error: Error?) -> Void in
            if error == nil && fhooder != nil {
                
                
                // Time Picker
                self.timePicker.datePickerMode = UIDatePickerMode.time // use time only
                
                var openTime : String!
                var closeTime : String!
                
                openTime = fhooder!.value(forKey: "openTime") as? String
                closeTime = fhooder!.value(forKey: "closeTime") as? String
                
                // Get open time and close time from Parse
                if  openTime == "Now" {
                    self.currentDate = Date()
                    self.newDate = Date(timeInterval: (15 * 60), since: self.currentDate)
                    self.timePicker.minimumDate = self.newDate
                }
                else {
                    
                    let timeFormatter = DateFormatter()
                    timeFormatter.locale = Locale(identifier: "en_US_POSIX")
                    timeFormatter.dateFormat = "hh:mm a"
                    
                    let time = timeFormatter.date(from: openTime)
                    self.currentDate = time
                    
                    self.newDate = Date(timeInterval: (15 * 60), since: self.currentDate)  // add 15 minutes

                    self.timePicker.minimumDate = self.newDate // set the current date/time as a minimum
                    
                    
                    let compareResult = self.newDate.compare(Date())
                    
                    if compareResult == ComparisonResult.orderedAscending {
                        self.timePicker.date = self.newDate // defaults to current time but shows how to use it.
                    }
                    else {
                        self.timePicker.date = Date()
                    }
                    
                }
                
                if  closeTime == "Later" {
                    
                }
                else {
                    
                    let timeFormatter = DateFormatter()
                    timeFormatter.locale = Locale(identifier: "en_US_POSIX")
                    timeFormatter.dateFormat = "hh:mm a"
                    
                    let time = timeFormatter.date(from: closeTime)
                    self.closeDate = time
                    
                    self.newDate2 = Date(timeInterval: (5 * 60), since: self.closeDate)
                    self.timePicker.maximumDate = self.newDate2

                }

            }
            
        }
        
        
        
        
        
        // Braintree
        
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: [PKPaymentNetwork.visa, PKPaymentNetwork.masterCard, PKPaymentNetwork.amex]) {
            
            self.completOrderButton.addTarget(self, action: #selector(ReceiptViewController.tappedApplePay), for: UIControlEvents.touchUpInside)
        }
        
        
        let clientTokenURL = URL(string: "https://braintree-sample-merchant.herokuapp.com/client_token")!
        let clientTokenRequest = NSMutableURLRequest(url: clientTokenURL)
        clientTokenRequest.setValue("text/plain", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: clientTokenRequest as URLRequest, completionHandler: { (data, response, error) -> Void in
            // TODO: Handle errors
            let clientToken = String(data: data!, encoding: String.Encoding.utf8)
            
            self.braintreeClient = BTAPIClient(authorization: clientToken!)
            // As an example, you may wish to present our Drop-in UI at this point.
            // Continue to the next section to learn more...
            }) .resume()
        
    }
    
    
//    func applePayButton() -> UIButton {
//        var button: UIButton?
//        
//        if #available(iOS 10.0, *) { // Available in iOS 8.3+
//            button = PKPaymentButton(type: PKPaymentButtonType.Buy, style: PKPaymentButtonStyle.Black)
//        } else {
//            // TODO: Create and return your own apple pay button
//            // button = ...
//        }
//        
//        button?.addTarget(self, action: #selector(ConfirmViewController.tappedApplePay), forControlEvents: UIControlEvents.TouchUpInside)
//        
//        return button!
//    }
    
    
    
    @objc func tappedApplePay() {
        let paymentRequest = self.paymentRequest()
        // Example: Promote PKPaymentAuthorizationViewController to optional so that we can verify
        // that our paymentRequest is valid. Otherwise, an invalid paymentRequest would crash our app.
        if let vc = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
            as PKPaymentAuthorizationViewController?
        {
            vc.delegate = self
            present(vc, animated: true, completion: nil)
            
        } else {
            print("Error: Payment request is invalid.")
        }
    }
    
    
    func paymentRequest() -> PKPaymentRequest {
        let paymentRequest = PKPaymentRequest()
        paymentRequest.merchantIdentifier = "merchant.com.example.fhood";
        paymentRequest.supportedNetworks = [PKPaymentNetwork.amex, PKPaymentNetwork.visa, PKPaymentNetwork.masterCard];
        paymentRequest.merchantCapabilities = PKMerchantCapability.capability3DS;
        paymentRequest.countryCode = "US"; // e.g. US
        paymentRequest.currencyCode = "USD"; // e.g. USD
        paymentRequest.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "SUBTOTAL", amount: NSDecimalNumber(value: Fhoodie.selectedTotalItemPrice! as Double)),
            PKPaymentSummaryItem(label: "TAXES AND FEES", amount: NSDecimalNumber(value: (Fhoodie.selectedTotalItemPrice! * 0.1 + 0.3) as Double)),
            PKPaymentSummaryItem(label: "TOTAL", amount: NSDecimalNumber(value: Fhoodie.totalDue! as Double)),
            PKPaymentSummaryItem(label: Fhooder.shopName!, amount: NSDecimalNumber(value: Fhoodie.totalDue! as Double))
        ]
        return paymentRequest
    }
    
    
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController,
                                            didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        
        // Example: Tokenize the Apple Pay payment
        let applePayClient = BTApplePayClient(apiClient: braintreeClient!)
        applePayClient.tokenizeApplePay(payment) { (tokenizedApplePayPayment, error) in
            guard let tokenizedApplePayPayment = tokenizedApplePayPayment else {
                // Tokenization failed. Check `error` for the cause of the failure.
                
                // Indicate failure via completion callback.
                completion(PKPaymentAuthorizationStatus.failure)
                
                return
            }
            
            // Received a tokenized Apple Pay payment from Braintree.
            // If applicable, address information is accessible in `payment`.
            
            // Send the nonce to your server for processing.
            print("nonce = \(tokenizedApplePayPayment.nonce)")
            self.orderSuccess = true 
            
            // Then indicate success or failure via the completion callback, e.g.
            completion(PKPaymentAuthorizationStatus.success)
            
            
        }
    }
    
    // Be sure to implement paymentAuthorizationViewControllerDidFinish.
    // You are responsible for dismissing the view controller in this method.
    @available(iOS 8.0, *)
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController)
    {
        dismiss(animated: true, completion: nil)
        
        if orderSuccess == true {
            self.completeOrder()
        }
    }
    

    
    func drop(_ viewController: BTDropInViewController,
                              didSucceedWithTokenization paymentMethodNonce: BTPaymentMethodNonce)
    {
        // Send payment method nonce to your server for processing
        postNonceToServer(paymentMethodNonce.nonce)
        dismiss(animated: true, completion: nil)
    }
    
    func drop(inViewControllerDidCancel viewController: BTDropInViewController) {
        dismiss(animated: true, completion: nil)
    }

    
    func userDidCancelPayment() {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func postNonceToServer(_ paymentMethodNonce: String) {
        let paymentURL = URL(string: "http://fhood.com/fhoodFiles/braintree.py")!
        let request = NSMutableURLRequest(url: paymentURL)
        request.httpBody = "payment_method_nonce=\(paymentMethodNonce)".data(using: String.Encoding.utf8)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            // TODO: Handle success or failure
            }) .resume()
    }
    
    
    
    
    
    
    
    
    
    
    
    func pushNotification () {
        
//        let uQuery = PFUser.query()!
//        uQuery.whereKey("fhooderId", equalTo: Fhooder.objectID!)
//        
//        let iQuery = PFInstallation.query()!
//        iQuery.whereKey("user", matchesQuery: uQuery)
//        
//        let push : PFPush = PFPush()
//        push.setQuery(iQuery as? PFQuery<PFInstallation>)
//    
//        let pushData : NSDictionary = NSDictionary(objects: ["You've got an order!", "ordered", "1", "true"], forKeys: ["alert" as NSCopying, "type" as NSCopying, "badge" as NSCopying, "sound" as NSCopying])
//        push.setData(pushData as? [AnyHashable: Any])
//        
//        do {
//            try push.send()
//        } catch {
//            print("Push didn't work")
//        }
        
        
        OneSignal.postNotification(["contents": ["en": "Test Message"], "include_player_ids": ["0db758e2-584a-4810-aad6-21f05e7bcb94"]])
        

    }
    
    
    func completeOrder() {
        let alert = UIAlertController(title: "Thank You!", message:"Your order has been successfully placed.", preferredStyle: .alert)
        let proceed = UIAlertAction(title: "Proceed", style: .default) { (action: UIAlertAction!) -> () in
            
            HUD.show()
            
            let user = PFUser.query()
            let userID = PFUser.current()!.objectId!
            let fhooderID = Fhooder.objectID!
            self.priceArrayDouble = Fhoodie.selectedItemPrices!
            
            user?.getObjectInBackground(withId: userID, block: { (user: PFObject?, error: Error?) -> Void in
                
                if PFUser.current()!.object(forKey: "profilePhoto") != nil {
                    self.userImageFile = PFUser.current()!["profilePhoto"] as? PFFile
                }
                
                let userName = PFUser.current()!.object(forKey: "firstName")
                let order = PFObject(className: "Orders")
                order["userPic"] = self.userImageFile
                order["userName"] = userName
                order["userId"] = userID
                order["fhooderId"] = fhooderID
                order["itemsId"] = Fhoodie.selectedItemObjectId!
                order["itemQty"] = Fhoodie.selectedItemCount!
                order["pickupTime"] = self.timePicker.date
                order["orderStatus"] = "New"
                order["itemNames"] = self.itemNameArray as [String]
                order["itemPrices"] = self.priceArrayDouble as [Double]
                
                let acl = PFACL()
                acl.getPublicReadAccess = true
                acl.getPublicWriteAccess = true
                
                order.acl = acl
                
                
                order.saveInBackground(block: { (success: Bool, error2: Error?) -> Void in
                    if success {
                        
                        Fhoodie.fhoodieOrderID = order.objectId
                        
                        let relation = user?.relation(forKey: "orders")
                        relation!.add(order)
                        
                        do {
                            try user?.save()
                            
                            let query = PFQuery(className: "Fhooder")
                            query.getObjectInBackground(withId: fhooderID, block: { (fhooder: PFObject?, error: Error?) -> Void in
                  
                                let relation2 = fhooder?.relation(forKey: "orders")
                                relation2!.add(order)
                                
                                do {
                                    try fhooder?.save()
                                }
                                catch {
                                    print(error)
                                }
                                
                                let relation3 = fhooder?.relation(forKey: "items")
                                let query2 = relation3?.query()
                                
                                query2?.order(byAscending: "createdAt")
                                query2?.findObjectsInBackground(block: { (items: [PFObject]?, error3: Error?) -> Void in
                                    
                                    if error3 == nil {
                                        
                                        var i = 0
                                        for item in items! {
                                            
                                            let id = item.objectId!
                                            
                                            if Fhoodie.selectedItemObjectId![i] == id {
                                                
                                                let dailyQty = item["dailyQuantity"] as? Int
                                                item["dailyQuantity"] = dailyQty! - Fhoodie.selectedItemCount![i]
                                                
                                                item.saveInBackground()
                                                
                                                if i < ((Fhoodie.selectedItemObjectId?.count)! - 1) {
                                                    i += 1
                                                }
                                            }
                                        }
                                        
                                    }
                                })
                            })

                            
                            
                        }
                        catch {
                            let alert = UIAlertController(title: "", message:"There was an error!", preferredStyle: .alert)
                            let error = UIAlertAction(title: "Ok", style: .default) { _ in}
                            alert.addAction(error)
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                    
                })
                
                self.pushNotification()
                
            })
            
            self.performSegue(withIdentifier: "toOrderedView", sender: self)
        }
        alert.addAction(proceed)
        self.present(alert, animated: true){}
        
        HUD.dismiss()
    }
    
    //Passing order list values to the next View Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "toOrderedView") {
            let orderedVC = segue.destination as! OrderedViewController;
            
            orderedVC.qtyArray = self.quantityArray
            orderedVC.itemArray = self.itemNameArray
            orderedVC.priceArray = self.priceTextArray
            
            orderedVC.subtotalPassed = self.subTotal.text!
            orderedVC.taxesAndFeesPassed = self.taxesAndFees.text!
            orderedVC.totalPassed = self.totalAmountDue.text!
            
            Fhoodie.fhoodiePickupTime = self.timePicker.date
        }
    }

    // Close receipt
    @IBAction func closeReceiptView(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}
