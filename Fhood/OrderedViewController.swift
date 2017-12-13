//
//  OrderedViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 7/26/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
//

import UIKit
import Parse

final class OrderedViewController: UIViewController {


    @IBOutlet weak var pickupTime: UILabel!
    @IBOutlet weak var orderStatus: UILabel!
    @IBOutlet weak var fhooderName: UILabel!
    @IBOutlet weak var fhooderImage: UIImageView!
    @IBOutlet weak var address: UILabel!

    
    @IBOutlet weak var subtotal: UILabel!
    var subtotalPassed: String = ""

    @IBOutlet weak var taxesAndFees: UILabel!
    var taxesAndFeesPassed: String = ""

    @IBOutlet weak var total: UILabel!
    var totalPassed: String = ""
    
    @IBOutlet weak var qtyOne: UILabel!
    @IBOutlet weak var qtyTwo: UILabel!
    @IBOutlet weak var qtyThree: UILabel!
    @IBOutlet weak var qtyFour: UILabel!
    @IBOutlet weak var qtyFive: UILabel!
    @IBOutlet weak var qtySix: UILabel!
    @IBOutlet weak var qtySeven: UILabel!
    var qtyArray: [Int] = []
    
    @IBOutlet weak var itemOne: UILabel!
    @IBOutlet weak var itemTwo: UILabel!
    @IBOutlet weak var itemThree: UILabel!
    @IBOutlet weak var itemFour: UILabel!
    @IBOutlet weak var itemFive: UILabel!
    @IBOutlet weak var itemSix: UILabel!
    @IBOutlet weak var itemSeven: UILabel!
    var itemArray: [String] = ["","","","","","",""]
    
    @IBOutlet weak var priceOne: UILabel!
    @IBOutlet weak var priceTwo: UILabel!
    @IBOutlet weak var priceThree: UILabel!
    @IBOutlet weak var priceFour: UILabel!
    @IBOutlet weak var priceFive: UILabel!
    @IBOutlet weak var priceSix: UILabel!
    @IBOutlet weak var priceSeven: UILabel!
    var priceArray: [String] = ["","","","","","",""]
    
    @IBOutlet var navbar: UINavigationBar!

    
    // Create Message Composer
    let messageComposer = MessageComposer()
    
    let rootViewController: UIViewController = UIApplication.shared.windows[1].rootViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        // Reload Parse data
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(OrdersViewController.loadList1(_:)),name:"fhooderOrderLoad", object: nil)
        
        //NSNotificationCenter.defaultCenter().postNotificationName("fhooderOrderLoad", object: nil)
        
        
        // Calculate pickup time and start the counter
        let convertedDate = Date().localDate(Fhoodie.fhoodiePickupTime!)
