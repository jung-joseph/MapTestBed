//
//  Landmark.swift
//  SwiftUIMap
//
//  Created by Joseph Jung on 7/31/22.
//

import Foundation
import MapKit
import Contacts

struct Landmark: Identifiable, Hashable {
    
    let placemark: MKPlacemark
    
    let id = UUID()
    
    var title: String {
        self.placemark.title ?? ""
    }
    
    var subtitle: String {
        
        self.placemark.subtitle ?? "subtitle"
    }
    var name: String {
        self.placemark.name ?? ""
    }
    
    var address: String {
        guard let postalAddress = self.placemark.postalAddress else {
            return ""
        }
        return "\(postalAddress.street), \(postalAddress.city), \(postalAddress.state), \(postalAddress.postalCode)"
    }

    var location: CLLocation? {
        return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }

    var coordinate: CLLocationCoordinate2D {
        self.placemark.coordinate
    }
    
    var city: String {
        self.placemark.locality ?? ""
    }
    
    func getDistance(userLocation: CLLocation?) -> Double? {
        

        guard let placeLocation = placemark.location,
              let userLocation = userLocation else {
                return nil
        }
        
        return userLocation.distance(from: placeLocation)
    }
}
