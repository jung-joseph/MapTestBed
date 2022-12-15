//
//  LocationManager.swift
//  SwiftUIMap
//
//  Created by Joseph Jung on 7/31/22.
//

import Foundation
import CoreLocation
import MapKit

class LocationManager: NSObject, ObservableObject {
    
    @Published var locationManager = CLLocationManager()
    
    //    let locationManager = CLLocationManager()
    //    @Published var region = MKCoordinateRegion.defaultRegion()
    @Published var region = MKCoordinateRegion()
    @Published var location: CLLocation?
    @Published var enteringRegion: String?
    @Published var exitingRegion: String?
    
    
    
    override init() {
        super.init()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        //        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    private func checkAuthorization() {
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Your location is restricted.")
        case .denied:
            print("Access location services denied.")
        case .authorizedAlways, .authorizedWhenInUse:
            guard let location = locationManager.location else {return}
            region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25))
        @unknown default:
            break
        }
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("locationManager_didEnterRegion called")
        if let region = region as? CLCircularRegion {
            let identifier = region.identifier
            enteringRegion = identifier
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("locationManager_didExitRegion called")
        if let region = region as? CLCircularRegion {
            let identifier = region.identifier
            exitingRegion = identifier
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
//        print("in didUpdateLocation")
        
        guard let location = locations.first else {
            print(" did not unWrap location")
            
            return
            
        }
//        print("Getting location and setting region")
        DispatchQueue.main.async { [weak self] in
            self?.location = location
            self?.region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25))
//            print("Location from locationManager")
//            print("lat: \(location.coordinate.latitude)")
//            print("lon: \(location.coordinate.longitude)")
            
        }
    }
}

