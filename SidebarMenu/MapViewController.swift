//
//  MapViewController.swift
//  SidebarMenu
//
//  Created by Simon Ng on 2/2/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


@available(iOS 9.0, *)
class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var mapview: MKMapView!
    
    let locationManager = CLLocationManager()
    
    @IBAction func zoomToCurrentLocation(sender: AnyObject) {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        let authorizationStatus = CLLocationManager.authorizationStatus()
        
        if authorizationStatus == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if (authorizationStatus == .AuthorizedAlways || authorizationStatus == .AuthorizedWhenInUse) {
            print("authorized. requesting location")
            locationManager.startUpdatingLocation()
            mapview.showsUserLocation = true
        }
    }
  
    
    
    
    
  
    
    func mapTypeChanged(segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapview.mapType = .Standard
        case 1:
            mapview.mapType = .Hybrid
        case 2:
            mapview.mapType = .Satellite
        default:
            break
        }
    }
    
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        
        mapview.setRegion(region, animated: true)
        
        locationManager.stopUpdatingLocation()
    }

    override func viewDidLoad() {
        //ALways call the super implementation of viewDidload.
        super.viewDidLoad()
        
        //this is for menu button
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        let latitude:CLLocationDegrees = 40.7
        
        let longtitude:CLLocationDegrees = -73.9
        
        let latDelta:CLLocationDegrees = 0.01
        
        let lonDelta:CLLocationDegrees = 0.01
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longtitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        mapview.setRegion(region, animated: true)
        
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        segmentedControl.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self, action: "mapTypeChanged:", forControlEvents: .ValueChanged)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        mapview.addSubview(segmentedControl)
        
        let topConstraint = segmentedControl.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor, constant: 8)
        
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraintEqualToAnchor(margins.trailingAnchor)
        
        topConstraint.active = true
        leadingConstraint.active = true
        trailingConstraint.active = true
        
        
        
        locationManager.requestWhenInUseAuthorization()
    
        //locationManager.delegate = self
        
        print("MapViewController loaded its view.")
    }
    
    
}
