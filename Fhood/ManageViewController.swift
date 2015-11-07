//
//  ManageViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 8/30/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
//

import UIKit

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
    @IBOutlet weak var openNowOrClose: UILabel!

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    var arrImages : NSArray = []
    var arrPrice : [Double]  = []
    var arrItemCount : [Int] = []
    var formatter = NSNumberFormatter()
    
    var tableCellList : NSArray = ["Reviews", "About me"]
    var tableCellImage : NSArray = ["reviews", "about"]

    let sectionInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Reload collectionview data
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadList:",name:"load", object: nil)
        
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
        
        fhooderOne()
        // fhooder information pulled
        self.shopName.text = variables.name!
        self.spoonRating.image = UIImage(named: variables.ratingInString!)
        self.reviewCount.text = "\(variables.reviews!) Reviews"
        self.restaurantType.text = "\(variables.foodType![0]), \(variables.foodType![1]), \(variables.foodType![2])"
        self.fhooderAddress.text = variables.address
        self.fhooderDistance.text = "(\(variables.distance!) miles)"
        self.pickupSign.hidden = !variables.pickup!
        self.eatinSign.hidden = !variables.eatin!
        self.phoneNumber.text = variables.phoneNum!
        
        self.arrImages = variables.itemNames!
        self.arrPrice = variables.itemPrices!
        self.arrItemCount = variables.itemCount!
        
        // Currency formatter
        self.formatter.numberStyle = .CurrencyStyle

    }
    
    // Reload collectionview function to use from other controllers
    func loadList(notification: NSNotification){
        self.collectionView.reloadData()
    }
    
    func toCookingTimeView () {
        performSegueWithIdentifier("toCookingTime", sender: nil)
    }

    // CollectionView
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImages.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collCell", forIndexPath: indexPath) as! ManageCollectionViewCell
        
        cell.foodImage.image = UIImage(named: (arrImages.objectAtIndex(indexPath.item) as! String) )
        
        cell.foodName.text = arrImages.objectAtIndex(indexPath.item) as? String
        cell.foodName.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        cell.foodName.textColor = UIColor.whiteColor()
        
        cell.foodPrice.text = formatter.stringFromNumber(arrPrice[indexPath.item])
        cell.foodPrice.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        cell.foodPrice.textColor = UIColor.whiteColor()
        
        if variables.dailyQuantity![indexPath.item] == 0 {
            cell.foodQuantity.alpha = 0
            cell.orderPerMin.alpha = 0
            cell.foodQuantity.text = ""
            cell.orderPerMin.text = ""
        } else {
            cell.foodQuantity.alpha = 1
            cell.orderPerMin.alpha = 1
            cell.foodQuantity.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            cell.orderPerMin.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            cell.foodQuantity.text = "Daily Qty: " + "\(Int(variables.dailyQuantity![indexPath.item]))"
            cell.orderPerMin.text = "\(variables.maxOrderLimit![indexPath.item]) per \(variables.timeInterval![indexPath.item]) minutes"
        }

        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        variables.itemIndex = indexPath.item
        
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
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
