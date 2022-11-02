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
    @Published var endDestination: LandmarkAnnotation?
    @Published var interimDestination: LandmarkAnnotation?
    @Published var categoryOfInterest: String?

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
