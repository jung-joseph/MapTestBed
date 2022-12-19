//
//  LocationManager.swift
//  SwiftUIMap
//
//  Created by Joseph Jung on 7/31/22.
//

import Foundation
import CoreLocation
import MapKit
import SwiftUI
import AVFoundation

class LocationManager: NSObject, ObservableObject {
    
    @Published var locationManager = CLLocationManager()
    
    //    let locationManager = CLLocationManager()
    //    @Published var region = MKCoordinateRegion.defaultRegion()
    @Published var region = MKCoordinateRegion()
    @Published var location: CLLocation?
    @Published var enteringRegion: String = "0"
    @Published var exitingRegion: String = "0"
    
    
    var speechsynthesizer = AVSpeechSynthesizer()

    
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
//        print("enteringRegion: \(enteringRegion)")
//        let intRegion = Int(enteringRegion) != nil ? Int(enteringRegion) : 0
//        speakNextInstruction(step: appState.routeSteps[intRegion!])
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("locationManager_didExitRegion called")
        if let region = region as? CLCircularRegion {
            let identifier = region.identifier
            exitingRegion = identifier
        }
//        let intRegion = Int(exitingRegion) != nil ? Int(exitingRegion) : 0
//        speakNextInstruction(step: appState.routeSteps[intRegion!])
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
    func speakNextInstruction(step: RouteStep){
//        var speechsynthesizer = AVSpeechSynthesizer()

        let message = "In \(step.distance ?? "0") \(step.instructions ?? "0")"
        let speechUtterance = AVSpeechUtterance(string: message)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        speechsynthesizer.speak(AVSpeechUtterance(string: message))
    }
}

