//
//  LoginMapViewController.swift
//  UG Customer
//
//  Created by Amit Sen on 3/8/18.
//  Copyright © 2018 Amit Sen. All rights reserved.
//

import UIKit

class LoginMapViewController: BaseViewController {
    // IBOutlets
    /*
    // public variables
    let viewModel = LoginMapViewModel.init()
    
    // private variables
    private var mapView: GMSMapView!
    private var locationManager = CLLocationManager()
    private var currentLocation: CLLocation!
    private var distanceFilterDimension: CLLocationDistance = 50
    private var defaultLocation = CLLocation(latitude: 24.68773, longitude: 46.72185)
    
    //Overridden Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setViews()
        setLocationParams()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // IBActions
    
    // public methods
    
    // private methods
    private func setViews() {
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: viewModel.zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        
        // Add the map to the view, hide it until we've got a location update.
        view.addSubview(mapView)
        mapView.isHidden = true
    }
    
    private func setLocationParams() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = distanceFilterDimension
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    private func setMarker(atLocation location: CLLocation) {
        let marker = GMSMarker()
        marker.icon = GMSMarker.markerImage(with: viewModel.colors.red_marker)
        marker.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                 longitude: location.coordinate.longitude)
        marker.map = mapView
    }
    
    // delegates
    // CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        mapView.clear()
        currentLocation = CLLocation(latitude: (locations.last?.coordinate.latitude)!,
                                     longitude: (locations.last?.coordinate.longitude)!)
        print("Location: \(currentLocation)")
        
        let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude,
                                              longitude: currentLocation.coordinate.longitude,
                                              zoom: viewModel.zoomLevel)
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
        
        setMarker(atLocation: currentLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways:
            print("Location status is OK.")
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
 */
}
