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
    var newOrder : [Bool] = []
    
    var dateFormatter = DateFormatter()
    
    var refreshControl: UIRefreshControl!
    
    
    override func viewDidAppear(_ animated: Bool) {
        tabBarController?.tabBar.items?[1].badgeValue = nil
        UIApplication.shared.applicationIconBadgeNumber = 0
        Fhooder.orderQuantity! = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Reload Parse data
        NotificationCenter.default.addObserver(self, selector: #selector(OrdersViewController.loadList1(_:)), name: NSNotification.Name(rawValue: "fhooderOrderLoad"), object: nil)
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "fhooderOrderLoad"), object: nil)
        
        // Configure reveal for this view
        let revealController = self.revealViewController()
        _ = revealController?.panGestureRecognizer()
        _ = revealController?.tapGestureRecognizer()
        
        // Account Icon
        let accountIcon = UIImage(named: "userCircle2")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: accountIcon, style: UIBarButtonItemStyle.plain,
                                                                target: revealController, action: #selector(revealViewController().revealToggle(_:)))
        
        // Logo
        let logo = UIImage(named: "FhoodLogo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        
        // Fhooder Cooking time Icon
        let fhooderTime = UIImage(named: "FhooderOnIcon2")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: fhooderTime, style: UIBarButtonItemStyle.plain,
                                                                 target: self, action: #selector(ManageViewController.toCookingTimeView))

        
        // TableView Delegates
        self.TableView.delegate = self
        self.TableView.dataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(OrdersViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        TableView.addSubview(refreshControl) // not required when using UITableViewController
        
        
    }
    
    func toCookingTimeView () {
        performSegue(withIdentifier: "toCookingTime", sender: self)
    }
    
    
    
    @objc func refresh(_ sender:AnyObject) {

        NotificationCenter.default.post(name: Notification.Name(rawValue: "fhooderOrderLoad"), object: nil)
        refreshControl.endRefreshing()
    }
    
    func badgeAlert (_ counting: Int) {
    
        if counting != 0 {
            let badgeNumber = String(counting)
            self.tabBarItem.badgeValue = badgeNumber
        }
    }
    
    
    
    @IBAction func prepareForUnwind(_ segue: UIStoryboardSegue){
        
    }
    
    
    // Reload Parse function to use from other_  controllers
    @objc func loadList1(_ notification: Notification){
        
        if PFUser.current() != nil {
        let user = PFUser.current()!
            let query = PFQuery(className: "Fhooder")
            let id = (user.value(forKey: "fhooder")! as AnyObject).objectId!! as String
            query.getObjectInBackground(withId: id) { (fhooder: PFObject?, error: Error?) -> Void in
                if error == nil && fhooder != nil {
                    
                    // fhooder information pulled
                    
                    Fhooder.objectID = fhooder?.objectId
                    
                    let relation = fhooder!.relation(forKey: "orders")
                    let query2 = relation.query()
         
                    query2.order(byAscending: "createdAt")
                    query2.findObjectsInBackground( block: { (orders: [PFObject]?, error2: Error?) -> Void in
                        
                        self.orderID = []
                        self.orderUserPic = []
                        self.orderUserPhoto = []
                        self.orderUser = []
                        self.orderedTime = []
                        self.fhoodieID = []
                        self.newOrder = []
                        
                        if error2 == nil && orders != nil {
                            for order in orders! {
                                
                                let status = order["orderStatus"] as! String
                                
                                if status == "New" || status == "Accepted" {
                                
                                    let id = order.objectId
                                    self.orderID.append(id!)
                                    
                                    let pic = order["userPic"] as! PFFile
                                    
                                    if status == "New" {
                                        self.newOrder.append(true)
                                    } else {
                                        self.newOrder.append(false)
                                    }
                                    
                                    do {
                                        let picData : Data = try pic.getData()
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
                                        
                                        self.dateFormatter.timeStyle = .short
                                        self.orderedTime.append("Ordered at \(self.dateFormatter.string( from: orderTime!))")
                                        
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderUser.count
    }
            
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Try to get a cell to reuse
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tablecell") as! OrdersTableViewCell
        
        // Cell Marginal lines on the left to stretch all the way to the left screen
        cell.layoutMargins = UIEdgeInsets.zero

        // Link Fhoodie information

        cell.orderTime.text = self.orderedTime[indexPath.row]
        cell.orderNumber.text = String((indexPath as IndexPath).row + 1)
        cell.userPic.addSubview(self.orderUserPic[(indexPath as IndexPath).row])
        cell.userID.text = self.orderUser[indexPath.row]
        cell.userRating.image = UIImage(named: Fhooder.ratingInString!)
        cell.pickupCountdown.text = "Pending"
        
        if self.newOrder[indexPath.row] == true {
            cell.newOrderLabel.isHidden = false
        } else {
            cell.newOrderLabel.isHidden = true
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        Fhoodie.fhoodieFirstName = self.orderUser[indexPath.row]
        Fhoodie.fhoodiePhoto = self.orderUserPhoto[indexPath.row]
        Fhoodie.fhoodieOrderID = self.orderID[indexPath.row]
        Fhoodie.fhoodieID = self.fhoodieID[indexPath.row]
    
        TableView.deselectRow(at: indexPath, animated: true)
    }
}

