//
//  AppState.swift
//  POIRouter
//
//  Created by Joseph Jung on 9/8/22.
//

import Foundation
import MapKit
import SwiftUI

class AppState: ObservableObject {
    @Published var landmarks: [LandmarkAnnotation] = []
    @Published var selectedLandmark: LandmarkAnnotation?
    @Published var route: MKRoute?
    @Published var routeSteps: [RouteStep] = []
    @Published var routes: [MKRoute?] = []
    @Published var travelTime: [TimeInterval?] = []
    @Published var destinationLandmarks: [LandmarkAnnotation?] = []

    @Published var categoryOfInterest: String?
    @Published var startLocation: LandmarkAnnotation?
    @Published var startLocationType: String = "currentLocation"

    @Published var homeLocation: LandmarkAnnotation? 
    @Published var selectedStartLocation: LandmarkAnnotation?

    @Published var map = MKMapView()
    
 

    
        

    }



struct RouteStep: Hashable {
    var id = UUID()
    var imageName: String?
    var instructions: String?
    var distance: String?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
