//
//  Settings.swift
//  POIRouter
//
//  Created by Joseph Jung on 9/8/22.
//

import Foundation
import SwiftUI
import MapKit

class Settings: ObservableObject {
    
    @Published var isDarkMode: Bool = false
    @Published var distanceUnit: DistanceUnit = .miles
    @Published var mapType: MKMapType = .standard
    @Published var transportationType: MKDirectionsTransportType = .automobile //.walking; .transit
//    @Published var selectedMapTypeString: String = ".standard"


    
}
