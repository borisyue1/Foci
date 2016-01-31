//
//  ViewController.swift
//  lah2
//
//  Created by Shivam Dave on 1/30/16.
//  Copyright © 2016 ShivamDave. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Social


class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate {
    
    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    var addressSSS: String? = ""
    static var address: String? = ""
    @IBAction func share(sender: AnyObject) {
        let controller = UIActivityViewController(activityItems: ["Great place to study!"], applicationActivities: nil)
        controller.excludedActivityTypes = [UIActivityTypePostToTencentWeibo]
        
        self.presentViewController(controller, animated: true, completion: nil)
//        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(controller, animated: true, completion: nil)
        
        
    }

    @IBOutlet weak var search: UISearchBar!
    @IBOutlet var map: MKMapView!
    
    var locationManager = CLLocationManager()
    
    
    @IBAction func showSearchBar(sender: AnyObject) {
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        presentViewController(searchController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
        
        getLocationName()
    
      
//        self.search.delegate = self
        /* let lat: CLLocationDegrees = 37.422053
        let lon: CLLocationDegrees =  -122.084050
        
        let latDelta: CLLocationDegrees = 0.01
        let lonDelta: CLLocationDegrees = 0.01
        
        let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lon)
        
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        
        map.setRegion(region, animated: true)
        
        
        
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = location
        annotation.title = "GooglePlex"
        
        annotation.subtitle = "I will work here soon"
        
        map.addAnnotation(annotation)
        
        
        let uilpgr = UILongPressGestureRecognizer(target: self, action: "action:")
        
        uilpgr.minimumPressDuration = 2
        
        
        map.addGestureRecognizer(uilpgr)
        
        
        
        
        
        */
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        
        
        
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

        
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
        if self.map.annotations.count != 0{
            annotation = self.map.annotations[0]
            self.map.removeAnnotation(annotation)
        }
        //2
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearchRequest.region = map.region
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
            //3
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.map.centerCoordinate = self.pointAnnotation.coordinate
            self.map.addAnnotation(self.pinAnnotationView.annotation!)
            let annotation = MKPointAnnotation()
            annotation.title = "My house"
            annotation.subtitle = "My house is very serene!"
            annotation.coordinate = self.map.centerCoordinate
            self.map.addAnnotation(annotation)
            
        }
    }
    func getAddress() -> String {
//        print(V.address)
        return ViewController.address!
    }
    func getLocationName() {
        let geoCoder = CLGeocoder()
        
        guard let locValue = locationManager.location?.coordinate else {return}
        
        let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        
        geoCoder.reverseGeocodeLocation(location) {
            
            (placemarks, error) -> Void in
            
            if error != nil {
                print(error!.description)
            } else {
                let placeArray = placemarks
                
                // Place details
                var placeMark: CLPlacemark!
                placeMark = placeArray?[0]
                
                //                let streetNum = placeMark.subThoroughfare ?? ""
                let postCode = placeMark.postalCode ?? ""
                let state = placeMark.administrativeArea ?? ""
                //                 City
                if let city = placeMark.addressDictionary!["City"] as? String {
                    ViewController.address = city + " " + state + " " + postCode
//                    self.addressSSS = address
//                    print(self.addressSSS)
                    //                    if let street = placeMark.addressDictionary!["Thoroughfare"] as? String {
                    //
                    //                    }
                }
            }
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        var locationArray = locations as NSArray
        var locationObj = locationArray.lastObject as! CLLocation
        var coord = locationObj.coordinate
        let userLocation: CLLocation = locations[0]
        
        print("locationUpdated")
        //we have extracted the location we want
        let latitude = coord.latitude
        let longitude = coord.longitude
        
        
        let latDelta: CLLocationDegrees = 0.01
        
        let longDelta: CLLocationDegrees = 0.01
        
        //span is a combo of 2 deltas
        let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta,longDelta)
        
        //constructing the coordinates for latitude and longitude
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude,longitude )
        
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        map.setRegion(region, animated: true)
       
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = location
       
        
        map.addAnnotation(annotation)
        
        
        let uilpgr = UILongPressGestureRecognizer(target: self, action: "action:")
        
        uilpgr.minimumPressDuration = 2
        
        
        map.addGestureRecognizer(uilpgr)
        
        

        locationManager.stopUpdatingLocation()
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("works")
    }
  
    
    
    func action(gestureRecognizer: UIGestureRecognizer){
        let touchpoint = gestureRecognizer.locationInView(self.map)
        
        let newCoordinate: CLLocationCoordinate2D = map.convertPoint(touchpoint, toCoordinateFromView: self.map)
        
        
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = newCoordinate
        
                
        map.addAnnotation(annotation)
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

