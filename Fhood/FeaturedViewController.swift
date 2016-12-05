//
//  FeaturedViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 5/18/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
//

import UIKit
import Parse

final class FeaturedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet private var tableView: UITableView!
    
    var fhooderPic: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Reload Parse data
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FeaturedViewController.getImage(_:)), name: "getImage", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("getImage", object: nil)

        
        let logo = UIImage(named: "FhoodLogo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.layoutMargins = UIEdgeInsetsZero

        // Configure reveal for this view
        let revealController = self.revealViewController()
        revealController.panGestureRecognizer()
        revealController.tapGestureRecognizer()

        // Account Icon
        let accountIcon = UIImage(named: "userCircle2")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: accountIcon, style: UIBarButtonItemStyle.Plain,
                                                                target: revealController, action: #selector(revealViewController().revealToggle))
        
        
    }
    
    func getImage(notification: NSNotification) {
        
        let query = PFQuery(className: "Fhooder")
        
        // Featured Fhooder ID
        Fhooder.objectID = "oCWrWgSv4h"
        
        query.getObjectInBackgroundWithId(Fhooder.objectID!) { (object: PFObject?, error: NSError?) -> Void in
            if error == nil && object != nil {
                
                
                Fhooder.shopName = object?.valueForKey("shopName") as? String
                Fhooder.foodTypeOne = object?.valueForKey("foodTypeOne") as? String
                Fhooder.rating = object?.valueForKey("ratings") as? Double
                Fhooder.ratingInString = String(Fhooder.rating!)
                Fhooder.reviews = object?.valueForKey("reviews") as? Int
                
                let pic = object?.valueForKey("itemPic") as! PFFile
                
                pic.getDataInBackgroundWithBlock {
                    (imageData: NSData?, error: NSError?) -> Void in
                    if error == nil {
                        if let imageData = imageData {
                            Fhooder.itemPic = UIImage(data:imageData)
                            let image = UIImageView(image: Fhooder.itemPic)
                            image.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
                            image.layer.masksToBounds = false
                            image.layer.cornerRadius = 13
                            image.layer.cornerRadius = image.frame.size.height/2
                            image.clipsToBounds = true
                            
                            self.fhooderPic = image
       
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }

        
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("featuredTableCell") as! FeaturedTableViewCell
        
        cell.layoutMargins = UIEdgeInsetsZero
        
        
        cell.featuredName.text = Fhooder.shopName!
        cell.featuredType.text = Fhooder.foodTypeOne!
        cell.featuredSpoon.image = UIImage(named: Fhooder.ratingInString!)
        cell.featuredReviewCount.text = "\(Int(Fhooder.reviews!)) Reviews"
        if self.fhooderPic != nil {
            cell.featuredImage.addSubview(self.fhooderPic)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        Fhooder.objectID = "oCWrWgSv4h"
        self.performSegueWithIdentifier("toFhooderView", sender: tableView)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
