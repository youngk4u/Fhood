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
    
    var itemPicture : UIImage?
    var itemPictures : [UIImage] = []
    var arrItemNames : [String] = []
    var arrPrice : [Double]  = []
    var arrDecriptions : [String] = []
    var arrIngredients : [String] = []
    var arrPreference : [[Bool]] = []
    var arrItemCount : [Int] = []
    var aboutFhooder : String = ""
    var fhooderPic : UIImage?
    var fhooderFirstName : String?
    
    var formatter = NSNumberFormatter()
    
    @IBOutlet var addButton: UIButton!
    
    var tableCellList : NSArray = ["Reviews", "About me"]
    var tableCellImage : NSArray = ["reviews", "about"]

    let sectionInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Reload Parse data
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadList1:",name:"load1", object: nil)
        
        // Reload collectionview data
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadList2:",name:"load2", object: nil)
        
        
        NSNotificationCenter.defaultCenter().postNotificationName("load1", object: nil)
        
        // Configure reveal for this view
        let revealController = self.revealViewController()
        revealController?.panGestureRecognizer()
        revealController?.tapGestureRecognizer()
        
        // Account Icon
        let accountIcon = UIImage(named: "userCircle2")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: accountIcon, style: UIBarButtonItemStyle.Plain,
            target: revealController, action: "revealToggle:")
        
        // Logo
        let logo = UIImage(named: "FhoodLogo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        // Fhooder Cooking time Icon
        let fhooderTime = UIImage(named: "FhooderOnIcon2")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: fhooderTime, style: UIBarButtonItemStyle.Plain,
            target: self, action: "toCookingTimeView")

        
        // TableView Delegate
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.layoutMargins = UIEdgeInsetsZero

        
        // Currency formatter
        self.formatter.numberStyle = .CurrencyStyle
        
        self.addButton.addTarget(self, action: "segueToAddItemView", forControlEvents: UIControlEvents.TouchUpInside)
        


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
        
        
        self.arrItemNames = []
        self.arrPrice = []
        self.itemPictures = []
        self.arrDecriptions = []
        self.arrIngredients = []
        self.arrPreference = []
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
                    
                    let relation = fhooder!.relationForKey("items")
                    let query2 = relation.query()
                    query2?.orderByAscending("createdAt")
                    
                    query2!.findObjectsInBackgroundWithBlock({ (items: [PFObject]?, error2: NSError?) -> Void in
                        
                        if error2 == nil && items != nil {
                            var index = items!.count
                            let index2 = 0
                            for item in items! {
                                let name = item["itemName"] as! String
                                let price = item["price"] as! Double
                                let pic = item["photo"] as! PFFile
                                pic.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                                    if (error == nil) {
                                        self.itemPicture = UIImage(data: imageData!)
                                        print(self.itemPicture!)
                                        self.itemPictures.append(self.itemPicture!)
                                        print(index)
                                        let counter = self.arrItemNames.count - 1
                                        if index == counter {
                                            NSNotificationCenter.defaultCenter().postNotificationName("load2", object: nil)
                                            print("here")
                                        }
                                        index++
                                    }
                                })
                                
                                let servingMethod = item["servingMethod"]
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
                                
                                if index != 0 && index2 != index {
                                    
                                    if servingMethod[0] as! Bool == true {
                                        self.pickupSign.hidden = false
                                    }
                                    if servingMethod[1] as! Bool == true {
                                        self.eatinSign.hidden = false
                                    }
                                    if servingMethod[2] as! Bool == true {
                                        self.deliverySign.hidden = false
                                    }
                                    
                                    self.arrItemNames.append(name)
                                    self.arrPrice.append(price)
                                    self.arrDecriptions.append(description)
                                    self.arrIngredients.append(ingredient)
                                    self.arrPreference.append([prefOne, prefTwo, prefThree, prefFour, prefFive, prefSix, prefSeven, prefEight])
                                    print(self.arrItemNames)
                                    index--
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
        
        cell.foodImage.image = itemPictures[indexPath.item]
        
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
        
        Fhooder.itemPics = self.itemPictures
        Fhooder.itemNames = self.arrItemNames
        Fhooder.itemPrices = self.arrPrice
        Fhooder.itemDescription = self.arrDecriptions
        Fhooder.itemIngredients = self.arrIngredients
        Fhooder.itemPreferences = self.arrPreference
        
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
