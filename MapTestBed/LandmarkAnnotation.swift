//
//  LandmarkAnnotation.swift
//  POIRouter
//
//  Created by Joseph Jung on 9/8/22.
//

//import Foundation
import MapKit

class LandmarkAnnotation: NSObject, MKAnnotation, Identifiable, ObservableObject {
    
    let id = UUID()
//    private var mapItem: MKMapItem
     var mapItem: MKMapItem

    init(mapItem: MKMapItem) {
        self.mapItem = mapItem
    }
    
    var title: String? {
        mapItem.name
    }

    
    var phone: String? {
        mapItem.phoneNumber ?? ""
    }
    
    var address: String? {
        guard let postalAddress = mapItem.placemark.postalAddress else {
            return ""
        }
        return "\(postalAddress.street), \(postalAddress.city), \(postalAddress.state), \(postalAddress.postalCode)"
    }
    
    var location: CLLocation? {
        
        return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    var coordinate: CLLocationCoordinate2D {
        mapItem.placemark.coordinate
    }
    
    var city: String {
        mapItem.placemark.locality ?? ""
    }
    
    func getDistance(userLocation: CLLocation?) -> Double? {
        

        guard let placeLocation = mapItem.placemark.location,
              let userLocation = userLocation else {
                return nil
        }
        
        return userLocation.distance(from: placeLocation)
    }
}
