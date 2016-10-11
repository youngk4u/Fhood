//
//  ListViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 5/17/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
//

import UIKit
import Parse
import MapKit
import CoreLocation

final class ListViewController: UIViewController, UISearchBarDelegate, FilterMenuDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    // Put Fhooder lists in array
    private var array : [String] = []
    var fhooderPics : [UIImageView] = []
    var fhooderItemPrices : [Double] = []
    var fhooderSpoons : [String] = []
    var fhooderReviews : [Int] = []
    var fhooderPickups : [Bool] = []
    var fhooderEatins : [Bool] = []
    var fhooderDelivers : [Bool] = []
    var fhooderTypesOne : [String] = []
    var fhooderTypesTwo : [String] = []
    var fhooderTypesThree : [String] = []
    var fhooderOpens : [Bool] = []
    var fhooderCloses : [Bool] = []
    var fhooderDistances : [Double] = []
    var fhooderID : [String] = []
    
    private let searchBars = UISearchBar()
    private let formatter = NSNumberFormatter()
    private let locationManager = CLLocationManager()
    private var userLoc: CLLocation!
    private var refreshCounter: Double = 0


    @IBOutlet private var TableView: UITableView!

    private var filterMenu: FilterMenu?
    private var filterShown = false
    
    private var arrPrice = [Double]()

    var refreshControl: UIRefreshControl!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        // Reload Parse data
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ListViewController.findFhooders(_:)), name: "fhooderListLoad", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("fhooderListLoad", object: nil)
        
        
        // Custom Back button -> Cancel button
        let backItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        // Search Bar
        self.searchBars.delegate = self
        let navBarButton = UIBarButtonItem(customView: searchBars)
        self.navigationItem.titleView = navBarButton.customView
        self.searchBars.placeholder = "Sandwich"
        
        // Search Bar with no rim
        UISearchBar.appearance().backgroundImage = nil

        // Configure reveal for this view
        let revealController = self.revealViewController()
        revealController.panGestureRecognizer()
        revealController.tapGestureRecognizer()

        // Account Icon
        let accountIcon = UIImage(named: "userCircle2")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: accountIcon, style: UIBarButtonItemStyle.Plain,
                                                                target: revealController, action: #selector(revealController.revealToggle))

        // Filter Icon
        let filterIcon = UIImage(named: "Filter 2")
        let rightBarButton = UIBarButtonItem(image: filterIcon, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ListViewController.filterAction(_:)))
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        // Swipe to left only
        let swipeLeft = UISwipeGestureRecognizer(target: revealController, action: #selector(revealController.revealToggle))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)

        self.TableView.delegate = self
        self.TableView.dataSource = self
        self.TableView.layoutMargins = UIEdgeInsetsZero
        
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ListViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        TableView.addSubview(refreshControl) // not required when using UITableViewController

        // Currency formatter
        self.formatter.numberStyle = .CurrencyStyle
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        self.userLoc = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
    }
    
    
    func refresh(sender:AnyObject) {
        self.refreshCounter += 1
        NSNotificationCenter.defaultCenter().postNotificationName("fhooderListLoad", object: nil)
        refreshControl.endRefreshing()
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func filterAction(sender: AnyObject) {
        if filterMenu == nil {
            let sections = [
                FilterMenuSectionInfo(titles: ["Less than $5", "$5 ~ $10", "More than $10"]),
                FilterMenuSectionInfo(titles: ["Highest rated", "Most reviewed"]),
                FilterMenuSectionInfo(titles: ["Open now", "Reserve"]),
                FilterMenuSectionInfo(titles: ["Pick up", "Eat in", "Delivery"])
            ]
            
            filterMenu = FilterMenu(navigationController: self.navigationController!, sections: sections, delegate: self)
        }
        
        if filterShown {
            filterMenu?.hide()
        } else {
            filterMenu?.show()
        }
        
        filterShown = !filterShown
    }
    
    func filterMenuViewDidSelect(section: Int, subMenu: Int) {
        print("Did select: \nsection: \(section)\nsubMenu:\(subMenu)")

        if (section == 1 && subMenu == 1) {
            
        } else if (section == 1 && subMenu == 2) {
            
        }
    }
    
    
    
    func findFhooders(notification: NSNotification) {
        
        // Find Fhooders near you
        PFGeoPoint.geoPointForCurrentLocationInBackground { ( point: PFGeoPoint?, error: NSError?) -> Void in
            if error == nil {
                
                var point = PFGeoPoint()
                
                if self.userLoc != nil {
                    point = PFGeoPoint(location: self.userLoc)
                    
                    let query = PFQuery(className: "Fhooder")
                    let limit = 10 + (10 * self.refreshCounter)
                    query.limit = Int(limit)
                    query.whereKey("location", nearGeoPoint: point, withinMiles: limit)
                    query.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
                        
                        self.fhooderID = []
                        self.fhooderPics = []
                        self.fhooderItemPrices = []
                        self.array = []
                        self.fhooderSpoons = []
                        self.fhooderReviews = []
                        self.fhooderPickups = []
                        self.fhooderEatins = []
                        self.fhooderDelivers = []
                        self.fhooderTypesOne = []
                        self.fhooderTypesTwo = []
                        self.fhooderTypesThree = []
                        self.fhooderOpens = []
                        self.fhooderCloses = []
                        self.fhooderDistances = []
                        
                        if (error == nil) {
                            
                            for object in objects! {
                                
                                let picFile = object.valueForKey("itemPic") as? PFFile
                                let ID = object.objectId
                                
                                do {
                                    let picData : NSData = try picFile!.getData()
                                    let picture = UIImage(data: picData)
                                    let image = UIImageView(image: picture)
                                    image.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
                                    image.layer.masksToBounds = false
                                    image.layer.cornerRadius = 13
                                    image.layer.cornerRadius = image.frame.size.height/2
                                    image.clipsToBounds = true
                                    
                                    self.fhooderPics.append(image)
                                    
                                    let name = object.valueForKey("shopName") as? String
                                    self.array.append(name!)
                                    
                                    let itemPrice = object.valueForKey("itemPrice") as? Double
                                    self.fhooderItemPrices.append(itemPrice!)
                                    
                                    let spoons = object.valueForKey("ratings") as? Double
                                    let spoonsString = String(format: "%.1f", spoons!)
                                    self.fhooderSpoons.append(spoonsString)
                                    
                                    let review = object.valueForKey("reviews") as? Int
                                    self.fhooderReviews.append(review!)
                                    
                                    let pickup = object.valueForKey("isPickup") as? Bool
                                    self.fhooderPickups.append(pickup!)
                                    
                                    let eatin = object.valueForKey("isEatin") as? Bool
                                    self.fhooderEatins.append(eatin!)
                                    
                                    let deliver = object.valueForKey("isDeliver") as? Bool
                                    self.fhooderDelivers.append(deliver!)
                                    
                                    let typeOne = object.valueForKey("foodTypeOne") as? String
                                    self.fhooderTypesOne.append(typeOne!)
                                    
                                    let typeTwo = object.valueForKey("foodTypeTwo") as? String
                                    self.fhooderTypesTwo.append(typeTwo!)
                                    
                                    let typeThree = object.valueForKey("foodTypeThree") as? String
                                    self.fhooderTypesThree.append(typeThree!)
                                    
                                    let isOpen = object.valueForKey("isOpen") as? Bool
                                    if isOpen == true {
                                        self.fhooderOpens.append(isOpen!)
                                        self.fhooderCloses.append(!isOpen!)
                                    } else {
                                        self.fhooderOpens.append(!isOpen!)
                                        self.fhooderCloses.append(isOpen!)
                                    }
                                    
                                    // Distance to fhooder in Mile
                                    let fhooderlocation = object.valueForKey("location") as? PFGeoPoint
                                    let CLLoc = fhooderlocation!.location()
                                    let distance = CLLoc.distanceFromLocation(self.userLoc)
                                    let distanceMile = distance * 0.000621371
                                    let x = round(distanceMile * 10) / 10
                                    
                                    self.fhooderDistances.append(x)
                                    
                                    self.fhooderID.append(ID!)

                                    self.TableView.reloadData()
                                    
                                }
                                catch {
                                    print("error")
                                }
                                
                              
                                self.TableView.reloadData()
                            }
                        }
                    })
                }
            }
        }
        
    }
    
    

    // Table View
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Try to get a cell to reuse
        let cell = tableView.dequeueReusableCellWithIdentifier("Tablecell") as! ListTableViewCell
        
        let row = indexPath.row

        cell.fhooderPic.addSubview(self.fhooderPics[(indexPath as NSIndexPath).row])
        cell.fhooderPrice.text = formatter.stringFromNumber(self.fhooderItemPrices[row])
        cell.fhooderName.text = self.array[row]
        cell.fhooderSpoon.image = UIImage(named: "\(self.fhooderSpoons[row])")
        cell.fhooderReview.text = "\(String(self.fhooderReviews[row])) reviews"
        cell.fhooderPickup.hidden = !self.fhooderPickups[row]
        cell.fhooderEatin.hidden = !self.fhooderEatins[row]
        cell.fhooderDelivery.hidden = !self.fhooderDelivers[row]
        cell.fhooderType.text = "\(self.fhooderTypesOne[row]), \(self.fhooderTypesTwo[row]), \(self.fhooderTypesThree[row])"
        cell.fhooderOpen.hidden = self.fhooderOpens[row]
        cell.fhooderClosed.hidden = self.fhooderCloses[row]
        cell.fhooderDistance.text = "\(self.fhooderDistances[row]) miles"
        
        
        // Cell Marginal lines on the left to stretch all the way to the left screen
        cell.layoutMargins = UIEdgeInsetsZero
        
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        Fhooder.objectID = self.fhooderID[indexPath.row]
        Fhooder.distance = self.fhooderDistances[indexPath.row]
        TableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension PFGeoPoint {
    
    func location() -> CLLocation {
        return CLLocation(latitude: self.latitude, longitude: self.longitude)
    }
}


