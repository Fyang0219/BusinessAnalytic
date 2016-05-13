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

        let anotation = MKPointAnnotation()
        anotation.coordinate = center
        anotation.title = "The Location"
        anotation.subtitle = "This is the location !!!"
        mapview.addAnnotation(anotation)
    
        
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
        
        
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
//        let latitude:CLLocationDegrees = 40.7
//        
//        let longtitude:CLLocationDegrees = -73.9
//        
//        let latDelta:CLLocationDegrees = 0.01
//        
//        let lonDelta:CLLocationDegrees = 0.01
//        
//        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
//        
//        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longtitude)
//        
//        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
//        
//        mapview.setRegion(region, animated: true)
//        
//        let anotation = MKPointAnnotation()
//        anotation.coordinate = location
//        anotation.title = "The Location"
//        anotation.subtitle = "This is the location !!!"
//        mapview.addAnnotation(anotation)
        
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
        
        getAllStores();
        
        locationManager.requestWhenInUseAuthorization()
    
        //locationManager.delegate = self
        
        print("MapViewController loaded its view.")
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
        
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        
        let detailButton: UIButton = UIButton(type: UIButtonType.DetailDisclosure)
        
        // Reuse the annotation if possible
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        
        if annotationView == nil
        {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            annotationView!.canShowCallout = true
            annotationView!.image = UIImage(named: "annotation.png")
            annotationView!.rightCalloutAccessoryView = detailButton
        }
        else
        {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    
    func getAllStores () -> Void {
        //get JSON data from Beer API
        let url = NSURL(string: "http://ontariobeerapi.ca/stores/")!
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
            
            if let urlContent = data {
                
                do {
                    
                    // turn json data object into NSArray
                    let jsonResults = try NSJSONSerialization.JSONObjectWithData(urlContent, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                    print(jsonResults.count)
                    
                    for i in 0..<jsonResults.count {
                        
                        let latitude : String = jsonResults.objectAtIndex(i).valueForKey("latitude") as! String
                        let longitude : String = jsonResults.objectAtIndex(i).valueForKey("longitude") as! String
                        
                        var newCoord:CLLocationCoordinate2D = CLLocationCoordinate2D()
                        newCoord.latitude = (latitude as NSString).doubleValue
                        newCoord.longitude = (longitude as NSString).doubleValue

                        let newAnotation = MKPointAnnotation()
                        newAnotation.coordinate = newCoord
                        newAnotation.title = jsonResults.objectAtIndex(i).valueForKey("name") as? String
                        newAnotation.subtitle = jsonResults.objectAtIndex(i).valueForKey("address") as? String
                        self.mapview.addAnnotation(newAnotation)
                
                    }
                } catch {
                    
                    print("error while loading json data")
                    print(error)
                }
            }
        }
        
        task.resume()
    }
    
}
