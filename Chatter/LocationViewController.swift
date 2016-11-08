//
//  LocationViewController.swift
//  Chatter
//
//  Created by Lewis Jones on 01/07/2016.
//  Copyright © 2016 Rodrigo Pena. All rights reserved.
//
import Foundation
import UIKit
import CoreLocation
import MapKit

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class LocationViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    let mapView = MKMapView()
    
    var locationManager = CLLocationManager()
    
    var resultSearchController:UISearchController? = nil
    
    var selectedPin:MKPlacemark? = nil
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        
     title = "Location"
        
        
     view.backgroundColor = UIColor.whiteColor()
        
     navigationController!.navigationBar.barTintColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
        
                
     automaticallyAdjustsScrollViewInsets = false
        
        
        mapView.mapType = .Standard
        mapView.frame = view.frame
        mapView.zoomEnabled = true
        mapView.scrollEnabled = true
        mapView.showsUserLocation = true
        mapView.delegate = self
        view.addSubview(mapView)
        
        if (CLLocationManager.locationServicesEnabled()) {
            
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            
            
        }

        

        let locationSearchViewController = LocationSearchViewController()
        resultSearchController = UISearchController(searchResultsController: locationSearchViewController)
        resultSearchController?.searchResultsUpdater = locationSearchViewController
        definesPresentationContext = true
        locationSearchViewController.mapView = mapView
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchViewController.handleMapSearchDelegate = self
        
    

    }
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getDirections(){
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMapsWithLaunchOptions(launchOptions)
        }
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()

        //Do What ever you want with it
    }
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error:: \(error)")
    }
}
extension LocationViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
                annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
}
extension LocationViewController {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor.orangeColor()
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPointZero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "car"), forState: .Normal)
        button.addTarget(self, action: "getDirections", forControlEvents: .TouchUpInside)
        pinView?.leftCalloutAccessoryView = button
        return pinView
    }
}

