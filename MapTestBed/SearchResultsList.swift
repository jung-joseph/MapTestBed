//
//  SearchResultsList.swift
//  POIRouter
//
//  Created by Joseph Jung on 9/9/22.
//

import SwiftUI
import MapKit

struct SearchResultsList: View {
    
    
    let landmarks: [LandmarkAnnotation]
    var onSelect: (LandmarkAnnotation) -> Void
    @EnvironmentObject var appState:AppState
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var localSearchService: LocalSearchService
    @StateObject private var locationManager = LocationManager()
    @Binding var showSearchResultsList: Bool
    
    var distanceFormatter = DistanceFormatter()
    
    init(landmarks: [LandmarkAnnotation],showSearchResultsList: Binding<Bool> ,onSelect: @escaping(LandmarkAnnotation)-> Void) {
        self.landmarks = landmarks
        self._showSearchResultsList = showSearchResultsList // Must use "_" to initialize!
        self.onSelect = onSelect
    }
    
    func formatDistance(for landmark: LandmarkAnnotation) -> String {
        //        print("location  \(locationManager.location)")
        guard let distanceInMeters = landmark.getDistance(userLocation: locationManager.location) else {return ""}
        distanceFormatter.unitOptions = userSettings.distanceUnit
        return distanceFormatter.format(distanceInMeters: distanceInMeters)
    }
    
    var body: some View {
        VStack{
            Text("Search Results")
                .font(.title)
                .padding([.top,.bottom])
            List(landmarks) { landmark in
                VStack(alignment: .leading) {
                    Text(landmark.title ?? "")
                        .frame(maxWidth: .infinity, alignment: .leading)
                 
                    Text(landmark.address ?? "")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(landmark.phone ?? "")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(formatDistance(for:landmark))
                        .font(.caption)
                        .opacity(0.4)
                }//VStack
                .listRowBackground(appState.selectedLandmark == landmark ? Color(UIColor.lightGray): Color.white)
                .contentShape(Rectangle())
                .onTapGesture {
                    onSelect(landmark)
                    withAnimation{
                        localSearchService.region = MKCoordinateRegion.regionFromLandmark(landmark)
                    }
                }
                
            }// List
        }
       
    }
        
}

struct SearchResultsList_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultsList(landmarks: [], showSearchResultsList: .constant(false) ,onSelect: {_ in })
    }
}
