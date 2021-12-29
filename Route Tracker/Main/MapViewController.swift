//
//  MapViewController.swift
//  Route Tracker
//
//  Created by Анастасия Живаева on 24.11.2021.
//

import UIKit
import GoogleMaps
import CoreLocation
import RealmSwift

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    let locationManager = LocationManager.instance
    let geocoder = CLGeocoder()
    let startCoordinate = CLLocationCoordinate2D(latitude: 59.939095, longitude: 30.315868)
    var marker: GMSMarker?
    var selfyMarker: GMSMarker?
    var manualMarker: GMSMarker?
    var photo: UIImage?
    
    var route: GMSPolyline?
    var routePath: GMSMutablePath?
    var usselesExampleVariable = ""
    
    // MARK: - Actions
    @IBAction func selfy(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .camera
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    @IBAction func beginNewTrack(_ sender: Any) {
        route?.map = nil
        route = GMSPolyline()
        routePath = GMSMutablePath()
        route?.map = mapView
        locationManager.startUpdatingLocation()
        
    }
    @IBAction func endTrackButton(_ sender: Any) {
        endTrack()
    }
    
    @IBAction func showPreviousRoute(_ sender: UIButton) {
        if (routePath?.count())! > 0 {
            let alert = UIAlertController(title: "Внимание!", message: "Необходимо остановить слежение", preferredStyle: UIAlertController.Style.alert)
            let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { action in
                self.endTrack()
                self.loadPreviousRoute()
            }
            alert.addAction(alertAction)
            present(alert, animated: true)
        } else {
            loadPreviousRoute()
        }
        
    }
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.locationManager.delegate = self
        configureMap(coordinate: startCoordinate)
        addMarker(coordinate: startCoordinate)
        configureLocationManager()
    }
    // MARK: - ConfigureMap
    func configureLocationManager() {
        locationManager
            .location
            .asObservable()
            .bind { [weak self] location in
                guard let location = location else { return }
                self?.routePath?.add(location.coordinate)
                self?.route?.path = self?.routePath
                let position = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 17)
                self?.mapView.animate(to: position)
            }
    }
    
    func configureMap(coordinate: CLLocationCoordinate2D) {
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 17)
        mapView.camera = camera
        mapView.delegate = self
    }
    // MARK: - ConfigureMarker
    func addMarker(coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: coordinate)
        marker.map = mapView
        self.marker = marker
    }
    
    func addMarkerSelfy(coordinate: CLLocationCoordinate2D) {
        let selfyMarker = GMSMarker(position: coordinate)
        
        let iconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        iconView.image = photo
        selfyMarker.iconView = iconView
        UIImageWriteToSavedPhotosAlbum(photo!, self, nil, nil)
        self.photo = nil
        
        selfyMarker.map = mapView
        self.selfyMarker = selfyMarker
    }
    
    func removeMarker() {
        marker?.map = nil
        marker = nil
    }
    // MARK: - RouteProcessing
    func saveTrackCoordinate(coordinate: Coordinate) {
        do {
            let realm = try Realm()
            print(realm.configuration.fileURL as Any)
           
            let oldTrackCoordinate = realm.objects(Coordinate.self)
            realm.beginWrite()
            realm.delete(oldTrackCoordinate)

            realm.add(coordinate)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    func endTrack() {
        locationManager.stopUpdatingLocation()
        let encodedPath = routePath?.encodedPath() ?? ""
        let trackCoordinate: Coordinate = Coordinate()
        trackCoordinate.coordinate = encodedPath
        saveTrackCoordinate(coordinate: trackCoordinate)
        routePath?.removeAllCoordinates()
    }
    
    func loadPreviousRoute() {
        do {
            let realm = try Realm()
            let trackCoordinate = realm.objects(Coordinate.self)
            routePath = GMSMutablePath(fromEncodedPath: trackCoordinate.first?.coordinate ?? "")
            route?.path = routePath
            let position = GMSCameraUpdate.fit(GMSCoordinateBounds(path: routePath!))
            mapView.animate(with: position)
        } catch {
            print(error)
        }
    }
}

// MARK: - GMSMapViewDelegate
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

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.location.accept(locations.last)
        
        guard let location = locations.last else { return }
        geocoder.reverseGeocodeLocation(location) { places, error in
            let updateCoordinate = location.coordinate
            self.configureMap(coordinate: updateCoordinate)
            self.removeMarker()
            self.addMarker(coordinate: updateCoordinate)
            
            if self.photo != nil {
                self.addMarkerSelfy(coordinate: updateCoordinate)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension MapViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = extractImage(from: info) else { return }
        photo = image
        picker.dismiss(animated: true)
    }

    private func extractImage(from info: [UIImagePickerController.InfoKey: Any]) -> UIImage? {
        if let image = info[.editedImage] as? UIImage {
            return image
        } else {
            if let image = info[.originalImage] as?
                    UIImage {
                return image
            } else {
                return nil
            }
        }
    }
    
}
