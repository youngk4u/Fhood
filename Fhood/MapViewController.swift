//
//  MapViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 5/17/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
//

import UIKit
import Parse
import MapKit
import CoreLocation
import SMCalloutView

private let kPinAnnotationReuseIdentifier = "pinAnnotationIdentifier"

final class MapViewController: UIViewController, UISearchBarDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet private var mapView: MapView!
    @IBOutlet private var followUserButton: UIButton!

    private let locationManager = CLLocationManager()
    private let searchBars = UISearchBar()
    private let calloutView = SMCalloutView()

    private var filterMenu: FilterMenu?
    private var filterShown = false

    private var span: MKCoordinateSpan!
    private var location: CLLocationCoordinate2D!
    private var region: MKCoordinateRegion!
    private var userLoc: CLLocation!
    
    private var mapChangedFromUserInteraction = false
    private var zoomWithinMiles: Double = 2.5
    
    @IBOutlet var reloadAnnotationsButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.mapView.delegate = self
        self.calloutView.delegate = self
        self.locationManager.delegate = self
        self.showUserLocation()

        self.mapView.calloutView = self.calloutView
        
        self.reloadAnnotationsButton.hidden = true
        
        
        

        // Search Bar
        UISearchBar.appearance().backgroundImage = nil // Search Bar with no rim
        self.navigationItem.titleView = UIBarButtonItem(customView: searchBars).customView
        self.searchBars.delegate = self
        self.searchBars.placeholder = "Sandwich"

        // Configure reveal for this view
        let revealController = self.revealViewController()
        revealController.panGestureRecognizer()
        revealController.tapGestureRecognizer()

        // Custom Back button -> Cancel button
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: nil, action: nil)

        // Account Icon
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "userCircle2"),
                                                                style: UIBarButtonItemStyle.Plain, target: revealController, action: #selector(revealController.revealToggle))

        // Filter Icon
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Filter 2"),
                                                                 style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MapViewController.filterAction))
        
        
        
    }
    
      
    


    
    func zoomedWithinMiles() -> Double {
        
        // zoomed out or zoomed in latitude times constant 35.7 shows annotations in zoomed area
        let lat = self.mapView.region.span.latitudeDelta
        let withinMiles = lat * 35.7
        
        return withinMiles
    }


    func reloadAnnotations() {
        
        //Put Fhooders on the map
        PFGeoPoint.geoPointForCurrentLocationInBackground { ( point: PFGeoPoint?, error: NSError?) -> Void in
            if error == nil {
                
                var point = PFGeoPoint()
                
                if self.userLoc != nil {
                    point = PFGeoPoint(location: self.userLoc)
                
                    let query = PFQuery(className: "Fhooder")
                    query.limit = 10
                    query.whereKey("location", nearGeoPoint: point, withinMiles: self.zoomWithinMiles)
                    query.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
                        if (error == nil) {
                            
                            for object in objects! {
                                
                                let geolocation = object.valueForKey("location")!
                                let picFile = object.valueForKey("itemPic") as? PFFile
                                
                                picFile?.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                                    if error == nil {
                                        if let imageData = imageData {
                                            Fhooder.objectID = object.valueForKey("objectId") as? String
                                            Fhooder.itemPic = UIImage(data: imageData)
                                            Fhooder.itemPrice = object.valueForKey("itemPrice") as? Double
                                            
                                            Fhooder.shopName = object.valueForKey("shopName")! as? String
                                            Fhooder.foodTypeOne = "\(object.valueForKey("foodTypeOne")!)"
                                            
                                            Fhooder.fhooderLatitude = geolocation.latitude
                                            Fhooder.fhooderLongitude = geolocation.longitude
                                            Fhooder.reviews = object.valueForKey("ratings")! as? Int
                                            Fhooder.isOpen = object.valueForKey("isOpen")! as? Bool
                                            Fhooder.ratingInString = "no-Spoon"
                                            
                                            
                                            let annotation = AnnotationObject(objectID: Fhooder.objectID!, title: Fhooder.shopName!, subtitle: Fhooder.foodTypeOne!, coordinate: CLLocationCoordinate2D(latitude: Fhooder.fhooderLatitude!, longitude: Fhooder.fhooderLongitude!), countReviews: Fhooder.reviews!, image: Fhooder.itemPic!, price: Fhooder.itemPrice!, open: Fhooder.isOpen!, imageRating: UIImage(named: Fhooder.ratingInString!)!)
                                            
                                            self.mapView.addAnnotation(annotation)
                                            
                                        }
                                    }
                                })
                                
                            }
                        }
                    })
                }
            }
        }

    }
  


    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    
    func filterAction(sender: AnyObject) {
        /*
        if filterMenu == nil {
            let sections = [FilterMenuSectionInfo(titles: ["Less than $5", "$5 ~ $10", "More than $10"]),
                FilterMenuSectionInfo(titles: ["Highest rated", "Most reviewed"]),
                FilterMenuSectionInfo(titles: ["Open now", "Reserve"]),
                FilterMenuSectionInfo(titles: ["Pick up", "Eat in", "Delivery"])]

            filterMenu = FilterMenu(navigationController: self.navigationController!, sections: sections, delegate: self)
        }

        if filterShown {
            filterMenu?.hide()
        } else {
            filterMenu?.show()
        }

        filterShown = !filte_ rShown
        */
    }

    func filterMenuViewDidSelect(section: Int, subMenu: Int) {
        print("Did select: \nsection: \(section)\nsubMenu:\(subMenu)")
        if (section == 1 && subMenu == 1) {

        }
        else if (section == 1 && subMenu ==  2) {

        }
    }


    
    @IBAction func reloadAnno(sender: AnyObject) {
        
        HUD.show()
        
        let annotationsToRemove = mapView.annotations.filter { $0 !== mapView.userLocation }
        mapView.removeAnnotations(annotationsToRemove)
        self.reloadAnnotations()
        self.reloadAnnotationsButton.hidden = true
        
        HUD.dismiss()
        
    }
    
    
    
