//
//  OrdersViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 8/30/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
//

import UIKit
import Parse

final class OrdersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var TableView: UITableView!
    
    var orderID : [String] = []
    var orderUser : [String] = []
    var fhoodieID : [String] = []
    var orderUserPic : [UIImageView] = []
    var orderUserPhoto: [UIImage] = []
    var orderedTime : [String] = []
    
    var dateFormatter = NSDateFormatter()
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Reload Parse data
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(OrdersViewController.loadList1(_:)), name: "fhooderOrderLoad", object: nil)
        
        NSNotificationCenter.defaultCenter().postNotificationName("fhooderOrderLoad", object: nil)
        
        // Configure reveal for this view
        let revealController = self.revealViewController()
        revealController?.panGestureRecognizer()
        revealController?.tapGestureRecognizer()
        
        // Account Icon
        let accountIcon = UIImage(named: "userCircle2")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: accountIcon, style: UIBarButtonItemStyle.Plain,
                                                                target: revealController, action: #selector(revealViewController().revealToggle(_:)))
        
        // Logo
        let logo = UIImage(named: "FhoodLogo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        
        // Fhooder Cooking time Icon
        let fhooderTime = UIImage(named: "FhooderOnIcon2")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: fhooderTime, style: UIBarButtonItemStyle.Plain,
                                                                 target: self, action: #selector(ManageViewController.toCookingTimeView))

        
        // TableView Delegates
        self.TableView.delegate = self
        self.TableView.dataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(OrdersViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        TableView.addSubview(refreshControl) // not required when using UITableViewController
        
        
    }
    
    func toCookingTimeView () {
        performSegueWithIdentifier("toCookingTime", sender: self)
    }
    
    
    
    func refresh(sender:AnyObject) {

        NSNotificationCenter.defaultCenter().postNotificationName("fhooderOrderLoad", object: nil)
        
        refreshControl.endRefreshing()
    }
    
    func badgeAlert (counting: Int) {
    
        if counting != 0 {
            let badgeNumber = String(counting)
            self.tabBarItem.badgeValue = badgeNumber
        }
    }
    
    
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){
        
    }
    
    
    // Reload Parse function to use from other_  controllers
    func loadList1(notification: NSNotification){
        

        if PFUser.currentUser() != nil {
        let user = PFUser.currentUser()!
            let query = PFQuery(className: "Fhooder")
            let id = user.valueForKey("fhooder")!.objectId!! as String
            query.getObjectInBackgroundWithId(id) { (fhooder: PFObject?, error: NSError?) -> Void in
                if error == nil && fhooder != nil {
                    
                    // fhooder information pulled
                    
                    Fhooder.objectID = fhooder?.objectId
                    
                    let relation = fhooder!.relationForKey("orders")
                    let query2 = relation.query()
         
                    query2.orderByAscending("createdAt")
                    query2.findObjectsInBackgroundWithBlock( { (orders: [PFObject]?, error2: NSError?) -> Void in
                        
                        self.orderID = []
                        self.orderUserPic = []
                        self.orderUserPhoto = []
                        self.orderUser = []
                        self.orderedTime = []
                        self.fhoodieID = []
                        
                        if error2 == nil && orders != nil {
                            for order in orders! {
                                
                                let status = order["orderStatus"] as! String
                                
                                if status == "Made" || status == "Confirmed" {
                                
                                    let id = order.objectId
                                    self.orderID.append(id!)
                                    
                                    let pic = order["userPic"] as! PFFile
                                    
                                    
                                    do {
                                      let picData : NSData = try pic.getData()
                                        let picture = UIImage(data: picData)
                                        let image = UIImageView(image: picture)
                                        image.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
                                        image.layer.masksToBounds = false
                                        image.layer.cornerRadius = 13
                                        image.layer.cornerRadius = image.frame.size.height/2
                                        image.clipsToBounds = true
                                        
                                        self.orderUserPic.append(image)
                                        self.orderUserPhoto.append(picture!)
                                        
                                        let name = order["userName"] as! String
                                        self.orderUser.append(name)
                                        
                                        let userId = order["userId"] as! String
                                        self.fhoodieID.append(userId)
                                        
                                        let orderTime = order.createdAt
                                        
                                        self.dateFormatter.timeStyle = .ShortStyle
                                        self.orderedTime.append("Ordered at \(self.dateFormatter.stringFromDate( orderTime!))")
                                        
                                        self.TableView.reloadData()
                                        
                                    }
                                    catch {
                                        print("error")
                                    }
                                }
                                else {
                                    self.TableView.reloadData()
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

    

    // Table View
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderUser.count
    }
            
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Try to get a cell to reuse
        let cell = tableView.dequeueReusableCellWithIdentifier("Tablecell") as! OrdersTableViewCell
        
        // Cell Marginal lines on the left to stretch all the way to the left screen
        cell.layoutMargins = UIEdgeInsetsZero

        // Link Fhoodie information
        
       
        cell.orderTime.text = self.orderedTime[indexPath.row]
        cell.orderNumber.text = String((indexPath as NSIndexPath).row + 1)
        cell.userPic.addSubview(self.orderUserPic[(indexPath as NSIndexPath).row])
        cell.userID.text = self.orderUser[indexPath.row]
        cell.userRating.image = UIImage(named: Fhooder.ratingInString!)
        cell.pickupCountdown.text = "Pending"

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        Fhoodie.fhoodieFirstName = self.orderUser[indexPath.row]
        Fhoodie.fhoodiePhoto = self.orderUserPhoto[indexPath.row]
        Fhoodie.fhoodieOrderID = self.orderID[indexPath.row]
        Fhoodie.fhoodieID = self.fhoodieID[indexPath.row]
    
        TableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
