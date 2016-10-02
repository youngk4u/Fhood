//
//  ManageViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 8/30/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
//

import UIKit
import Parse

final class ManageViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var spoonRating: UIImageView!
    @IBOutlet weak var reviewCount: UILabel!
    @IBOutlet weak var restaurantType: UILabel!
    @IBOutlet weak var fhooderAddress: UILabel!
    @IBOutlet weak var fhooderDistance: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var pickupSign: UILabel!
    @IBOutlet weak var eatinSign: UILabel!
    @IBOutlet weak var deliverySign: UILabel!
    @IBOutlet weak var openNowOrClose: UILabel!

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    var itemPictures : [UIImage] = []
    var arrItemNames : [String] = []
    var arrPrice : [Double]  = []
    var arrDecriptions : [String] = []
    var arrIngredients : [String] = []
    var arrPreference : [[Bool]] = []
    var arrItemCount : [Int] = []
    var arrItemID : [String] = []
    var arrMaxOrderLimit : [Int] = []
    var arrTimeInterval : [Int] = []
    var aboutFhooder : String = ""
    var fhooderPic : UIImage?
    var fhooderFirstName : String?
    var badgeCount : Int = 0
    var timer : NSTimer?
    
    var formatter = NSNumberFormatter()
    
    @IBOutlet var addButton: UIButton!
    
    var tableCellList : NSArray = ["Reviews", "About me"]
    var tableCellImage : NSArray = ["reviews", "about"]

    let sectionInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HUD.show()
        
        // Reload Parse data
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ManageViewController.loadList1(_:)),name:"load1", object: nil)
        
        // Reload collectionview data
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ManageViewController.loadList2(_:)),name:"load2", object: nil)
        
        // Reload open/closed data
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ManageViewController.loadList3(_:)),name:"load3", object: nil)
        
        
        NSNotificationCenter.defaultCenter().postNotificationName("load1", object: nil)
        
        // Configure reveal for this view
        let revealController = self.revealViewController()
        revealController?.panGestureRecognizer()
        revealController?.tapGestureRecognizer()
        
        // Account Icon
        let accountIcon = UIImage(named: "userCircle2")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: accountIcon, style: UIBarButtonItemStyle.Plain,
                                                                target: revealController, action: #selector(revealController.revealToggle(_:)))
        
        // Logo
        let logo = UIImage(named: "FhoodLogo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        // Fhooder Cooking time Icon
        let fhooderTime = UIImage(named: "FhooderOnIcon2")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: fhooderTime, style: UIBarButtonItemStyle.Plain,
            target: self, action: #selector(ManageViewController.toCookingTimeView))

        
        // TableView Delegate
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.layoutMargins = UIEdgeInsetsZero

        
        // Currency formatter
        self.formatter.numberStyle = .CurrencyStyle
        
        self.addButton.addTarget(self, action: #selector(ManageViewController.segueToAddItemView), forControlEvents: UIControlEvents.TouchUpInside)

        HUD.dismiss()

    }
    
    func isOpen (notification: NSNotification) {
        
        
    
    }
    
    
    func ordersQuery () {
        
        if Fhooder.isOpen == true {
        
            let user = PFUser.currentUser()!
            let query = PFQuery(className: "Fhooder")
            let id = (user.valueForKey("fhooder")?.objectId)! as String
            query.getObjectInBackgroundWithId(id) { (fhooder, error) -> Void in
                
                if error == nil && fhooder != nil {
                    
                    let relation = fhooder!.relationForKey("orders")
                    let query2 = relation.query()
                    
                    query2.orderByAscending("createdAt")
                    query2.findObjectsInBackgroundWithBlock({ (orders: [PFObject]?, error2: NSError?) -> Void in
                        if error2 == nil && orders != nil {
                            
                            self.badgeCount = 0
                            
                            for order in orders! {
                                
                                let orderStatus = order["orderStatus"] as! String
                    
                                if orderStatus == "Made" {
                                    self.badgeCount = self.badgeCount + 1
                                    
                                    let tabItem = self.tabBarController!.tabBar.items?[1]
                                    if self.badgeCount != 0 {
                                        tabItem!.badgeValue = String(self.badgeCount)
                                    }
                                }
                                
                            }
                
                        }
                    })
                    
                }
            }
        }
    }
    
    
    func segueToAddItemView () {
        
        if self.arrItemNames.count == 7 {
            let alert = UIAlertController(title: "", message:"You have reached maximum items you can add!", preferredStyle: .Alert)
            let error = UIAlertAction(title: "Ok", style: .Default) { _ in}
            alert.addAction(error)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else {
            
            Fhooder.itemPic = nil
            
            Fhooder.descriptionText = ""
            Fhooder.ingredientsText = ""
            performSegueWithIdentifier("toAddItemView", sender: self)
        }
    }
    
    
    // Reload Parse function to use from other controllers
    func loadList1(notification: NSNotification){
        
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
        
        if PFUser.currentUser() != nil {
            let user = PFUser.currentUser()!
            let query = PFQuery(className: "Fhooder")
            let id = (user.valueForKey("fhooder")?.objectId)! as String
            query.getObjectInBackgroundWithId(id) { (fhooder: PFObject?, error: NSError?) -> Void in
                if error == nil && fhooder != nil {
                    
                    // fhooder information pulled
                    
                    Fhooder.objectID = fhooder?.objectId
                    self.shopName.text = fhooder!.valueForKey("shopName")! as? String
                    let userImageFile = fhooder!.valueForKey("profilePic") as! PFFile
                    userImageFile.getDataInBackgroundWithBlock {
                        (imageData: NSData?, error: NSError?) -> Void in
                        if error == nil {
                            if let imageData = imageData {
                                self.fhooderPic = UIImage(data:imageData)
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
                    self.aboutFhooder = (fhooder!.valueForKey("shopDescription") as? String)!
                    self.fhooderFirstName = (fhooder!.valueForKey("firstName") as? String)!
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
                                        self.arrPrice.append(price)
                                        self.arrDecriptions.append(description)
                                        self.arrIngredients.append(ingredient)
                                        self.arrPreference.append([prefOne, prefTwo, prefThree, prefFour, prefFive, prefSix, prefSeven, prefEight])
                                        
                                        self.arrItemCount.append(itemCount)
                                        Fhooder.dailyQuantity = self.arrItemCount
                                        
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
                else {
                    
                }
            }
        }
    }
    
    
    
    // Reload collectionview function to use from other controllers
    func loadList2(notification: NSNotification){
        self.collectionView.reloadData()
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
        
        
        // If shop is opened timer goes off to get notified with new orders
//        if Fhooder.isOpen == true {
//            self.timer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: ("ordersQuery"), userInfo: nil, repeats: true)
//        }
//        else {
//    (w       self.t: mer = nil
//        }
    }
    
    
    func toCookingTimeView () {
        performSegueWithIdentifier("toCookingTime", sender: self)
    }

    
    
    // CollectionView
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrItemNames.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collCell2", forIndexPath: indexPath) as! ManageCollectionViewCell
        
        cell.foodImage.image = self.itemPictures[indexPath.item]
        
        
        cell.foodName.text = arrItemNames[indexPath.item]
        cell.foodName.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        cell.foodName.textColor = UIColor.whiteColor()
        
        cell.foodPrice.text = formatter.stringFromNumber(arrPrice[indexPath.item])
        cell.foodPrice.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        cell.foodPrice.textColor = UIColor.whiteColor()
        
        if Fhooder.dailyQuantity![indexPath.item] == 0 {
            cell.foodQuantity.alpha = 0
            cell.orderPerMin.alpha = 0
            cell.foodQuantity.text = ""
            cell.orderPerMin.text = ""
        } else {
            cell.foodQuantity.alpha = 1
            cell.orderPerMin.alpha = 1
            cell.foodQuantity.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            cell.orderPerMin.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            cell.foodQuantity.text = "Daily Qty: " + "\(Int(Fhooder.dailyQuantity![indexPath.item]))"
            cell.orderPerMin.text = "\(Fhooder.maxOrderLimit![indexPath.item]) per \(Fhooder.timeInterval![indexPath.item]) minutes"
        }

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        Fhooder.itemIndex = indexPath.item
        
        Fhooder.itemPic = self.itemPictures[indexPath.item]
        Fhooder.itemNames = self.arrItemNames
        Fhooder.itemPrices = self.arrPrice
        Fhooder.itemDescription = self.arrDecriptions
        Fhooder.itemIngredients = self.arrIngredients
        Fhooder.itemPreferences = self.arrPreference
        Fhooder.itemID = self.arrItemID
                
        performSegueWithIdentifier("toItemDetailView", sender: self)
        
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        return CGSize(width: 150, height: 150)
    }
    
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }

    
    
    // TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Try to get a cell to reuse
        let cell = tableView.dequeueReusableCellWithIdentifier("Tablecell") as! ManageTableViewCell

        // Make the insets to zero
        cell.layoutMargins = UIEdgeInsetsZero
        
        // Customize cell
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.tableViewLabel!.text = self.tableCellList[indexPath.row] as? String
        cell.tableViewImage.image = UIImage(named: (tableCellImage.objectAtIndex(indexPath.row) as! String) )

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 1 {
            
            Fhooder.fhooderPicture = self.fhooderPic
            Fhooder.fhooderAboutMe = self.aboutFhooder
            Fhooder.fhooderFirstName = self.fhooderFirstName
            performSegueWithIdentifier("toAboutFhooder", sender: self)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
