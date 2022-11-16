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
import CoreLocation


struct MapView {
//    typealias UIViewType = MKMapView
    
//    let map = MKMapView( )
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var settings: Settings
    
    private var annotations: [LandmarkAnnotation] = []
    private var selectedLandmark: LandmarkAnnotation?
    
    
    //    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 39.16444, longitude: -106.5117), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    
    init(annotations: [LandmarkAnnotation], selectedLandmark: LandmarkAnnotation?) {
        self.annotations = annotations
        self.selectedLandmark = selectedLandmark

    }
    
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
    }
}

extension MapView: UIViewRepresentable {
    typealias UIViewType = MKMapView

    func makeUIView(context: Context) -> MKMapView {
//        let map = MKMapView( )
        

        appState.map.showsUserLocation = true
        appState.map.showsTraffic = true
        appState.map.delegate = context.coordinator
        appState.map.mapType = .standard

       
//        map.mapType = .standard

        return appState.map
    }
    

    
    func updateUIView(_ map: MKMapView, context: Context) {
        
        print("updateUIView called")
        map.mapType = settings.mapType

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
    
    
    
    
}


