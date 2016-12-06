//
//  MapViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 5/17/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
//

import UIKit
import Parse
import MapKit
import CoreLocation
import SMCalloutView

private let kPinAnnotationReuseIdentifier = "pinAnnotationIdentifier"

final class MapViewController: UIViewController, UISearchBarDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet fileprivate var mapView: MapView!
    @IBOutlet fileprivate var followUserButton: UIButton!

    fileprivate let locationManager = CLLocationManager()
    fileprivate let searchBars = UISearchBar()
    fileprivate let calloutView = SMCalloutView()

    fileprivate var filterMenu: FilterMenu?
    fileprivate var filterShown = false

    fileprivate var span: MKCoordinateSpan!
    fileprivate var location: CLLocationCoordinate2D!
    fileprivate var region: MKCoordinateRegion!
    fileprivate var userLoc: CLLocation!
    fileprivate var userLocation: CLLocation!
    
    fileprivate var mapChangedFromUserInteraction = false
    fileprivate var zoomWithinMiles: Double = 2.5
    
    @IBOutlet var reloadAnnotationsButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.mapView.delegate = self
        self.calloutView.delegate = self
        self.locationManager.delegate = self
        self.showUserLocation()

        self.mapView.calloutView = self.calloutView
        
        self.reloadAnnotationsButton.isHidden = true
        
        let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
        self.userLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        
        // Search Bar
        UISearchBar.appearance().backgroundImage = nil // Search Bar with no rim
        self.navigationItem.titleView = UIBarButtonItem(customView: searchBars).customView
        self.searchBars.delegate = self
        self.searchBars.placeholder = "Bento"

        // Configure reveal for this view
        let revealController = self.revealViewController()
        _ = revealController?.panGestureRecognizer()
        _ = revealController?.tapGestureRecognizer()

        // Custom Back button -> Cancel button
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: nil)

        // Account Icon
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "userCircle2"), style: UIBarButtonItemStyle.plain, target: revealController, action: #selector(revealController?.revealToggle(_:)))


        // Filter Icon
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Filter 2"),
                                                                 style: UIBarButtonItemStyle.plain, target: self, action: #selector(MapViewController.filterAction))
        
        
        
    }
    
      
    


    
    func zoomedWithinMiles() -> Double {
        
        // zoomed out or zoomed in latitude times constant 35.7 shows annotations in zoomed area
        let lat = self.mapView.region.span.latitudeDelta
        let withinMiles = lat * 35.7
        
        return withinMiles
    }


    func reloadAnnotations() {
        
        //Put Fhooders on the map
        PFGeoPoint.geoPointForCurrentLocation { ( point: PFGeoPoint?, error: Error?) -> Void in
            if error == nil {
                
                var point = PFGeoPoint()
                
                if self.userLoc != nil {
                    point = PFGeoPoint(location: self.userLoc)
                
                    let query = PFQuery(className: "Fhooder")
                    query.limit = 10
                    query.whereKey("location", nearGeoPoint: point, withinMiles: self.zoomWithinMiles)
                    query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) -> Void in
                        if (error == nil) {
                            
                            for object in objects! {
                                
                                let geolocation = object.value(forKey: "location")!
                                let picFile = object.value(forKey: "itemPic") as? PFFile
                                
                                picFile?.getDataInBackground(block: { (imageData: Data?, error: Error?) -> Void in
                                    if error == nil {
                                        if let imageData = imageData {
                                            Fhooder.objectID = object.value(forKey: "objectId") as? String
                                            Fhooder.itemPic = UIImage(data: imageData)
                                            Fhooder.itemPrice = object.value(forKey: "itemPrice") as? Double
                                            
                                            Fhooder.shopName = object.value(forKey: "shopName")! as? String
                                            Fhooder.foodTypeOne = "\(object.value(forKey: "foodTypeOne")!)"
                                            
                                            Fhooder.fhooderLatitude = (geolocation as AnyObject).latitude
                                            Fhooder.fhooderLongitude = (geolocation as AnyObject).longitude
                                            Fhooder.reviews = object.value(forKey: "reviews")! as? Int
                                            Fhooder.isOpen = object.value(forKey: "isOpen")! as? Bool
                                            let ratingInDouble = object.value(forKey: "ratings") as? Double
                                            Fhooder.ratingInString = String(format: "%.1f", ratingInDouble!)
                                            
                                            Fhooder.pickup = object.value(forKey: "isPickup") as? Bool
                                            Fhooder.delivery = object.value(forKey: "isDeliver") as? Bool
                                            Fhooder.eatin = object.value(forKey: "isEatin") as? Bool
                                            
                                            
                                            // Distance to fhooder in Mile
                                            let CLLoc = CLLocation(latitude: (geolocation as AnyObject).latitude, longitude: (geolocation as AnyObject).longitude)
                                            let distance = CLLoc.distance(from: self.userLocation)
                                            let distanceMile = distance * 0.000621371
                                            Fhooder.distance = round(distanceMile * 10) / 10
                                            
                                            let annotation = AnnotationObject(objectID: Fhooder.objectID!, title: Fhooder.shopName!, subtitle: Fhooder.foodTypeOne!, coordinate: CLLocationCoordinate2D(latitude: Fhooder.fhooderLatitude!, longitude: Fhooder.fhooderLongitude!), countReviews: Fhooder.reviews!, image: Fhooder.itemPic!, price: Fhooder.itemPrice!, open: Fhooder.isOpen!, imageRating: UIImage(named: Fhooder.ratingInString!)!, pickup: Fhooder.pickup!, deliver: Fhooder.delivery!, eatin: Fhooder.eatin!, distanceX: Fhooder.distance!)
                                            
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
  


    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    
    func filterAction(_ sender: AnyObject) {
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

    func filterMenuViewDidSelect(_ section: Int, subMenu: Int) {
        print("Did select: \nsection: \(section)\nsubMenu:\(subMenu)")
        if (section == 1 && subMenu == 1) {

        }
        else if (section == 1 && subMenu ==  2) {

        }
    }


    
    @IBAction func reloadAnno(_ sender: AnyObject) {
        
        HUD.show()
        
        let annotationsToRemove = mapView.annotations.filter { $0 !== mapView.userLocation }
        mapView.removeAnnotations(annotationsToRemove)
        self.reloadAnnotations()
        self.reloadAnnotationsButton.isHidden = true
        
        HUD.dismiss()
        
    }
    
    
    
// MARK: - MKMapViewDelegate implementation
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is AnnotationObject else { return nil }

        let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: kPinAnnotationReuseIdentifier) ??
            MKAnnotationView(annotation: annotation, reuseIdentifier: kPinAnnotationReuseIdentifier)

        
        pinView.image = UIImage(named: "FhooderOn")
        pinView.canShowCallout = false
        pinView.annotation = annotation
        
        return pinView
    }

    func mapView(_ mapView: MKMapView, didSelect annotationView: MKAnnotationView) {
        guard annotationView.reuseIdentifier == kPinAnnotationReuseIdentifier else { return }

        let anno = annotationView.annotation as? AnnotationObject
        Fhooder.objectID = anno!.objectID
        Fhooder.distance = anno!.distance
        Fhooder.fhooderLatitude = anno!.coordinate.latitude
        Fhooder.fhooderLongitude = anno!.coordinate.longitude
        
        self.calloutView.contentView = BubbleView.nibView(withAnnotation: annotationView.annotation as? AnnotationObject)
        self.calloutView.calloutOffset = annotationView.calloutOffset
        self.calloutView.contentViewInset = UIEdgeInsets.zero
        self.calloutView.backgroundView = BubbleBackgroundView()
        self.calloutView.presentCallout(from: annotationView.bounds, in: annotationView,
            constrainedTo: self.view, animated: true)
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        self.calloutView.dismissCallout(animated: true)
    }
    
    func mapViewRegionDidChangeFromUserInteraction() -> Bool {
        let view: UIView = self.mapView.subviews[0] as UIView
        //  Look through gesture recognizers to determine whether this region change is from user interaction
        if let gestureRecognizers = view.gestureRecognizers {
            for recognizer in gestureRecognizers {
                if( recognizer.state == UIGestureRecognizerState.began || recognizer.state == UIGestureRecognizerState.ended ) {
                    return true
                }
            }
        }
        return false
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        
        mapChangedFromUserInteraction = mapViewRegionDidChangeFromUserInteraction()
        
        
        if (mapChangedFromUserInteraction) {
            
            self.zoomWithinMiles = self.zoomedWithinMiles()
            
            self.location = mapView.centerCoordinate
            let centre = mapView.centerCoordinate as CLLocationCoordinate2D
            
            let getLat: CLLocationDegrees = centre.latitude
            let getLon: CLLocationDegrees = centre.longitude
            
            self.userLoc =  CLLocation(latitude: getLat, longitude: getLon)
            
            self.reloadAnnotationsButton.isHidden = false
            
        }
        
    }
    
}




// MARK: - CLLocationManagerDelegate implementation

extension MapViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        self.showUserLocation()
    }
    

    func showUserLocation() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            self.mapView.region = MKCoordinateRegionMakeWithDistance(mapView.centerCoordinate, 50, 50)
            self.mapView.setRegion(self.mapView.region, animated: true)
            self.followUserButton.isHidden = false
            self.mapView.showsUserLocation = true
            self.mapView.setUserTrackingMode(.follow, animated: true)
            self.locationManager.startUpdatingLocation()
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
            fallthrough
        default:
            self.mapView.showsUserLocation = false
            self.followUserButton.isHidden = true
        }
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
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
    

    @IBAction fileprivate func toggleFollowUserLocation() {
        let mode: MKUserTrackingMode = self.mapView.userTrackingMode == .none ? .follow : .none
        self.mapView.setUserTrackingMode(mode, animated: true)
    }
}

// MARK: - SMCalloutViewDelegate implementation

extension MapViewController: SMCalloutViewDelegate {

    func calloutView(_ calloutView: SMCalloutView, delayForRepositionWith offset: CGSize) -> TimeInterval {
        let currentCenter = self.mapView.convert(self.mapView.centerCoordinate, toPointTo: self.view)
        let newCenter = CGPoint(x: currentCenter.x - offset.width, y: currentCenter.y - offset.height)

        let centerCoordinate = self.mapView.convert(newCenter, toCoordinateFrom: self.view)
        self.mapView.setCenter(centerCoordinate, animated: true)
        return kSMCalloutViewRepositionDelayForUIScrollView
    }


    func calloutViewClicked(_ calloutView: SMCalloutView) {
    
        performSegue(withIdentifier: "fhooderDetail", sender: self)
    
    }
}
