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
    fileprivate var array : [String] = []
    var fhooderPics : [UIImageView] = []
    var fhooderItemPrices : [Double] = []
    var fhooderSpoons : [String] = []
    var fhooderReviews : [Int] = []
    var fhooderPickups : [Bool] = []
    var fhooderDelivers : [Bool] = []
    var fhooderEatins : [Bool] = []
    var fhooderTypesOne : [String] = []
    var fhooderTypesTwo : [String] = []
    var fhooderTypesThree : [String] = []
    var fhooderOpens : [Bool] = []
    var fhooderCloses : [Bool] = []
    var fhooderDistances : [Double] = []
    var fhooderID : [String] = []
    var fhooderlocation : [PFGeoPoint] = []
    
    fileprivate let searchBars = UISearchBar()
    fileprivate let formatter = NumberFormatter()
    fileprivate let locationManager = CLLocationManager()
    fileprivate var userLoc: CLLocation!
    fileprivate var refreshCounter: Double = 0


    @IBOutlet fileprivate var TableView: UITableView!

    fileprivate var filterMenu: FilterMenu?
    fileprivate var filterShown = false
    
    fileprivate var arrPrice = [Double]()

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
        NotificationCenter.default.addObserver(self, selector: #selector(ListViewController.findFhooders(_:)), name: NSNotification.Name(rawValue: "fhooderListLoad"), object: nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "fhooderListLoad"), object: nil)
        
        
        // Custom Back button -> Cancel button
        let backItem = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: nil)
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
        _ = revealController?.panGestureRecognizer()
        _ = revealController?.tapGestureRecognizer()

        // Account Icon
        let accountIcon = UIImage(named: "userCircle2")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: accountIcon, style: UIBarButtonItemStyle.plain,
                                                                target: revealController, action: #selector(revealController?.revealToggle(_:)))

        // Filter Icon
        let filterIcon = UIImage(named: "Filter 2")
        let rightBarButton = UIBarButtonItem(image: filterIcon, style: UIBarButtonItemStyle.plain, target: self, action: #selector(ListViewController.filterAction(_:)))
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        // Swipe to left only
        let swipeLeft = UISwipeGestureRecognizer(target: revealController, action: #selector(revealController?.revealToggle(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)

        self.TableView.delegate = self
        self.TableView.dataSource = self
        self.TableView.layoutMargins = UIEdgeInsets.zero
        
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ListViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        TableView.addSubview(refreshControl) // not required when using UITableViewController

        // Currency formatter
        self.formatter.numberStyle = .currency
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        self.userLoc = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
    }
    

    
    
    @objc func refresh(_ sender:AnyObject) {
        self.refreshCounter += 1
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "fhooderListLoad"), object: nil)
        refreshControl.endRefreshing()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    @objc func filterAction(_ sender: AnyObject) {
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
    
    func filterMenuViewDidSelect(_ section: Int, subMenu: Int) {
        print("Did select: \nsection: \(section)\nsubMenu:\(subMenu)")

        if (section == 1 && subMenu == 1) {
            
        } else if (section == 1 && subMenu == 2) {
            
        }
    }
    
    
    
    @objc func findFhooders(_ notification: Notification) {
        
        // Find Fhooders near you
        PFGeoPoint.geoPointForCurrentLocation { ( point: PFGeoPoint?, error: Error?) -> Void in
            if error == nil {
                
                var point = PFGeoPoint()
                
                if self.userLoc != nil {
                    point = PFGeoPoint(location: self.userLoc)
                    
                    let query = PFQuery(className: "Fhooder")
                    let limit = 10 + (10 * self.refreshCounter)
                    query.limit = Int(limit)
                    query.whereKey("location", nearGeoPoint: point, withinMiles: limit)
                    query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) -> Void in
                        
                        self.fhooderID = []
                        self.fhooderPics = []
                        self.fhooderItemPrices = []
                        self.array = []
                        self.fhooderSpoons = []
                        self.fhooderReviews = []
                        self.fhooderPickups = []
                        self.fhooderDelivers = []
                        self.fhooderEatins = []
                        self.fhooderTypesOne = []
                        self.fhooderTypesTwo = []
                        self.fhooderTypesThree = []
                        self.fhooderOpens = []
                        self.fhooderCloses = []
                        self.fhooderDistances = []
                        self.fhooderlocation = []
                        
                        if (error == nil) {
                            
                            for object in objects! {
                                
                                let picFile = object.value(forKey: "itemPic") as? PFFile
                                let ID = object.objectId
                                
                                picFile?.getDataInBackground(block: { (imageData: Data?, error: Error?) -> Void in
                                    if error == nil {
                                        if let imageData = imageData {
                                            
                                            let picture = UIImage(data: imageData)
                                            let image = UIImageView(image: picture)
                                            image.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
                                            image.layer.masksToBounds = false
                                            image.layer.cornerRadius = 13
                                            image.layer.cornerRadius = image.frame.size.height/2
                                            image.clipsToBounds = true
                                            
                                            self.fhooderPics.append(image)
                                            
                                            let name = object.value(forKey: "shopName") as? String
                                            self.array.append(name!)
                                            
                                            let itemPrice = object.value(forKey: "itemPrice") as? Double
                                            self.fhooderItemPrices.append(itemPrice!)
                                            
                                            let spoons = object.value(forKey: "ratings") as? Double
                                            let spoonsString = String(format: "%.1f", spoons!)
                                            self.fhooderSpoons.append(spoonsString)
                                            
                                            let review = object.value(forKey: "reviews") as? Int
                                            self.fhooderReviews.append(review!)
                                            
                                            let pickup = object.value(forKey: "isPickup") as? Bool
                                            self.fhooderPickups.append(pickup!)
                                            
                                            let deliver = object.value(forKey: "isDeliver") as? Bool
                                            self.fhooderDelivers.append(deliver!)
                                            
                                            let eatin = object.value(forKey: "isEatin") as? Bool
                                            self.fhooderEatins.append(eatin!)
                                            
                                            let typeOne = object.value(forKey: "foodTypeOne") as? String
                                            self.fhooderTypesOne.append(typeOne!)
                                            
                                            let typeTwo = object.value(forKey: "foodTypeTwo") as? String
                                            self.fhooderTypesTwo.append(typeTwo!)
                                            
                                            let typeThree = object.value(forKey: "foodTypeThree") as? String
                                            self.fhooderTypesThree.append(typeThree!)
                                            
                                            let isOpen = object.value(forKey: "isOpen") as? Bool
                                            if isOpen == true {
                                                self.fhooderOpens.append(true)
                                                self.fhooderCloses.append(false)
                                            } else {
                                                self.fhooderOpens.append(false)
                                                self.fhooderCloses.append(true)
                                            }
                                            
                                            // Distance to fhooder in Mile
                                            let geopoint = object.value(forKey: "location") as? PFGeoPoint
                                            self.fhooderlocation.append(geopoint!)
                                            let CLLoc = geopoint!.location()
                                            let distance = CLLoc.distance(from: self.userLoc)
                                            let distanceMile = distance * 0.000621371
                                            let x = round(distanceMile * 10) / 10
                                            
                                            self.fhooderDistances.append(x)
                                            
                                            
                                            self.fhooderID.append(ID!)

                                            self.TableView.reloadData()
                                    
                                        }

                                    }
                                    
                                })
                                self.TableView.reloadData()
                            }
                        }
                    })
                }
            }
        }
        
    }
    
    

    // Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Try to get a cell to reuse
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tablecell") as! ListTableViewCell
        
        let row = indexPath.row

        cell.fhooderPic.addSubview(self.fhooderPics[(indexPath as IndexPath).row])
        cell.fhooderPrice.text = formatter.string(from: (self.fhooderItemPrices[row]) as NSNumber)
        cell.fhooderName.text = self.array[row]
        cell.fhooderSpoon.image = UIImage(named: "\(self.fhooderSpoons[row])")
        cell.fhooderReview.text = "\(String(self.fhooderReviews[row])) reviews"
        cell.fhooderPickup.isHidden = !self.fhooderPickups[row]
        cell.fhooderDelivery.isHidden = !self.fhooderDelivers[row]
        cell.fhooderEatin.isHidden = !self.fhooderEatins[row]
        cell.fhooderType.text = "\(self.fhooderTypesOne[row]), \(self.fhooderTypesTwo[row]), \(self.fhooderTypesThree[row])"
        cell.fhooderOpen.isHidden = !self.fhooderOpens[row]
        cell.fhooderClosed.isHidden = !self.fhooderCloses[row]
        cell.fhooderDistance.text = "\(self.fhooderDistances[row]) miles"
        
        
        // Cell Marginal lines on the left to stretch all the way to the left screen
        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        Fhooder.objectID = self.fhooderID[indexPath.row]
        Fhooder.distance = self.fhooderDistances[indexPath.row]
        Fhooder.fhooderLatitude = self.fhooderlocation[indexPath.row].latitude
        Fhooder.fhooderLongitude = self.fhooderlocation[indexPath.row].longitude
        TableView.deselectRow(at: indexPath, animated: true)
    }
}

extension PFGeoPoint {
    
    func location() -> CLLocation {
        return CLLocation(latitude: self.latitude, longitude: self.longitude)
    }
}


