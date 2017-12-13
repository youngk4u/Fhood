//
//  FhooderViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 6/29/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
//

import UIKit
import Parse
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}




final class FhooderViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var spoonRating: UIImageView!
    @IBOutlet weak var reviewCount: UILabel!
    @IBOutlet weak var restaurantType: UILabel!
    @IBOutlet weak var fhooderAddress: UILabel!
    @IBOutlet weak var fhooderDistance: UILabel!
    @IBOutlet weak var pickupSign: UILabel!
    @IBOutlet weak var deliverySign: UILabel!
    @IBOutlet weak var eatinSign: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var openNowOrClose: UILabel!

    @IBOutlet weak var collectionView: UICollectionView!
    
    var itemPictures : [UIImage] = []
    var arrItemNames : [String] = []
    var arrPrice : [Double]  = []
    var arrDecriptions : [String] = []
    var arrIngredients : [String] = []
    var arrPreference : [[Bool]] = []
    var selectedItemCount : [Int] = []
    var arrItemCount : [Int] = []
    var arrItemID : [String] = []
    var arrMaxOrderLimit : [Int] = []
    var arrTimeInterval : [Int] = []
    var aboutFhooder : String = ""
    var fhooderPic : UIImage?
    var fhooderFirstName : String?


    var itemReceipt : [String] = []
    var qtyReceipt : [Int] = []
    var priceReceipt : [Double] = []

    var totalItemPrice : Double = 0

    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var TableView3: UITableView!
    @IBOutlet weak var doneButton: UIButton!
    
    var selectedRow2 : Int = 0
    var formatter = NumberFormatter()


    var tableCellList : NSArray = ["Reviews", "Photos", "Send request", "About the Fhooder"]
    var tableCellImage : NSArray = ["reviews", "photos", "messages", "about"]

    let sectionInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
    
    // Create Message Composer
    let messageComposer = MessageComposer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Reload collectionview data
        NotificationCenter.default.addObserver(self, selector: #selector(FhooderViewController.loadList(_:)),name:NSNotification.Name(rawValue: "load"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(FhooderViewController.loadList2(_:)),name:NSNotification.Name(rawValue: "load2"), object: nil)
        
        // Reload open/closed data
        NotificationCenter.default.addObserver(self, selector: #selector(FhooderViewController.loadList3(_:)),name:NSNotification.Name(rawValue: "load3"), object: nil)
        
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "load2"), object: nil)
        

        var newOpenMinute: String
        var newCloseMinute: String

        if Fhooder.timeOpenMinute < 10 {
            newOpenMinute = "0\(String(Fhooder.timeOpenMinute!))"
        } else {
            newOpenMinute = String(Fhooder.timeOpenMinute!)
        }
        
        if Fhooder.timeCloseMinute < 10 {
            newCloseMinute = "0\(String(Fhooder.timeCloseMinute!))"
        } else {
            newCloseMinute = String(Fhooder.timeCloseMinute!)
        }
        
        if Fhooder.isOpen == true {
            self.openNowOrClose.text = "Open Now; Closes at \(Fhooder.timeCloseHour!):\(newCloseMinute) \(Fhooder.timeCloseAmpm!)"
        } else {
            self.openNowOrClose.text = "Closed; Opens at \(Fhooder.timeOpenHour!):\(newOpenMinute) \(Fhooder.timeOpenAmpm!)"
        }
        
        
        // Logo
        let logo = UIImage(named: "FhoodLogo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        // TableView Delegate
        self.TableView3.delegate = self
        self.TableView3.dataSource = self
        self.TableView3.layoutMargins = UIEdgeInsets.zero
        
        // No lines between table cells
        self.TableView3.separatorStyle = UITableViewCellSeparatorStyle.none

        // Currency formatter
        self.formatter.numberStyle = .currency


        // Initialize fhoodie variables
        Fhoodie.isAnythingSelected = false
        Fhoodie.selectedTotalItemPrice = 0

    }
    
    
    @IBAction func prepareForUnwindtoDetail(_ segue: UIStoryboardSegue){
        
    }
    
    
    
    // Reload collectionview function to use from other controllers
    @objc func loadList(_ notification: Notification){
        
        self.collectionView.reloadData()
    }
    
    @objc func loadList2(_ notification: Notification){
        
        HUD.show()
        
        Fhooder.itemPics = []
        
        self.arrItemNames = []
        self.arrPrice = []
        self.itemPictures = []
        self.arrDecriptions = []
        self.arrIngredients = []
        self.arrPreference = []
        self.arrItemCount = []
        self.arrMaxOrderLimit = []
        self.arrTimeInterval = []
        self.arrItemID = []
        self.pickupSign.isHidden = true
        self.deliverySign.isHidden = true
        self.eatinSign.isHidden = true
        
            let query = PFQuery(className: "Fhooder")
            let id = (Fhooder.objectID)! as String
            query.getObjectInBackground(withId: id) { (fhooder: PFObject?, error: Error?) -> Void in
                if error == nil && fhooder != nil {
                    
                    // Fhooder information pulled
                    
                    
                    self.shopName.text = fhooder!.value(forKey: "shopName")! as? String
                    Fhooder.shopName = self.shopName.text
                    
                    let userImageFile = fhooder!.value(forKey: "profilePic") as! PFFile
                    userImageFile.getDataInBackground {
                        (imageData: Data?, error: Error?) -> Void in
                        if error == nil {
                            if let imageData = imageData {
                                Fhooder.fhooderPicture = UIImage(data:imageData)
                            }
                        }
                    }
                    
                    let ratings = fhooder?.value(forKey: "ratings") as? Double
                    let spoons = String(format: "%.1f", ratings!)
                    self.spoonRating.image = UIImage(named: spoons)
                    
                    self.reviewCount.text = "\(fhooder!.value(forKey: "reviews")!) Reviews"
                    
                    self.fhooderDistance.text = "(\(String(Fhooder.distance!)) miles)"
                    
                    
                    // If it has apt or bldg number
                    var unit : String?
                    if fhooder?.value(forKey: "unitAddress") != nil {
                        unit = fhooder!.value(forKey: "unitAddress")! as? String
                        if unit != "" {
                            unit = unit! + ", "
                            
                            self.fhooderAddress.text = "\(fhooder!.value(forKey: "streetAddress")!), \(String(describing: unit))\(fhooder!.value(forKey: "city")!), \(fhooder!.value(forKey: "stateProvince")!) \(fhooder!.value(forKey: "zip")!)"
                        }
                    }
                    self.fhooderAddress.text =  "\(fhooder!.value(forKey: "streetAddress")!), \(fhooder!.value(forKey: "city")!), \(fhooder!.value(forKey: "stateProvince")!) \(fhooder!.value(forKey: "zip")!)"
                    
                    self.phoneNumber.text = fhooder!.value(forKey: "phone") as? String
                    self.restaurantType.text = "\(fhooder!.value(forKey: "foodTypeOne")!), \(fhooder!.value(forKey: "foodTypeTwo")!), \(fhooder!.value(forKey: "foodTypeThree")!)"
                    Fhooder.address = self.fhooderAddress.text
                    Fhooder.fhooderAboutMe = (fhooder!.value(forKey: "shopDescription") as? String)!
                    Fhooder.fhooderFirstName = (fhooder!.value(forKey: "firstName") as? String)!
                    
                    Fhooder.pickup? = (fhooder!.value(forKey: "isPickup") as? Bool)!
                    self.pickupSign.isHidden = !Fhooder.pickup!
                    
                    Fhooder.delivery? = (fhooder!.value(forKey: "isDeliver") as? Bool)!
                    self.deliverySign.isHidden = !Fhooder.delivery!
                    
                    Fhooder.eatin? = (fhooder!.value(forKey: "isEatin") as? Bool)!
                    self.eatinSign.isHidden = !Fhooder.eatin!
                    
                    Fhooder.isOpen = (fhooder!.value(forKey: "isOpen") as? Bool)!
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "load3"), object: nil)
                    
                    let relation = fhooder!.relation(forKey: "items")
                    let query2 = relation.query()
                    
                    query2.order(byAscending: "createdAt")
                    query2.findObjectsInBackground(block: { (items: [PFObject]?, error2: Error?) -> Void in
                        if error2 == nil && items != nil {
                            for item in items! {
                                let pic = item["photo"] as! PFFile
                                
                                
                                do {
                                    let picData : Data = try pic.getData()
                                    //pic.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                                    //if (error == nil) {
                                    let picture = UIImage(data: picData)
                                    let name = item["itemName"] as! String
                                    let price = item["price"] as! Double
                                    let description = item["description"] as! String
                                    let ingredient = item["ingredients"] as! String
                                    let prefOne = item["organic"] as! Bool
                                    let prefTwo = item["vegan"] as! Bool
                                    let prefThree = item["glutenFree"] as! Bool
                                    let prefFour = item["nutFree"] as! Bool
                                    let prefFive = item["soyFree"] as! Bool
                                    let prefSix = item["msgFree"] as! Bool
                                    let prefSeven = item["dairyFree"] as! Bool
                                    let prefEight = item["lowSodium"] as! Bool
                                    let itemCount = item["dailyQuantity"] as! Int
                                    let maxLimit = item["maxOrderLimit"] as! Int
                                    let timeInterval = item["timeInterval"] as! Int
                                    
                                    self.itemPictures.append(picture!)
                                    Fhooder.itemPics = self.itemPictures
                            
                                    self.arrItemNames.append(name)
                                    Fhooder.itemNames = self.arrItemNames
                                    
                                    self.arrPrice.append(price)
                                    Fhooder.itemPrices = self.arrPrice
                                    
                                    self.arrDecriptions.append(description)
                                    Fhooder.itemDescription = self.arrDecriptions
                                    
                                    self.arrIngredients.append(ingredient)
                                    Fhooder.itemIngredients = self.arrIngredients
                                    
                                    self.arrPreference.append([prefOne, prefTwo, prefThree, prefFour, prefFive, prefSix, prefSeven, prefEight])
                                    Fhooder.itemPreferences = self.arrPreference
                                    
                                    self.arrItemCount.append(itemCount)
                                    Fhooder.dailyQuantity = self.arrItemCount
                                    
                                    if self.selectedItemCount == [] {
                                        for _ in 1...items!.count {
                                            self.selectedItemCount.append(0)
                                        }
                                    }
                                    
                                    self.arrMaxOrderLimit.append(maxLimit)
                                    Fhooder.maxOrderLimit = self.arrMaxOrderLimit
                                    
                                    self.arrTimeInterval.append(timeInterval)
                                    Fhooder.timeInterval = self.arrTimeInterval
                                    
                                    var itemID : String = ""
                                    itemID = item.objectId!
                                    self.arrItemID.append(itemID)
                                    Fhooder.itemID = self.arrItemID
                                    
                                    self.collectionView.reloadData()
                                    
                                }
                                catch {
                                    print("error")
                                }
                                
                            }
                            
                        }
                        
                    })
                    
                }
                
                
            }
        
        HUD.dismiss()
        

    }
    
    
    // Reload shop open/close status
    @objc func loadList3(_ notification: Notification){
        if Fhooder.isOpen == true {
            self.openNowOrClose.text = "OPEN NOW"
            self.openNowOrClose.textColor = UIColor(red: 0.0/255.0, green: 200.0/255.0, blue: 0.0/255.0, alpha: 1)
        }
        else {
            self.openNowOrClose.text = "CLOSED"
            self.openNowOrClose.textColor = UIColor.red
        }
    }
   
    
    
    // CollectionView
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrItemNames.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let coCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collCell", for: indexPath) as! CollectionViewCell

        self.totalItemPrice = 0

        if Fhooder.dailyQuantity![indexPath.item] == 0 && Fhooder.isOpen == true {
            coCell.soldOutLabel.isHidden = false
        }
        else {
            coCell.soldOutLabel.isHidden = true
        }
        
        coCell.fhoodImage.image = self.itemPictures[indexPath.item]

        coCell.foodName.text = arrItemNames[indexPath.item]
        coCell.foodName.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        coCell.foodName.textColor = UIColor.white

        coCell.foodPrice.text = formatter.string(from: (arrPrice[indexPath.item]) as NSNumber)
        coCell.foodPrice.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        coCell.foodPrice.textColor = UIColor.white

        if self.selectedItemCount[indexPath.item] == 0 {
            coCell.foodQuantity.text = ""
            coCell.foodQuantity.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0)
        
            coCell.subtractButton.alpha = 0
            coCell.subtractButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0)
        } else {
            coCell.foodQuantity.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            coCell.foodQuantity.text = " x " + "\(Int(self.selectedItemCount[indexPath.item]))"
            coCell.subtractButton.alpha = 0.8
            coCell.subtractButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        }

        coCell.subtractButton.layer.setValue(indexPath.item, forKey: "index")
        coCell.subtractButton.addTarget(self, action: #selector(FhooderViewController.subtractItem(_:)), for: UIControlEvents.touchUpInside)
        
        if Fhoodie.isAnythingSelected == false {
            self.doneButton.alpha = 0
            self.totalPrice.text = "$0.00"
        } else {
            for i in 0 ..< Fhooder.itemNames!.count {
                self.totalItemPrice += (Double(self.selectedItemCount[i]) * Fhooder.itemPrices![i])
            }

            Fhoodie.selectedTotalItemPrice! = self.totalItemPrice
            self.totalPrice.text = formatter.string(from: (Fhoodie.selectedTotalItemPrice!) as NSNumber)

            self.doneButton.alpha = 1
            self.doneButton.addTarget(self, action: #selector(FhooderViewController.donePressed(_:)), for: UIControlEvents.touchUpInside)
        }
        return coCell
    }

    
    // Subtract icon function
    @objc func subtractItem(_ sender: UIButton) {
        let i = sender.layer.value(forKey: "index") as! Int

        self.selectedItemCount[i] -= 1
        self.totalItemPrice = 0
        
        for i in 0 ..< Fhooder.itemNames!.count {
            self.totalItemPrice += (Double(self.selectedItemCount[i]) * Fhooder.itemPrices![i])
        }
        Fhoodie.selectedTotalItemPrice! = self.totalItemPrice
        
        if Fhoodie.selectedTotalItemPrice! == 0 {
            Fhoodie.isAnythingSelected = false
        }
        
        self.totalPrice.text = formatter.string(from: (Fhoodie.selectedTotalItemPrice!) as NSNumber)

        self.collectionView.reloadData()
    }

    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let coCell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell

        self.totalItemPrice = 0
        
        Fhoodie.selectedIndex = indexPath.item

        performSegue(withIdentifier: "toDetailView", sender: self)

        if self.selectedItemCount[indexPath.item] != 0 {
            coCell.foodQuantity.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            coCell.foodQuantity.text = " x " + "\(Int(self.selectedItemCount[indexPath.item]))"
            coCell.subtractButton.alpha = 0.8
            coCell.subtractButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)

            for i in 0 ..< self.selectedItemCount.count {
                self.totalItemPrice += (Double(self.selectedItemCount[i]) * Fhooder.itemPrices![i])
            }
            Fhoodie.selectedTotalItemPrice! = self.totalItemPrice

            self.totalPrice.text = formatter.string(from: (Fhoodie.selectedTotalItemPrice!) as NSNumber)
            self.doneButton.alpha = 1
            self.doneButton.addTarget(self, action: #selector(FhooderViewController.donePressed(_:)), for: UIControlEvents.touchUpInside)
        } else if Fhoodie.selectedTotalItemPrice! == 0 {
            self.totalPrice.text = "$0.00"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "toDetailView") {
            (segue.destination as! DetailViewController).delegate = self
            let secondViewController = segue.destination as! DetailViewController
            secondViewController.passedItemCount = self.selectedItemCount
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 150, height: 150)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return sectionInsets
    }

    

    // Done Button
    @objc func donePressed(_ sender: UIButton) {
        
        // Reset arrays for receipt
        self.itemReceipt = []
        self.qtyReceipt = []
        self.priceReceipt = []
        self.arrItemID = []
        
        
        if Fhooder.isOpen == false {
            let alert = UIAlertController(title: "Shop is closed", message:"Why don't you send a request for a meal?", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { _ in}
            alert.addAction(action)
            self.present(alert, animated: true){}
            
        }
        else {
        
            // Organize the receipt list
            for i in 0 ..< Fhooder.itemNames!.count {
                if self.selectedItemCount[i] != 0 {
                    self.itemReceipt.append(Fhooder.itemNames![i])
                    self.qtyReceipt.append(self.selectedItemCount[i])
                    self.priceReceipt.append(Fhooder.itemPrices![i])
                    self.arrItemID.append(Fhooder.itemID![i])
                }
            }
            
            // Save on fhoodie struct
            Fhoodie.selectedItemNames = self.itemReceipt
            Fhoodie.selectedItemCount = self.qtyReceipt
            Fhoodie.selectedItemPrices = self.priceReceipt
            Fhoodie.selectedItemObjectId = self.arrItemID
            Fhoodie.selectedTotalItemPrice = self.totalItemPrice
                        
            performSegue(withIdentifier: "toReceiptView", sender: self)
        }
    }
        


    
    // TableView
    func tableView(_ tableView3: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView3: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Try to get a cell to reuse
        let cell3 = TableView3.dequeueReusableCell(withIdentifier: "Tablecell3") as! TableViewCell3

        // Make the insets to zero
        cell3.layoutMargins = UIEdgeInsets.zero

        // Customize cell
        cell3.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        cell3.tableViewLabel!.text = self.tableCellList[indexPath.row] as? String
        cell3.tableViewImage.image = UIImage(named: (tableCellImage.object(at: indexPath.row) as! String) )

        return cell3
    }

    func tableView(_ tableView3: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow2 = indexPath.row
        
        if self.selectedRow2 == 0 {
            self.performSegue(withIdentifier: "toFhooderReviewsView", sender: TableView3)
        } else if self.selectedRow2 == 1 {
            self.performSegue(withIdentifier: "toFhooderPhotosView", sender: TableView3)
        } else if self.selectedRow2 == 2 {
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
        } else if self.selectedRow2 == 3 {
            self.performSegue(withIdentifier: "toAboutFhooderView", sender: TableView3)
        }

        TableView3.deselectRow(at: indexPath, animated: true)
    }


}

extension FhooderViewController: VCTwoDelegate {
    func updateData(_ data: [Int]) {
        self.selectedItemCount = data
    }
}

