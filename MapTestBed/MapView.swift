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
    
    private var annotations: [LandmarkAnnotation] = []
    private var selectedLandmark: LandmarkAnnotation?
    
   
    
//    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 39.16444, longitude: -106.5117), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    
    init(annotations: [LandmarkAnnotation], selectedLandmark: LandmarkAnnotation?) {
        self.annotations = annotations
        self.selectedLandmark = selectedLandmark
        
}
    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView( )
        map.showsUserLocation = true
        map.delegate = context.coordinator
        map.mapType = .hybrid
        
        
        return map
    }
    
    func updateUIView(_ map: MKMapView, context: Context) {
        
        map.removeAnnotations(map.annotations)
        
        registerMapAnnotations(map:map)
        map.addAnnotations(annotations)
        
        if let selectedLandmark = selectedLandmark {
            map.selectAnnotation(selectedLandmark, animated: true)
        }
    }
    
    private func registerMapAnnotations(map: MKMapView) {
        print("registering  \(annotations.count) annotations")
        
        for annotation in annotations {
            map.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: annotation.title ?? "")
        }

        
    }
    
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
    }
    
    
}
