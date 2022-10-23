//
//  LocalSearchService.swift
//  SwiftUIMap
//
//  Created by Joseph Jung on 7/31/22.
//

import Foundation
import MapKit
import Combine

class LocalSearchService: ObservableObject {
    
    @Published var region: MKCoordinateRegion = MKCoordinateRegion.defaultRegion()
    let locationManager = LocationManager()
    var cancellables = Set<AnyCancellable>()
    @Published var landmarks: [Landmark] = []
    @Published var landmark: Landmark?
    
    init() {
        locationManager.$region.assign(to: \.region, on: self)
            .store(in: &cancellables)
    }
    
    func search(query: String, completion: @escaping ([LandmarkAnnotation]) -> Void) {
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = locationManager.region
        
        let search = MKLocalSearch(request: request)
        
        search.start { response, error in
            
            guard let response = response, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                
                return
            }
            
//                let mapItems = response.mapItems
//                self.landmarks = mapItems.map {
//                    Landmark(placemark: $0.placemark)
            let landmarks = response.mapItems.map(LandmarkAnnotation.init)
            completion(landmarks)
            
            
        }
        
    }
}