//        counterLabel.countdownDelegate = self
//        self.counterLabel.setCountDownDate(fromDate: Date() as NSDate, targetDate: Fhoodie.fhoodiePickupTime! as NSDate)
//        self.counterLabel.animationType = .Evaporate
//        countingAt(60, timeRemaining: counterLabel.timeRemaining)
//        self.counterLabel.start()
        
        
        self.pickupTime.text = "PICKUP TIME: \(convertedDate)"
        self.fhooderName.text = Fhooder.shopName!
        self.address.text = Fhooder.address!
        
        
        let image = UIImageView(image: Fhooder.fhooderPicture)
        image.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        image.layer.masksToBounds = false
        image.layer.cornerRadius = 13
        image.layer.cornerRadius = image.frame.size.height/2
        image.clipsToBounds = true
        
        self.fhooderImage.addSubview(image)
        
        
        //Passing values from previous View Controller
        for x in 0..<qtyArray.count {
            
            if x == 0 {
                self.qtyOne.text = String(self.qtyArray[0])
                self.itemOne.text = self.itemArray[0]
                self.priceOne.text = self.priceArray[0]
            }
            else if x == 1 {
                self.qtyTwo.text = String(self.qtyArray[1])
                self.itemTwo.text = self.itemArray[1]
                self.priceTwo.text = self.priceArray[1]
            }
            else if x == 2 {
                self.qtyThree.text = String(self.qtyArray[2])
                self.itemThree.text = self.itemArray[2]
                self.priceThree.text = self.priceArray[2]
            }
            else if x == 3 {
                self.qtyFour.text = String(self.qtyArray[3])
                self.itemFour.text = self.itemArray[3]
                self.priceFour.text = self.priceArray[3]
            }
            else if x == 4 {
                self.qtyFive.text = String(self.qtyArray[4])
                self.itemFive.text = self.itemArray[4]
                self.priceFive.text = self.priceArray[4]
            }
            else if x == 5 {
                self.qtySix.text = String(self.qtyArray[5])
                self.itemSix.text = self.itemArray[5]
                self.priceSix.text = self.priceArray[5]
            }
            else if x == 6 {
                self.qtySeven.text = String(self.qtyArray[6])
                self.itemSeven.text = self.itemArray[6]
                self.priceSeven.text = self.priceArray[6]
            }
            
        }

        self.subtotal.text = self.subtotalPassed
        self.taxesAndFees.text = self.taxesAndFeesPassed
        self.total.text = self.totalPassed
    }
    

    
    @IBAction func directionButton(_ sender: AnyObject) {
        
        let coordinate = CLLocationCoordinate2DMake(Fhooder.fhooderLatitude!, Fhooder.fhooderLongitude!)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = Fhooder.shopName!
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
        
    }
    
    
    func cancelOrderPushNotification () {
        
        let pushData: NSDictionary = NSDictionary(objects: ["Order has been cancelled.", "fhoodieCancelled", "1"], forKeys: ["alert" as NSCopying  , "typy" as NSCopying, "number" as NSCopying])
        
        let uQuery = PFUser.query()!
        uQuery.whereKey("fhooderId", equalTo: Fhooder.objectID!)
        
        let iQuery = PFInstallation.query()!
        iQuery.whereKey("user", matchesQuery: uQuery)
        
        let push : PFPush = PFPush()
        push.setData(pushData as? [AnyHashable: Any])
        //push.setMessage("Fhoodie has cancelled the order!")
        
        do {
            try push.send()
        } catch {
            print("Push didn't work")
        }
        
    }
    
    
    func cancelOrder () {
   
        if PFUser.current() != nil {
            let query = PFQuery(className: "Orders")
            let id = (Fhoodie.fhoodieOrderID)! as String
            query.getObjectInBackground(withId: id) { (order: PFObject?, error: Error?) -> Void in
                if error == nil && order != nil {
                    
                    order!["orderStatus"] = "Fhoodie Cancelled"
                    order?.saveInBackground()
                    
                    self.cancelOrderPushNotification()
                    
                   self.performSegue(withIdentifier: "unwindToViewController", sender: self)
                    
                }
            NotificationCenter.default.post(name: Notification.Name(rawValue: "fhooderOrderLoad"), object: nil)
            }
        }
    }
    

    
    @IBAction func cancelOrderButton(_ sender: AnyObject) {
        
        let alert = UIAlertController(title: "Cancel order", message:"Are you sure?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction) in
            self.cancelOrder()
            HUD.dismiss()
            
        }
        let no = UIAlertAction(title: "No", style: .default) { _ in}
        alert.addAction(action)
        alert.addAction(no)
        self.present(alert, animated: true){}
        
    }

    

    
    @IBAction func messageFhooder(_ sender: AnyObject) {
        
        // Make sure the device can send text messages
        if (messageComposer.canSendText()) {
            // Obtain a configured MFMessageComposeViewController
            let messageComposeVC = messageComposer.configuredMessageComposeViewController()
            
            // Present the configured MFMessageComposeViewController instance
            // Note that the dismissal of the VC will be handled by the messageComposer instance,
            // since it implements the appropriate delegate call-back
            present(messageComposeVC, animated: true, completion: nil)
        } else {
            // Let the user know if his/her device isn't able to send text messages
            let alert = UIAlertController(title: "Cannot Send Text Message", message:"Your device is not able to send text messages", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { _ in}
            alert.addAction(action)
            self.present(alert, animated: true){}
            
        }
    }    
}

//extension OrderedViewController: CountdownLabelDelegate {
//
//    func countdownFinished() {
//        alert("Your pickup time is due", message: "Please proceed to the Fhooder's curbside.")
//    }
//    func countingAt(_ timeCounted: TimeInterval, timeRemaining: TimeInterval) {
//        switch timeRemaining {
//        case 10*60:
//            self.alert("10 Minutes till the pickup time 😉", message: "")
//        case 5*60:
//            self.alert("5 Minutes till the pickup time!", message: "")
//            self.counterLabel.textColor = .red
//        default:
//            break
//        }
//    }
//}

extension OrderedViewController {

    func alert(_ title: String, message: String) {
        let vc = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in}
        vc.addAction(action)
        self.present(vc, animated: true) {}
    }
}

