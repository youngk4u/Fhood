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

    var itemReceipt : [String] = []
    var qtyReceipt : [Int] = []
    var priceReceipt : [Double] = []

    var totalItemPrice : Double = 0

    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var TableView3: UITableView!
    @IBOutlet weak var doneButton: UIButton!
    
    var selectedRow2 : Int = 0
    var formatter = NSNumberFormatter()


    var tableCellList : NSArray = ["Reviews", "Photos", "Send messages", "About the Fhooder"]
    var tableCellImage : NSArray = ["reviews", "photos", "messages", "about"]

    let sectionInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
    
    // Create Message Composer
    let messageComposer = MessageComposer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Reload collectionview data
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadList:",name:"load", object: nil)
        
        // Pull data from the selected fhooder
        self.shopName.text = variables.name!
        self.spoonRating.image = UIImage(named: variables.ratingInString!)
        self.reviewCount.text = "\(variables.reviews!) Reviews"
        self.restaurantType.text = "\(variables.foodType![0]), \(variables.foodType![1]), \(variables.foodType![2])"
        self.fhooderAddress.text = variables.address
        self.fhooderDistance.text = "(\(variables.distance!) miles)"
        self.pickupSign.hidden = !variables.pickup!
        self.eatinSign.hidden = !variables.eatin!
        self.deliverySign.hidden = !variables.delivery!
        self.phoneNumber.text = variables.phoneNum!

        var newOpenMinute: String
        var newCloseMinute: String

        if variables.timeOpenMinute < 10 {
            newOpenMinute = "0\(String(variables.timeOpenMinute!))"
        } else {
            newOpenMinute = String(variables.timeOpenMinute!)
        }
        
        if variables.timeCloseMinute < 10 {
            newCloseMinute = "0\(String(variables.timeCloseMinute!))"
        } else {
            newCloseMinute = String(variables.timeCloseMinute!)
        }
        
        if variables.isOpen == true {
            self.openNowOrClose.text = "Open Now; Closes at \(variables.timeCloseHour!):\(newCloseMinute) \(variables.timeCloseAmpm!)"
        } else {
            self.openNowOrClose.text = "Closed; Opens at \(variables.timeOpenHour!):\(newOpenMinute) \(variables.timeOpenAmpm!)"
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
        fhoodie.isAnythingSelected = false
        fhoodie.selectedTotalItemPrice = 0


    }
    
    // Reload collectionview function to use from other controllers
    func loadList(notification: NSNotification){
        self.collectionView.reloadData()
    }
    
   
    
    
    // CollectionView
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return variables.itemNames!.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let coCell = collectionView.dequeueReusableCellWithReuseIdentifier("collCell", forIndexPath: indexPath) as! CollectionViewCell

        self.totalItemPrice = 0

        coCell.fhoodImage.image = UIImage(named: (variables.itemNames![indexPath.item] ) )

        coCell.foodName.text = variables.itemNames![indexPath.item]
        coCell.foodName.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        coCell.foodName.textColor = UIColor.whiteColor()

        coCell.foodPrice.text = formatter.stringFromNumber(variables.itemPrices![indexPath.item])
        coCell.foodPrice.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        coCell.foodPrice.textColor = UIColor.whiteColor()

        if variables.itemCount![indexPath.item] == 0 {
            coCell.foodQuantity.text = ""
            coCell.foodQuantity.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0)
        
            coCell.subtractButton.alpha = 0
            coCell.subtractButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0)
        } else {
            coCell.foodQuantity.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            coCell.foodQuantity.text = " x " + "\(Int(variables.itemCount![indexPath.item]))"
            coCell.subtractButton.alpha = 0.8
            coCell.subtractButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        }

        coCell.subtractButton.layer.setValue(indexPath.item, forKey: "index")
        coCell.subtractButton.addTarget(self, action: "subtractItem:", forControlEvents: UIControlEvents.TouchUpInside)
        
        if fhoodie.isAnythingSelected == false {
            self.doneButton.alpha = 0
            self.totalPrice.text = "$0.00"
        } else {
            for var i = 0; i < variables.itemCount!.count; i++ {
                self.totalItemPrice += (Double(variables.itemCount![i]) * variables.itemPrices![i])
            }

            fhoodie.selectedTotalItemPrice! = self.totalItemPrice
            self.totalPrice.text = formatter.stringFromNumber(fhoodie.selectedTotalItemPrice!)

            self.doneButton.alpha = 1
            self.doneButton.addTarget(self, action: "donePressed:", forControlEvents: UIControlEvents.TouchUpInside)
        }
        return coCell
    }

    
    // Subtract icon function
    func subtractItem(sender: UIButton) {
        let i = sender.layer.valueForKey("index") as! Int

        variables.itemCount![i]--
        self.totalItemPrice = 0
        
        for var i = 0; i < variables.itemCount!.count; i++ {
            self.totalItemPrice += (Double(variables.itemCount![i]) * variables.itemPrices![i])
        }
        fhoodie.selectedTotalItemPrice! = self.totalItemPrice
        
        if fhoodie.selectedTotalItemPrice! == 0 {
            fhoodie.isAnythingSelected = false
        }
        
        self.totalPrice.text = formatter.stringFromNumber(fhoodie.selectedTotalItemPrice!)

        self.collectionView.reloadData()
    }

    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let coCell = collectionView.cellForItemAtIndexPath(indexPath) as! CollectionViewCell

        self.totalItemPrice = 0
        
        fhoodie.selectedIndex = indexPath.item

        performSegueWithIdentifier("toDetailView", sender: self)

        if variables.itemCount![indexPath.item] != 0 {
            coCell.foodQuantity.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            coCell.foodQuantity.text = " x " + "\(Int(variables.itemCount![indexPath.item]))"
            coCell.subtractButton.alpha = 0.8
            coCell.subtractButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)

            for var i = 0; i < variables.itemCount!.count; i++ {
                self.totalItemPrice += (Double(variables.itemCount![i]) * variables.itemPrices![i])
            }
            fhoodie.selectedTotalItemPrice! = self.totalItemPrice

            self.totalPrice.text = formatter.stringFromNumber(fhoodie.selectedTotalItemPrice!)
            self.doneButton.alpha = 1
            self.doneButton.addTarget(self, action: "donePressed:", forControlEvents: UIControlEvents.TouchUpInside)
        } else if fhoodie.selectedTotalItemPrice! == 0 {
            self.totalPrice.text = "$0.00"
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
        
        // Organize the receipt list
        for var i = 0; i < variables.itemNames!.count; i++ {
            if variables.itemCount![i] != 0 {
                self.itemReceipt.append(variables.itemNames![i])
                self.qtyReceipt.append(variables.itemCount![i])
                self.priceReceipt.append(variables.itemPrices![i])
            }
        }
        
        // Save on fhoodie struct
        fhoodie.selectedItemNames = self.itemReceipt
        fhoodie.selectedItemCount = self.qtyReceipt
        fhoodie.selectedItemPrices = self.priceReceipt
        fhoodie.selectedTotalItemPrice = self.totalItemPrice
        
        performSegueWithIdentifier("toReceiptView", sender: self)
    }
        


    
    // TableView  (iPhone 6 plus: set Width to 414, iPhone 6: 375, iPhone 5/5s: 320)
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
