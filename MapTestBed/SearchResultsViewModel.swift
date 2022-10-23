//
//  SearchResultsViewModel.swift
//  POIRouter
//
//  Created by Joseph Jung on 9/8/22.
//

import Foundation
import MapKit
import SwiftUI

class SearchResultsViewModel: ObservableObject {
    
    
    private var locationManager = LocationManager()
    @Published var landmarkAnnotations: [LandmarkAnnotation] = []
    @Published var landmarkAnnotation: LandmarkAnnotation?
    
    
    init(){
        print("SearchResultsViewModel Created")
    }
    
    func search(query: String, completion: @escaping ([LandmarkAnnotation]) -> Void) {


        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = query
        searchRequest.region = locationManager.region
        
        let search = MKLocalSearch(request: searchRequest)
        
        
        DispatchQueue.main.async {
//            Log.location(fileName: #file)
//            Log.queue(action: "in search")
            
            search.start { response, error in
                
                print("search started!")
                
                guard let response = response, error == nil else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                    completion([])
                    return
                }
                

                let mapItems = response.mapItems
                
                
                self.landmarkAnnotations = mapItems.map {
                    LandmarkAnnotation(mapItem: $0)
                }
                completion(self.landmarkAnnotations)

                
                print("vmLandMarkAnnotiations")
                print("landmarkAnnotations count \(self.landmarkAnnotations.count)")
                for i in 0...self.landmarkAnnotations.count-1 {
                    print(self.landmarkAnnotations[i].mapItem.name as Any)
                }
            }
            
            
            
            
        }
        
    }
}



