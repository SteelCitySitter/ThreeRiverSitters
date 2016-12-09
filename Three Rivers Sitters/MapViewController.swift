//
//  ViewController.swift
//  MapView with custom annotation to book closest babysitter near
//  a patent
//
//  Created by Vikesh Inbasekharan on 11/10/16.
//  Copyright © 2015-2016 ThreeRiverSitter LLC. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase
class MapViewController: UIViewController,CLLocationManagerDelegate {
    
    //@IBOutlet weak var requestBooking: UIButton!
    @IBOutlet weak var centerPosition: UIButton!
    var ref: FIRDatabaseReference! = nil
    @IBOutlet weak var mapView: MKMapView!
    var resultsID: String!
    var manager: CLLocationManager!
    
    @IBAction func locationCenter(_ sender: Any) {
        mapView.zoomToUserLocation()
    }
    //---> calls custom annotations for all the babysitters locations on the map
    override func viewDidLoad() {
        super.viewDidLoad()
        //---> Setting CLLlocation manager
        manager = CLLocationManager()
        manager?.delegate = self
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        // checking for permissions
        self.checkCLLocationPermission()
        self.centerPosition.layer.cornerRadius = centerPosition.frame.size.width / 2
        // Instantiating Firebase database
        self.ref =  FIRDatabase.database().reference(fromURL: "https://three-rivers-sitters.firebaseio.com/")
        // Retreiving all the online babysitter's position
        self.ref.child("OnlineCareGivers-Bearings").observeSingleEvent(of: .value, with: { (snapshot) in
            for result in (snapshot.value as? NSDictionary)! {
                
                self.ref.child("OnlineCareGivers-Bearings").child(result.key as! String).observeSingleEvent(of: .value, with: {(snap) in
                    
                    self.resultsID = result.key as! String
                    
                    self.ref.child("caregivers").child(result.key as! String).observeSingleEvent(of: .value, with: {snaPS in
                        self.resultsID = result.key as! String
                        let babysitterLocationIndices = snap.value as? NSDictionary
                        let babysitterLatitude = babysitterLocationIndices?["Latitude"] as! Double
                        let babysitterLongitude = babysitterLocationIndices?["Longitude"] as! Double
                        let pinLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(babysitterLatitude,babysitterLongitude)
                        self.addAnnotation(for: pinLocation ,IdentityString: self.resultsID)
                        
                    })
                })
            }//for result --->
            
        })
    }
    // ---> function for creating custom annotations by retreiving other user information
    func addAnnotation(for coordinate: CLLocationCoordinate2D , IdentityString: String) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.ref =  FIRDatabase.database().reference(fromURL: "https://three-rivers-sitters.firebaseio.com/")
        
        self.ref.child("caregivers").child(IdentityString).observeSingleEvent(of: .value, with: {snaPS in
            print("resultinannotation:\(self.resultsID)")
            let BabySitterDetails = snaPS.value as? NSDictionary
            let fname = BabySitterDetails?["firstName"] as! String
            
            let lname = BabySitterDetails?["lastName"] as! String
            //    let rating = BabySitterDetails?["rating"] as! Int
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = "\(fname) \(lname)"
            annotation.subtitle = "Babysitter"
            self.mapView.addAnnotation(annotation)
            
        })
        
    }
    // ---> function to check for using location permission
    func checkCLLocationPermission(){
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            manager.startUpdatingLocation()
        }else if CLLocationManager.authorizationStatus() == .notDetermined{
            manager.requestWhenInUseAuthorization()
        }else if CLLocationManager.authorizationStatus() == .restricted{
            let alert = UIAlertController(title: "App requires GPS to function", message: "Turn on location feature on your phone", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    // ----> location manager function to get current user location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        let location = locations[0] as CLLocation
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, completionHandler: {(data, error) -> Void in
            
            self.mapView.centerCoordinate = location.coordinate
            let coord = location.coordinate
            print("Latitude:\(coord.latitude)")
            print("Latitude:\(coord.longitude)")
            let reg = MKCoordinateRegionMakeWithDistance(location.coordinate, 1000, 1000)
            self.mapView.setRegion(reg, animated: true)
            self.mapView.showsUserLocation = true
            
        })
    }
    
    
}
// ----> zoom to current user loaction
extension MKMapView {
    func zoomToUserLocation() {
        guard let coordinate = userLocation.location?.coordinate else { return }
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 10000, 10000)
        setRegion(region, animated: true)
    }
}
// ----> MKMapView Delegate to override built in annotation

extension MapViewController: MKMapViewDelegate {
    
    //-----> show custom annotation view
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        let customAnnotationViewIdentifier = "MyAnnotation"
        
        var pin = mapView.dequeueReusableAnnotationView(withIdentifier: customAnnotationViewIdentifier)
        if pin == nil {
            pin = CustomAnnotationView(annotation: annotation, reuseIdentifier: customAnnotationViewIdentifier)
        } else {
            pin?.annotation = annotation
        }
        return pin
    }
    
}

