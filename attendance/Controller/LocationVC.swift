//
//  LocationVC.swift
//  attendance
//
//  Created by TechCenter on 25/05/22.
//

import UIKit
import MapKit
import CoreLocation

class LocationVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mMapView: MKMapView!
    var locationManager:CLLocationManager!
    var currentLocationStr = "Current location"
    var latitude = "",longitude = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let buttonItem = MKUserTrackingBarButtonItem(mapView: mMapView)
        self.navigationItem.rightBarButtonItem = buttonItem

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        determineCurrentLocation()
    }


    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:- CLLocationManagerDelegate Methods

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if latitude == ""
        {
            let mUserLocation:CLLocation = locations[0] as CLLocation
            let center = CLLocationCoordinate2D(latitude: mUserLocation.coordinate.latitude, longitude: mUserLocation.coordinate.longitude)
            let mRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mMapView.setRegion(mRegion, animated: true)
            self.mMapView.showsUserLocation = true

        // Get user's Current Location and Drop a pin
        let mkAnnotation: MKPointAnnotation = MKPointAnnotation()
            mkAnnotation.coordinate = CLLocationCoordinate2DMake(mUserLocation.coordinate.latitude, mUserLocation.coordinate.longitude)
            mkAnnotation.title = self.setUsersClosestLocation(mLattitude: mUserLocation.coordinate.latitude, mLongitude: mUserLocation.coordinate.longitude)
            mMapView.addAnnotation(mkAnnotation)
        }
        else
        {
            let center = CLLocationCoordinate2D(latitude: Double(latitude)!, longitude: Double(longitude)!)
            let mRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mMapView.setRegion(mRegion, animated: true)
            self.mMapView.showsUserLocation = true

            // Get user's Current Location and Drop a pin
            let mkAnnotation: MKPointAnnotation = MKPointAnnotation()
            mkAnnotation.coordinate = CLLocationCoordinate2DMake(Double(latitude)!, Double(longitude)!)
            mkAnnotation.title = self.setUsersClosestLocation(mLattitude:Double(latitude)!, mLongitude:  Double(longitude)!)
            mMapView.addAnnotation(mkAnnotation)
        }
    }
    //MARK:- Intance Methods

    func setUsersClosestLocation(mLattitude: CLLocationDegrees, mLongitude: CLLocationDegrees) -> String {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: mLattitude, longitude: mLongitude)

        geoCoder.reverseGeocodeLocation(location) {
            (placemarks, error) -> Void in

            if let mPlacemark = placemarks{
                if let dict = mPlacemark[0].addressDictionary as? [String: Any]{
                    if let Name = dict["Name"] as? String{
                        if let City = dict["City"] as? String{
                            self.currentLocationStr = Name + ", " + City
                        }
                    }
                }
            }
        }
        return currentLocationStr
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Error - locationManager: \(error.localizedDescription)")
        }

    //MARK:- Intance Methods

    func determineCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()

//        if longitude == ""
//        {

        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
//        }
//        else
//        {
//            let oahuCenter = CLLocation(latitude:Double(latitude)!, longitude: Double(longitude)!)
//               let region = MKCoordinateRegion(
//                 center: oahuCenter.coordinate,
//                 latitudinalMeters: 50000,
//                 longitudinalMeters: 60000)
//            mMapView.setCameraBoundary(
//                 MKMapView.CameraBoundary(coordinateRegion: region),
//                 animated: true)
//
//               let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200000)
//            mMapView.setCameraZoomRange(zoomRange, animated: true)
//
//        }
    }

}
