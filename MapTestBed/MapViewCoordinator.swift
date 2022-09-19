//
//  MapViewCoordinator.swift
//  MapTestBed
//
//  Created by Joseph Jung on 9/18/22.
//

import Foundation
import MapKit
import UIKit

final class MapViewCoordinator: NSObject, MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        mapView.setRegion(region, animated: true)
    }
    
}
