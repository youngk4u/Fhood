//
//  FhooderViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 6/29/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
//

import UIKit
import Parse

final class FhooderViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var spoonRating: UIImageView!
    @IBOutlet weak var reviewCount: UILabel!
    @IBOutlet weak var restaurantType: UILabel!
    @IBOutlet weak var fhooderAddress: UILabel!
    @IBOutlet weak var fhooderDistance: UILabel!
    @IBOutlet weak var pickupSign: UILabel!
    @IBOutlet weak var eatinSign: UILabel!
    @IBOutlet weak var deliverySign: UILabel!
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
    var formatter = NSNumberFormatter()


    var tableCellList : NSArray = ["Reviews", "Photos", "Send request", "About the Fhooder"]
    var tableCellImage : NSArray = ["reviews", "photos", "messages", "about"]

    let sectionInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
    
    // Create Message Composer
    let messageComposer = MessageComposer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Reload collectionview data
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadList:",name:"load", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadList2:",name:"load2", object: nil)
        
        // Reload open/closed data
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadList3:",name:"load3", object: nil)
        
        
        NSNotificationCenter.defaultCenter().postNotificationName("load2", object: nil)
        

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
        self.TableView3.layoutMargins = UIEdgeInsetsZero
        
        // No lines between table cells
        self.TableView3.separatorStyle = UITableViewCellSeparatorStyle.None

        // Currency formatter
        self.formatter.numberStyle = .CurrencyStyle


        // Initialize fhoodie variables
        Fhoodie.isAnythingSelected = false
        Fhoodie.selectedTotalItemPrice = 0

    }
    
    // Reload collectionview function to use from other controllers
    func loadList(notification: NSNotification){
        
        self.collectionView.reloadData()
    }
    
    func loadList2(notification: NSNotification){
        
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
        self.pickupSign.hidden = true
        self.eatinSign.hidden = true
        self.deliverySign.hidden = true
        
            let query = PFQuery(className: "Fhooder")
            let id = (Fhooder.objectID)! as String
            query.getObjectInBackgroundWithId(id) { (fhooder: PFObject?, error: NSError?) -> Void in
                if error == nil && fhooder != nil {
                    
                    // Fhooder information pulled
                    
                    
                    self.shopName.text = fhooder!.valueForKey("shopName")! as? String
                    let userImageFile = fhooder!.valueForKey("profilePic") as! PFFile
                    userImageFile.getDataInBackgroundWithBlock {
                        (imageData: NSData?, error: NSError?) -> Void in
                        if error == nil {
                            if let imageData = imageData {
                                Fhooder.fhooderPicture = UIImage(data:imageData)
                            }
                        }
                    }
                    
                    // If it has apt or bldg number
                    var unit : String?
                    if fhooder?.valueForKey("unitAddress") != nil {
                        unit = fhooder!.valueForKey("unitAddress")! as? String
                        if unit != "" {
                            unit = unit! + ", "
                            
                            self.fhooderAddress.text = "\(fhooder!.valueForKey("streetAddress")!), \(unit)\(fhooder!.valueForKey("city")!), \(fhooder!.valueForKey("stateProvince")!) \(fhooder!.valueForKey("zip")!)"
                        }
                    }
                    self.fhooderAddress.text =  "\(fhooder!.valueForKey("streetAddress")!), \(fhooder!.valueForKey("city")!), \(fhooder!.valueForKey("stateProvince")!) \(fhooder!.valueForKey("zip")!)"
                    
                    self.phoneNumber.text = fhooder!.valueForKey("phone") as? String
                    self.restaurantType.text = "\(fhooder!.valueForKey("foodTypeOne")!), \(fhooder!.valueForKey("foodTypeTwo")!), \(fhooder!.valueForKey("foodTypeThree")!)"
                    Fhooder.fhooderAboutMe = (fhooder!.valueForKey("shopDescription") as? String)!
                    Fhooder.fhooderFirstName = (fhooder!.valueForKey("firstName") as? String)!
                    Fhooder.isOpen = (fhooder!.valueForKey("isOpen") as? Bool)!
                    NSNotificationCenter.defaultCenter().postNotificationName("load3", object: nil)
                    
                    let relation = fhooder!.relationForKey("items")
                    let query2 = relation.query()
                    
                    query2.orderByAscending("createdAt")
                    query2.findObjectsInBackgroundWithBlock({ (items: [PFObject]?, error2: NSError?) -> Void in
                        if error2 == nil && items != nil {
                            for item in items! {
                                let pic = item["photo"] as! PFFile
                                
                                
                                do {
                                    let picData : NSData = try pic.getData()
                                    //pic.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                                    //if (error == nil) {
                                    let picture = UIImage(data: picData)
                                    let name = item["itemName"] as! String
                                    let price = item["price"] as! Double
                                    let servingMethod = item["servingMethod"] as! [Bool]
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
                                    
                                    if servingMethod[0] == true {
                                        self.pickupSign.hidden = false
                                    }
                                    if servingMethod[1] == true {
                                        self.eatinSign.hidden = false
                                    }
                                    if servingMethod[2] == true {
                                        self.deliverySign.hidden = false
                                    }
                                    
                                    
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
                                        for var i = 0; i < items?.count; i++ {
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
    func loadList3(notification: NSNotification){
        if Fhooder.isOpen == true {
            self.openNowOrClose.text = "OPEN NOW"
            self.openNowOrClose.textColor = UIColor(red: 0.0/255.0, green: 200.0/255.0, blue: 0.0/255.0, alpha: 1)
        }
        else {
            self.openNowOrClose.text = "CLOSED"
            self.openNowOrClose.textColor = UIColor.redColor()
        }
    }
   
    
    
    // CollectionView
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrItemNames.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let coCell = collectionView.dequeueReusableCellWithReuseIdentifier("collCell", forIndexPath: indexPath) as! CollectionViewCell

        self.totalItemPrice = 0

        if Fhooder.dailyQuantity![indexPath.item] == 0 && Fhooder.isOpen == true {
            coCell.soldOutLabel.hidden = false
        }
        else {
            coCell.soldOutLabel.hidden = true
        }
        
        coCell.fhoodImage.image = self.itemPictures[indexPath.item]

        coCell.foodName.text = arrItemNames[indexPath.item]
        coCell.foodName.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        coCell.foodName.textColor = UIColor.whiteColor()

        coCell.foodPrice.text = formatter.stringFromNumber(arrPrice[indexPath.item])
        coCell.foodPrice.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        coCell.foodPrice.textColor = UIColor.whiteColor()

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
        coCell.subtractButton.addTarget(self, action: "subtractItem:", forControlEvents: UIControlEvents.TouchUpInside)
        
        if Fhoodie.isAnythingSelected == false {
            self.doneButton.alpha = 0
            self.totalPrice.text = "$0.00"
        } else {
            for var i = 0; i < Fhooder.itemNames!.count; i++ {
                self.totalItemPrice += (Double(self.selectedItemCount[i]) * Fhooder.itemPrices![i])
            }

            Fhoodie.selectedTotalItemPrice! = self.totalItemPrice
            self.totalPrice.text = formatter.stringFromNumber(Fhoodie.selectedTotalItemPrice!)

            self.doneButton.alpha = 1
            self.doneButton.addTarget(self, action: "donePressed:", forControlEvents: UIControlEvents.TouchUpInside)
        }
        return coCell
    }

    
    // Subtract icon function
    func subtractItem(sender: UIButton) {
        let i = sender.layer.valueForKey("index") as! Int

        self.selectedItemCount[i]--
        self.totalItemPrice = 0
        
        for var i = 0; i < Fhooder.itemNames!.count; i++ {
            self.totalItemPrice += (Double(self.selectedItemCount[i]) * Fhooder.itemPrices![i])
        }
        Fhoodie.selectedTotalItemPrice! = self.totalItemPrice
        
        if Fhoodie.selectedTotalItemPrice! == 0 {
            Fhoodie.isAnythingSelected = false
        }
        
        self.totalPrice.text = formatter.stringFromNumber(Fhoodie.selectedTotalItemPrice!)

        self.collectionView.reloadData()
    }

    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let coCell = collectionView.cellForItemAtIndexPath(indexPath) as! CollectionViewCell

        self.totalItemPrice = 0
        
        Fhoodie.selectedIndex = indexPath.item

        performSegueWithIdentifier("toDetailView", sender: self)

        if self.selectedItemCount[indexPath.item] != 0 {
            coCell.foodQuantity.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            coCell.foodQuantity.text = " x " + "\(Int(self.selectedItemCount[indexPath.item]))"
            coCell.subtractButton.alpha = 0.8
            coCell.subtractButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)

            for var i = 0; i < self.selectedItemCount.count; i++ {
                self.totalItemPrice += (Double(self.selectedItemCount[i]) * Fhooder.itemPrices![i])
            }
            Fhoodie.selectedTotalItemPrice! = self.totalItemPrice

            self.totalPrice.text = formatter.stringFromNumber(Fhoodie.selectedTotalItemPrice!)
            self.doneButton.alpha = 1
            self.doneButton.addTarget(self, action: "donePressed:", forControlEvents: UIControlEvents.TouchUpInside)
        } else if Fhoodie.selectedTotalItemPrice! == 0 {
            self.totalPrice.text = "$0.00"
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "toDetailView") {
            (segue.destinationViewController as! DetailViewController).delegate = self
            let secondViewController = segue.destinationViewController as! DetailViewController
            secondViewController.passedItemCount = self.selectedItemCount
        }
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        return CGSize(width: 150, height: 150)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        return sectionInsets
    }

    

    // Done Button
    func donePressed(sender: UIButton) {
        
        // Reset arrays for receipt
        self.itemReceipt = []
        self.qtyReceipt = []
        self.priceReceipt = []
        self.arrItemID = []
        
        
        if Fhooder.isOpen == false {
            let alert = UIAlertController(title: "Shop is closed", message:"Why don't you send a request for a meal?", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default) { _ in}
            alert.addAction(action)
            self.presentViewController(alert, animated: true){}
            
        }
        else {
        
            // Organize the receipt list
            for var i = 0; i < Fhooder.itemNames!.count; i++ {
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
                        
            performSegueWithIdentifier("toReceiptView", sender: self)
        }
    }
        


    
    // TableView
    func tableView(tableView3: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(tableView3: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Try to get a cell to reuse
        let cell3 = TableView3.dequeueReusableCellWithIdentifier("Tablecell3") as! TableViewCell3

        // Make the insets to zero
        cell3.layoutMargins = UIEdgeInsetsZero

        // Customize cell
        cell3.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell3.tableViewLabel!.text = self.tableCellList[indexPath.row] as? String
        cell3.tableViewImage.image = UIImage(named: (tableCellImage.objectAtIndex(indexPath.row) as! String) )

        return cell3
    }

    func tableView(tableView3: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedRow2 = indexPath.row
        
        if self.selectedRow2 == 0 {
            self.performSegueWithIdentifier("toFhooderReviewsView", sender: TableView3)
        } else if self.selectedRow2 == 1 {
            self.performSegueWithIdentifier("toFhooderPhotosView", sender: TableView3)
        } else if self.selectedRow2 == 2 {
            // Make sure the device can send text messages
            if (messageComposer.canSendText()) {
                // Obtain a configured MFMessageComposeViewController
                let messageComposeVC = messageComposer.configuredMessageComposeViewController()
                
                // Present the configured MFMessageComposeViewController instance
                // Note that the dismissal of the VC will be handled by the messageComposer instance,
                // since it implements the appropriate delegate call-back
                presentViewController(messageComposeVC, animated: true, completion: nil)
            } else {
                // Let the user know if his/her device isn't able to send text messages
                let alert = UIAlertController(title: "Cannot Send Text Message", message:"Your device is not able to send text messages", preferredStyle: .Alert)
                let action = UIAlertAction(title: "OK", style: .Default) { _ in}
                alert.addAction(action)
                self.presentViewController(alert, animated: true){}
                
            }
        } else if self.selectedRow2 == 3 {
            self.performSegueWithIdentifier("toAboutFhooderView", sender: TableView3)
        }

        TableView3.deselectRowAtIndexPath(indexPath, animated: true)
    }


}

extension FhooderViewController: VCTwoDelegate {
    func updateData(data: [Int]) {
        self.selectedItemCount = data
    }
}

