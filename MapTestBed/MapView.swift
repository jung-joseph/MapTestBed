//
//  MapView.swift
//  MapTestBed
//
//  Created by Joseph Jung on 9/18/22.
//

import Foundation
import MapKit
import SwiftUI
import UIKit


struct MapView: UIViewRepresentable {
    typealias UIViewType = MKMapView
    

   
    
//    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 39.16444, longitude: -106.5117), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    
    init() {
  
        
}
    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView( )
        map.showsUserLocation = true
        map.delegate = context.coordinator
        map.mapType = .hybrid
        
        
        return map
    }
    
    func updateUIView(_ map: MKMapView, context: Context) {
        
 
    }
    
    private func registerMapAnnotations(map: MKMapView) {


        
    }
    
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
    }
    
    
}
