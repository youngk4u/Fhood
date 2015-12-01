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

private let kDefaultMapZoom = 13.0
private let kPinAnnotationReuseIdentifier = "pinAnnotationIdentifier"

final class MapViewController: UIViewController, UISearchBarDelegate {

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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.mapView.delegate = self
        self.calloutView.delegate = self
        self.locationManager.delegate = self
        self.showUserLocation()

        self.mapView.calloutView = self.calloutView

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

       // fhooderTen()
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
            style: UIBarButtonItemStyle.Plain, target: revealController, action: "revealToggle:")

        // Filter Icon
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Filter 2"),
            style: UIBarButtonItemStyle.Plain, target: self, action: "filterAction:")
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
}

// MARK: - MKMapViewDelegate implementation

extension MapViewController: MKMapViewDelegate {

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is AnnotationObject else { return nil }

        let pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(kPinAnnotationReuseIdentifier) ??
            MKAnnotationView(annotation: annotation, reuseIdentifier: kPinAnnotationReuseIdentifier)

        pinView.canShowCallout = false
        pinView.annotation = annotation
        pinView.image = UIImage(named: "FhooderOn")

        return pinView
    }

    func mapView(mapView: MKMapView, didSelectAnnotationView annotationView: MKAnnotationView) {
        guard annotationView.reuseIdentifier == kPinAnnotationReuseIdentifier else { return }

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
}

// MARK: - CLLocationManagerDelegate implementation

extension MapViewController: CLLocationManagerDelegate {

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        self.showUserLocation()
    }

    func showUserLocation() {
        switch CLLocationManager.authorizationStatus() {
        case .AuthorizedWhenInUse, .AuthorizedAlways:
            self.followUserButton.hidden = false
            self.mapView.showsUserLocation = true
            self.mapView.setUserTrackingMode(.Follow, animated: true)
        case .NotDetermined:
            self.locationManager.requestWhenInUseAuthorization()
            fallthrough
        default:
            self.mapView.showsUserLocation = false
            self.followUserButton.hidden = true
        }
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
        fhooderOne()
        performSegueWithIdentifier("fhooderOne", sender: self)
    }
}
