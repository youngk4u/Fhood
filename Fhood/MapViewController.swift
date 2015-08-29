//
//  MapViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 5/17/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SWRevealViewController

final class MapViewController: UIViewController, UISearchBarDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var Map: MKMapView!
    
    let locationManager = CLLocationManager()
    
    var searchBars:UISearchBar = UISearchBar()
    var accountIcon = UIImage(named: "userCircle2")
    var filterIcon  = UIImage(named: "Filter 2")
    
    var filterMenu : FilterMenu?
    var filterShown : Bool = false
    
    var latitude : CLLocationDegrees!
    var longitude : CLLocationDegrees!
    var latDelta : CLLocationDegrees!
    var lonDelta : CLLocationDegrees!
    var span : MKCoordinateSpan!
    var location : CLLocationCoordinate2D!
    var region : MKCoordinateRegion!

    
    @IBOutlet weak var cancelInfo: UIButton!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Map location (San Francisco)
        self.latitude = 37.787212
        self.longitude = -122.419415
        self.latDelta = 0.06
        self.lonDelta = 0.06
        
        self.span = MKCoordinateSpanMake(latDelta, lonDelta)
        self.location = CLLocationCoordinate2DMake(latitude, longitude)
        self.region = MKCoordinateRegionMake(location, span)
        self.Map.setRegion(region, animated: false)
        
        Map.delegate = self
        
        
        // Put Fhooders on the map
        fhooderOne()
        let obj1 = AnnotationObject(title: variables.name!, subtitle: variables.foodType![0], coordinate: CLLocationCoordinate2D(latitude: variables.fhooderLatitude!, longitude: variables.fhooderLongitude!), countReviews: variables.reviews!, image: UIImage(named: variables.fhooderPic!)!, price: variables.itemPrices![0], open: variables.isOpen!, closed: variables.isClosed!, imageRating: UIImage(named: variables.ratingInString!)!)
        
        fhooderTwo()
        let obj2 = AnnotationObject(title: variables.name!, subtitle: variables.foodType![0], coordinate: CLLocationCoordinate2D(latitude: variables.fhooderLatitude!, longitude: variables.fhooderLongitude!), countReviews: variables.reviews!, image: UIImage(named: variables.fhooderPic!)!, price: variables.itemPrices![0], open: variables.isOpen!, closed: variables.isClosed!, imageRating: UIImage(named: variables.ratingInString!)!)
        
        fhooderThree()
        let obj3 = AnnotationObject(title: variables.name!, subtitle: variables.foodType![0], coordinate: CLLocationCoordinate2D(latitude: variables.fhooderLatitude!, longitude: variables.fhooderLongitude!), countReviews: variables.reviews!, image: UIImage(named: variables.fhooderPic!)!, price: variables.itemPrices![0], open: variables.isOpen!, closed: variables.isClosed!, imageRating: UIImage(named: variables.ratingInString!)!)
        
        fhooderFour()
        let obj4 = AnnotationObject(title: variables.name!, subtitle: variables.foodType![0], coordinate: CLLocationCoordinate2D(latitude: variables.fhooderLatitude!, longitude: variables.fhooderLongitude!), countReviews: variables.reviews!, image: UIImage(named: variables.fhooderPic!)!, price: variables.itemPrices![0], open: variables.isOpen!, closed: variables.isClosed!, imageRating: UIImage(named: variables.ratingInString!)!)
        
        fhooderFive()
        let obj5 = AnnotationObject(title: variables.name!, subtitle: variables.foodType![0], coordinate: CLLocationCoordinate2D(latitude: variables.fhooderLatitude!, longitude: variables.fhooderLongitude!), countReviews: variables.reviews!, image: UIImage(named: variables.fhooderPic!)!, price: variables.itemPrices![0], open: variables.isOpen!, closed: variables.isClosed!, imageRating: UIImage(named: variables.ratingInString!)!)
        
        fhooderSix()
        let obj6 = AnnotationObject(title: variables.name!, subtitle: variables.foodType![0], coordinate: CLLocationCoordinate2D(latitude: variables.fhooderLatitude!, longitude: variables.fhooderLongitude!), countReviews: variables.reviews!, image: UIImage(named: variables.fhooderPic!)!, price: variables.itemPrices![0], open: variables.isOpen!, closed: variables.isClosed!, imageRating: UIImage(named: variables.ratingInString!)!)
        
        fhooderSeven()
        let obj7 = AnnotationObject(title: variables.name!, subtitle: variables.foodType![0], coordinate: CLLocationCoordinate2D(latitude: variables.fhooderLatitude!, longitude: variables.fhooderLongitude!), countReviews: variables.reviews!, image: UIImage(named: variables.fhooderPic!)!, price: variables.itemPrices![0], open: variables.isOpen!, closed: variables.isClosed!, imageRating: UIImage(named: variables.ratingInString!)!)
        
        fhooderEight()
        let obj8 = AnnotationObject(title: variables.name!, subtitle: variables.foodType![0], coordinate: CLLocationCoordinate2D(latitude: variables.fhooderLatitude!, longitude: variables.fhooderLongitude!), countReviews: variables.reviews!, image: UIImage(named: variables.fhooderPic!)!, price: variables.itemPrices![0], open: variables.isOpen!, closed: variables.isClosed!, imageRating: UIImage(named: variables.ratingInString!)!)
        
        fhooderNine()
        let obj9 = AnnotationObject(title: variables.name!, subtitle: variables.foodType![0], coordinate: CLLocationCoordinate2D(latitude: variables.fhooderLatitude!, longitude: variables.fhooderLongitude!), countReviews: variables.reviews!, image: UIImage(named: variables.fhooderPic!)!, price: variables.itemPrices![0], open: variables.isOpen!, closed: variables.isClosed!, imageRating: UIImage(named: variables.ratingInString!)!)
        
        fhooderTen()
        let obj10 = AnnotationObject(title: variables.name!, subtitle: variables.foodType![0], coordinate: CLLocationCoordinate2D(latitude: variables.fhooderLatitude!, longitude: variables.fhooderLongitude!), countReviews: variables.reviews!, image: UIImage(named: variables.fhooderPic!)!, price: variables.itemPrices![0], open: variables.isOpen!, closed: variables.isClosed!, imageRating: UIImage(named: variables.ratingInString!)!)
        
        
        Map.addAnnotation(obj1)
        Map.addAnnotation(obj2)
        Map.addAnnotation(obj3)
        Map.addAnnotation(obj4)
        Map.addAnnotation(obj5)
        Map.addAnnotation(obj6)
        Map.addAnnotation(obj7)
        Map.addAnnotation(obj8)
        Map.addAnnotation(obj9)
        Map.addAnnotation(obj10)
        
        
        // Custom Back button -> Cancel button
        let backItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        // Search Bar
        self.searchBars.delegate = self
        let navBarButton = UIBarButtonItem(customView: searchBars)
        self.navigationItem.titleView = navBarButton.customView
        self.searchBars.placeholder = "Sandwich"
        
        // Search Bar with no rim
        UISearchBar.appearance().backgroundImage = UIImage(named: "")
   
        // Account Icon
        let leftBarButton = UIBarButtonItem(image: accountIcon, style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        // Account menu
        leftBarButton.target = self.revealViewController()
        leftBarButton.action = Selector("revealToggle:")

        // Filter Icon
        let rightBarButton = UIBarButtonItem(image: filterIcon, style: UIBarButtonItemStyle.Plain, target: self, action: "filterAction:")
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        // Swipe to left only
        let swipeLeft = UISwipeGestureRecognizer(target: self.revealViewController(), action: "revealToggle:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)

        // When Fhooder button pressed, you can tap anywhere to disable the info window
        self.cancelInfo.enabled = false
        self.cancelInfo.addTarget(self, action: "cancelPressed:", forControlEvents: UIControlEvents.TouchUpInside)
    }

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?{
        let reuseIdentifier = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseIdentifier)
        
        if pinView == nil {
            
            pinView = BubbleView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            pinView!.canShowCallout = false
            
        }
        else {
            pinView!.annotation = annotation
        }
        //Set custom pin image
        pinView!.image = UIImage(named: "FhooderOn")
        
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
            performSegueWithIdentifier("fhooderOne", sender: self)
        
    }
    
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView){
        
        
        let bubbleView = NSBundle.mainBundle().loadNibNamed("BubbleView", owner: self, options: nil)[0] as? BubbleView
        let annotationObj = view.annotation as! AnnotationObject
        bubbleView?.SetUpView(annotationObj)
        bubbleView?.layer.cornerRadius = 10
        view.addSubview(bubbleView!)
        
        bubbleView?.center = CGPointMake(bubbleView!.bounds.size.width*0.1, -bubbleView!.bounds.size.height*0.53)
        
        
    }
    
    /*
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        fhooderOne()
        performSegueWithIdentifier("fhooderOne", sender: self)
    }
    */
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        
        for v in view.subviews
        {
            v.removeFromSuperview()
        }

    }

    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
    }
    

    
    override func viewDidAppear(animated: Bool) {
        

    }
/*
    func filterAction(sender: AnyObject) {
        if filterMenu == nil
        {
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
        
        filterShown = !filterShown
    }
    
    func filterMenuViewDidSelect(section: Int, subMenu: Int) {
        
        print("Did select: \nsection: \(section)\nsubMenu:\(subMenu)")
        
        if (section == 1 && subMenu == 1) {
    
        }
        else if (section == 1 && subMenu == 2) {
            
        }
    }
    

*/

    func cancelPressed(sender: UIButton)  {
        self.cancelInfo.enabled = false
    }

}
