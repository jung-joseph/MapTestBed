//
//  AppState.swift
//  POIRouter
//
//  Created by Joseph Jung on 9/8/22.
//

import Foundation


class AppState: ObservableObject {
    @Published var landmarks: [LandmarkAnnotation] = []
    @Published var selectedLandmark: LandmarkAnnotation?
    
    
}
