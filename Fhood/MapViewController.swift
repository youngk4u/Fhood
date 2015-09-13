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
import SMCalloutView

private let pinAnnotationReuseIdentifier = "pinAnnotationIdentifier"

final class MapViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate {
    
    @IBOutlet private var mapView: MKMapView!
    @IBOutlet private var cancelInfo: UIButton!

    private let locationManager = CLLocationManager()
    private let searchBars = UISearchBar()
    private let calloutView = SMCalloutView()

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

        self.mapView.setRegion(region, animated: false)
        self.mapView.delegate = self
        self.calloutView.delegate = self

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
        
        
        self.mapView.addAnnotation(obj1)
        self.mapView.addAnnotation(obj2)
        self.mapView.addAnnotation(obj3)
        self.mapView.addAnnotation(obj4)
        self.mapView.addAnnotation(obj5)
        self.mapView.addAnnotation(obj6)
        self.mapView.addAnnotation(obj7)
        self.mapView.addAnnotation(obj8)
        self.mapView.addAnnotation(obj9)
        self.mapView.addAnnotation(obj10)

        // Custom Back button -> Cancel button
        let backItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        
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
        self.calloutView.contentView = BubbleView.nibView(withAnnotation: annotationView.annotation as? AnnotationObject)
        self.calloutView.calloutOffset = annotationView.calloutOffset
        self.calloutView.constrainedInsets = UIEdgeInsets(top: self.topLayoutGuide.length, left: 0, bottom: self.bottomLayoutGuide.length, right: 0)
        self.calloutView.contentViewInset = UIEdgeInsetsZero
        self.calloutView.presentCalloutFromRect(annotationView.bounds, inView: annotationView, constrainedToView: self.view, animated: true)
    }

    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        self.calloutView.dismissCalloutAnimated(true)
    }
}

// MARK: - SMCalloutViewDelegate implementation

extension MapViewController: SMCalloutViewDelegate {

    func calloutView(calloutView: SMCalloutView, delayForRepositionWithSize offset: CGSize) -> NSTimeInterval {
        let currentCenter = self.mapView.convertCoordinate(self.mapView.centerCoordinate, toPointToView: self.view)
        let newCenter = CGPoint(x: currentCenter.x - offset.width, y: currentCenter.x - offset.height)

        let centerCoordinate = self.mapView.convertPoint(newCenter, toCoordinateFromView: self.view)
        self.mapView.setCenterCoordinate(centerCoordinate, animated: true)

        return kSMCalloutViewRepositionDelayForUIScrollView
    }
}
