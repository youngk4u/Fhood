//
//  ManageViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 8/30/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
//

import UIKit
import Parse

final class ManageViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var spoonRating: UIImageView!
    @IBOutlet weak var reviewCount: UILabel!
    @IBOutlet weak var restaurantType: UILabel!
    @IBOutlet weak var fhooderAddress: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var pickupSign: UILabel!
    @IBOutlet weak var deliverySign: UILabel!
    @IBOutlet weak var eatinSign: UILabel!
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
    var timer : Timer?
    
    var formatter = NumberFormatter()
    
    @IBOutlet var addButton: UIButton!
    
    var tableCellList : NSArray = ["Reviews", "About me"]
    var tableCellImage : NSArray = ["reviews", "about"]

    let sectionInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HUD.show()
        
        // Reload Parse data
        NotificationCenter.default.addObserver(self, selector: #selector(ManageViewController.loadList1(_:)),name:NSNotification.Name(rawValue: "load1"), object: nil)
        
        // Reload collectionview data
        NotificationCenter.default.addObserver(self, selector: #selector(ManageViewController.loadList2(_:)),name:NSNotification.Name(rawValue: "load2"), object: nil)
        
        // Reload open/closed data
        NotificationCenter.default.addObserver(self, selector: #selector(ManageViewController.loadList3(_:)),name:NSNotification.Name(rawValue: "load3"), object: nil)
        
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "load1"), object: nil)
        
        // Configure reveal for this view
        let revealController = self.revealViewController()
        _ = revealController?.panGestureRecognizer()
        _ = revealController?.tapGestureRecognizer()
        
        // Account Icon
        let accountIcon = UIImage(named: "userCircle2")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: accountIcon, style: UIBarButtonItemStyle.plain,
                                                                target: revealController, action: #selector(revealController?.revealToggle(_:)))
        
        // Logo
        let logo = UIImage(named: "FhoodLogo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        // Fhooder Cooking time Icon
        let fhooderTime = UIImage(named: "FhooderOnIcon2")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: fhooderTime, style: UIBarButtonItemStyle.plain,
            target: self, action: #selector(ManageViewController.toCookingTimeView))

        
        // TableView Delegate
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.layoutMargins = UIEdgeInsets.zero

        
        // Currency formatter
        self.formatter.numberStyle = .currency
        
        self.addButton.addTarget(self, action: #selector(ManageViewController.segueToAddItemView), for: UIControlEvents.touchUpInside)

        HUD.dismiss()

    }
    
    func isOpen (_ notification: Notification) {
        
        
    
    }
    
    
    func ordersQuery () {
        
        if Fhooder.isOpen == true {
        
            let user = PFUser.current()!
            let query = PFQuery(className: "Fhooder")
            let id = ((user.value(forKey: "fhooder") as AnyObject).objectId)!! as String
            query.getObjectInBackground(withId: id) { (fhooder, error) -> Void in
                
                if error == nil && fhooder != nil {
                    
                    let relation = fhooder!.relation(forKey: "orders")
                    let query2 = relation.query()
                    
                    query2.order(byAscending: "createdAt")
                    query2.findObjectsInBackground(block: { (orders: [PFObject]?, error2: Error?) -> Void in
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
            let alert = UIAlertController(title: "", message:"You have reached maximum items you can add!", preferredStyle: .alert)
            let error = UIAlertAction(title: "Ok", style: .default) { _ in}
            alert.addAction(error)
            self.present(alert, animated: true, completion: nil)
        }
        else {
            
            Fhooder.itemPic = nil
            
            Fhooder.descriptionText = ""
            Fhooder.ingredientsText = ""
            performSegue(withIdentifier: "toAddItemView", sender: self)
        }
    }
    
    
    // Reload Parse function to use from other controllers
    func loadList1(_ notification: Notification){
        
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
        self.eatinSign.isHidden = true
        self.deliverySign.isHidden = true
        
        if PFUser.current() != nil {
            let user = PFUser.current()!
            let query = PFQuery(className: "Fhooder")
            let id = ((user.value(forKey: "fhooder") as AnyObject).objectId)!! as String
            query.getObjectInBackground(withId: id) { (fhooder: PFObject?, error: Error?) -> Void in
                if error == nil && fhooder != nil {
                    
                    // fhooder information pulled
                    
                    Fhooder.objectID = fhooder?.objectId
                    self.shopName.text = fhooder!.value(forKey: "shopName")! as? String
                    let userImageFile = fhooder!.value(forKey: "profilePic") as! PFFile
                    userImageFile.getDataInBackground {
                        (imageData: Data?, error: Error?) -> Void in
                        if error == nil {
                            if let imageData = imageData {
                                self.fhooderPic = UIImage(data:imageData)
                                Fhooder.fhooderPicture = self.fhooderPic
                            }
                        }
                    }
                    
                    let ratings = fhooder?.value(forKey: "ratings") as? Double
                    let spoons = String(format: "%.1f", ratings!)
                    self.spoonRating.image = UIImage(named: spoons)
                    
                    self.reviewCount.text = "\(fhooder!.value(forKey: "reviews")!) Reviews"
                    
                    // If it has apt or bldg number
                    var unit : String?
                    if fhooder?.value(forKey: "unitAddress") != nil {
                        unit = fhooder!.value(forKey: "unitAddress")! as? String
                        if unit != "" {
                            unit = unit! + ", "
                            
                            self.fhooderAddress.text = "\(fhooder!.value(forKey: "streetAddress")!), \(unit)\(fhooder!.value(forKey: "city")!), \(fhooder!.value(forKey: "stateProvince")!) \(fhooder!.value(forKey: "zip")!)"
                        }
                    }
                    self.fhooderAddress.text =  "\(fhooder!.value(forKey: "streetAddress")!), \(fhooder!.value(forKey: "city")!), \(fhooder!.value(forKey: "stateProvince")!) \(fhooder!.value(forKey: "zip")!)"
                    
                    self.phoneNumber.text = fhooder!.value(forKey: "phone") as? String
                    self.restaurantType.text = "\(fhooder!.value(forKey: "foodTypeOne")!), \(fhooder!.value(forKey: "foodTypeTwo")!), \(fhooder!.value(forKey: "foodTypeThree")!)"
                    self.aboutFhooder = (fhooder!.value(forKey: "shopDescription") as? String)!
                    self.fhooderFirstName = (fhooder!.value(forKey: "firstName") as? String)!
                    
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
    func loadList2(_ notification: Notification){
        self.collectionView.reloadData()
    }
    
    // Reload shop open/close status
    func loadList3(_ notification: Notification){
        if Fhooder.isOpen == true {
            self.openNowOrClose.text = "OPEN NOW"
            self.openNowOrClose.textColor = UIColor(red: 0.0/255.0, green: 200.0/255.0, blue: 0.0/255.0, alpha: 1)
        }
        else {
            self.openNowOrClose.text = "CLOSED"
            self.openNowOrClose.textColor = UIColor.red
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
        performSegue(withIdentifier: "toCookingTime", sender: self)
    }

    
    
    // CollectionView
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrItemNames.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collCell2", for: indexPath) as! ManageCollectionViewCell
        
        cell.foodImage.image = self.itemPictures[indexPath.item]
        
        
        cell.foodName.text = arrItemNames[indexPath.item]
        cell.foodName.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        cell.foodName.textColor = UIColor.white
        
        cell.foodPrice.text = formatter.string(from: (arrPrice[indexPath.item]) as NSNumber)
        cell.foodPrice.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        cell.foodPrice.textColor = UIColor.white
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        Fhooder.itemIndex = indexPath.item
        
        Fhooder.itemPic = self.itemPictures[indexPath.item]
        Fhooder.itemNames = self.arrItemNames
        Fhooder.itemPrices = self.arrPrice
        Fhooder.itemDescription = self.arrDecriptions
        Fhooder.itemIngredients = self.arrIngredients
        Fhooder.itemPreferences = self.arrPreference
        Fhooder.itemID = self.arrItemID
                
        performSegue(withIdentifier: "toItemDetailView", sender: self)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 150, height: 150)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int) -> UIEdgeInsets {
            return sectionInsets
    }

    
    
    // TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Try to get a cell to reuse
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tablecell") as! ManageTableViewCell

        // Make the insets to zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        // Customize cell
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        cell.tableViewLabel!.text = self.tableCellList[indexPath.row] as? String
        cell.tableViewImage.image = UIImage(named: (tableCellImage.object(at: indexPath.row) as! String) )

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            
            Fhooder.fhooderPicture = self.fhooderPic
            Fhooder.fhooderAboutMe = self.aboutFhooder
            Fhooder.fhooderFirstName = self.fhooderFirstName
            performSegue(withIdentifier: "toAboutFhooder", sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
