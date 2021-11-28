//
//  MapViewController.swift
//  Route Tracker
//
//  Created by Анастасия Живаева on 24.11.2021.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    var locationManager: CLLocationManager?
    let geocoder = CLGeocoder()
    let startCoordinate = CLLocationCoordinate2D(latitude: 59.939095, longitude: 30.315868)
    var marker: GMSMarker?
    var manualMarker: GMSMarker?
    
    @IBAction func updateLocation(_ sender: Any) {
        locationManager?.startUpdatingLocation()
    }
    @IBAction func currentLocation(_ sender: Any) {
        locationManager?.delegate = self
        locationManager?.requestLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap(coordinate: startCoordinate)
        addMarker(coordinate: startCoordinate)
        configureLocationManager()
    }
    
    func configureMap(coordinate: CLLocationCoordinate2D) {
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 17)
        mapView.camera = camera
        mapView.delegate = self
    }
    
    func addMarker(coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: coordinate)
        marker.map = mapView
        self.marker = marker
    }
    
    func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
    }
}

extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if let manualMarker = manualMarker {
            manualMarker.position = coordinate
        } else {
            let marker = GMSMarker(position: coordinate)
            marker.map = mapView
            self.manualMarker = marker
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        geocoder.reverseGeocodeLocation(location) { places, error in
            let updateCoordinate = location.coordinate
            self.configureMap(coordinate: updateCoordinate)
            self.addMarker(coordinate: updateCoordinate)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
