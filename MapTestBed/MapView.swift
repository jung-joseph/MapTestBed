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

    init(annotations: [LandmarkAnnotation], selectedLandmark: LandmarkAnnotation?) {
        self.annotations = annotations
        self.selectedLandmark = selectedLandmark
    }
    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.showsUserLocation = true
        map.delegate = context.coordinator
        map.mapType = .hybrid
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
    
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
    }
}