// MARK: - MKMapViewDelegate implementation
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is AnnotationObject else { return nil }

        let pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(kPinAnnotationReuseIdentifier) ??
            MKAnnotationView(annotation: annotation, reuseIdentifier: kPinAnnotationReuseIdentifier)

        
        pinView.image = UIImage(named: "FhooderOn")
        
        pinView.canShowCallout = false
        pinView.annotation = annotation
        
        return pinView
    }

    func mapView(mapView: MKMapView, didSelectAnnotationView annotationView: MKAnnotationView) {
        guard annotationView.reuseIdentifier == kPinAnnotationReuseIdentifier else { return }

        let anno = annotationView.annotation as? AnnotationObject
        Fhooder.objectID = anno!.objectID
        
        self.calloutView.contentView = BubbleView.nibView(withAnnotation: annotationView.annotation as? AnnotationObject)
        self.calloutView.calloutOffset = annotationView.calloutOffset
        self.calloutView.contentViewInset = UIEdgeInsetsZero
        self.calloutView.backgroundView = BubbleBackgroundView()
        self.calloutView.presentCalloutFromRect(annotationView.bounds, inView: annotationView,
            constrainedToView: self.view, animated: true)
    }

    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        self.calloutView.dismissCalloutAnimated(true)
    }
    
    func mapViewRegionDidChangeFromUserInteraction() -> Bool {
        let view: UIView = self.mapView.subviews[0] as UIView
        //  Look through gesture recognizers to determine whether this region change is from user interaction
        if let gestureRecognizers = view.gestureRecognizers {
            for recognizer in gestureRecognizers {
                if( recognizer.state == UIGestureRecognizerState.Began || recognizer.state == UIGestureRecognizerState.Ended ) {
                    return true
                }
            }
        }
        return false
    }
    
    func mapView(mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        
        mapChangedFromUserInteraction = mapViewRegionDidChangeFromUserInteraction()
        
        
        if (mapChangedFromUserInteraction) {
            
            self.zoomWithinMiles = self.zoomedWithinMiles()
            
            self.location = mapView.centerCoordinate
            let centre = mapView.centerCoordinate as CLLocationCoordinate2D
            
            let getLat: CLLocationDegrees = centre.latitude
            let getLon: CLLocationDegrees = centre.longitude
            
            self.userLoc =  CLLocation(latitude: getLat, longitude: getLon)
            
            self.reloadAnnotationsButton.hidden = false
            
        }
        
    }
    
}




// MARK: - CLLocationManagerDelegate implementation

extension MapViewController: CLLocationManagerDelegate {

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {

        self.showUserLocation()
    }
    

    func showUserLocation() {
        switch CLLocationManager.authorizationStatus() {
        case .AuthorizedWhenInUse, .AuthorizedAlways:
            self.mapView.region = MKCoordinateRegionMakeWithDistance(mapView.centerCoordinate, 50, 50)
            self.mapView.setRegion(self.mapView.region, animated: true)
            self.followUserButton.hidden = false
            self.mapView.showsUserLocation = true
            self.mapView.setUserTrackingMode(.Follow, animated: true)
            self.locationManager.startUpdatingLocation()
        case .NotDetermined:
            self.locationManager.requestWhenInUseAuthorization()
            fallthrough
        default:
            self.mapView.showsUserLocation = false
            self.followUserButton.hidden = true
        }
    }

    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
            self.locationManager.startUpdatingLocation()
            let userLoction: CLLocation = locations.last as CLLocation!
            let latitude = userLoction.coordinate.latitude
            let longitude = userLoction.coordinate.longitude
            let latDelta: CLLocationDegrees = 0.06
            let lonDelta: CLLocationDegrees = 0.06
            self.span = MKCoordinateSpanMake(latDelta, lonDelta)
            self.location = CLLocationCoordinate2DMake(latitude, longitude)
            self.region = MKCoordinateRegionMake(location, span)
            self.mapView.setRegion(region, animated: true)
            self.mapView.showsUserLocation = true
            self.locationManager.stopUpdatingLocation()
        
        self.userLoc = userLoction
        self.reloadAnnotations()
        
    }
    

    @IBAction private func toggleFollowUserLocation() {
        let mode: MKUserTrackingMode = self.mapView.userTrackingMode == .None ? .Follow : .None
        self.mapView.setUserTrackingMode(mode, animated: true)
    }
}

// MARK: - SMCalloutViewDelegate implementation

extension MapViewController: SMCalloutViewDelegate {

    func calloutView(calloutView: SMCalloutView, delayForRepositionWithSize offset: CGSize) -> NSTimeInterval {
        let currentCenter = self.mapView.convertCoordinate(self.mapView.centerCoordinate, toPointToView: self.view)
        let newCenter = CGPoint(x: currentCenter.x - offset.width, y: currentCenter.y - offset.height)

        let centerCoordinate = self.mapView.convertPoint(newCenter, toCoordinateFromView: self.view)
        self.mapView.setCenterCoordinate(centerCoordinate, animated: true)
        return kSMCalloutViewRepositionDelayForUIScrollView
    }


    func calloutViewClicked(calloutView: SMCalloutView) {
    
        performSegueWithIdentifier("fhooderDetail", sender: self)
    
    }
}
