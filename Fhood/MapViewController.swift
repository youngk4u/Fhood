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

private let pinAnnotationReuseIdentifier = "pinAnnotationIdentifier"

final class MapViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate {
    
    @IBOutlet private var Map: MKMapView!
    @IBOutlet private var cancelInfo: UIButton!
    
    private let locationManager = CLLocationManager()
    private let searchBars = UISearchBar()

    private var filterMenu: FilterMenu?
    private var filterShown = false
    
    private var latitude: CLLocationDegrees!
    private var longitude: CLLocationDegrees!
    private var latDelta: CLLocationDegrees!
    private var lonDelta: CLLocationDegrees!
    private var span: MKCoordinateSpan!
    private var location: CLLocationCoordinate2D!
    private var region: MKCoordinateRegion!

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

        // Configure reveal for this view
        let revealController = self.revealViewController()
        revealController.panGestureRecognizer()
        revealController.tapGestureRecognizer()

        // Account Icon
        let accountIcon = UIImage(named: "userCircle2")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: accountIcon, style: UIBarButtonItemStyle.Plain,
            target: revealController, action: "revealToggle:")

        // Filter Icon
        let filterIcon = UIImage(named: "Filter 2")
        let rightBarButton = UIBarButtonItem(image: filterIcon, style: UIBarButtonItemStyle.Plain, target: self, action: "filterAction:")
        self.navigationItem.rightBarButtonItem = rightBarButton

        // When Fhooder button pressed, you can tap anywhere to disable the info window
        self.cancelInfo.enabled = false
        self.cancelInfo.addTarget(self, action: "cancelPressed:", forControlEvents: UIControlEvents.TouchUpInside)
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    /*
    func filterAction(sender: AnyObject) {
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

// MARK: - MKMapViewDelegate implementation

extension MapViewController: MKMapViewDelegate {

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(pinAnnotationReuseIdentifier) ??
            MKAnnotationView(annotation: annotation, reuseIdentifier: pinAnnotationReuseIdentifier)

        pinView.canShowCallout = false
        pinView.annotation = annotation
        pinView.image = UIImage(named: "FhooderOn")

        return pinView
    }

    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        fhooderOne()
        performSegueWithIdentifier("fhooderOne", sender: self)
    }

    func mapView(mapView: MKMapView, didSelectAnnotationView annotationView: MKAnnotationView) {
        guard let bubbleView = NSBundle.mainBundle().loadNibNamed("BubbleView", owner: self, options: nil)[0] as? BubbleView else { return }
        bubbleView.annotation = annotationView.annotation as? AnnotationObject
        annotationView.addSubview(bubbleView)

        bubbleView.center = CGPointMake(annotationView.bounds.size.width * 0.5, -bubbleView.bounds.size.height * 0.53)
    }

    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        view.subviews.forEach { $0.removeFromSuperview() }
    }
}
