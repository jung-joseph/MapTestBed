//
//  SearchResultsList.swift
//  POIRouter
//
//  Created by Joseph Jung on 9/9/22.
//

import SwiftUI
import MapKit

struct SearchResultsListView: View {
    
    
    let landmarks: [LandmarkAnnotation]
    var onSelect: (LandmarkAnnotation) -> Void
    @EnvironmentObject var appState:AppState
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var localSearchService: LocalSearchService
    @StateObject private var locationManager = LocationManager()
    @Binding var showSearchView: Bool
    @Binding var selectedTab: String
 

    
    var distanceFormatter = DistanceFormatter()
    
    init(landmarks: [LandmarkAnnotation],showSearchView: Binding<Bool> , selectedTab: Binding<String>, onSelect: @escaping(LandmarkAnnotation)-> Void) {
        self.landmarks = landmarks
        self._showSearchView = showSearchView // Must use "_" to initialize!

        self._selectedTab = selectedTab
        self.onSelect = onSelect
        print("******Landmark selected from list*****")
        print("selectedTab: \(selectedTab)")
    }
    
    func formatDistance(for landmark: LandmarkAnnotation) -> String {
        //        print("location  \(locationManager.location)")
        guard let distanceInMeters = landmark.getDistance(userLocation: locationManager.location) else {return ""}
        distanceFormatter.unitOptions = settings.distanceUnit
        return distanceFormatter.format(distanceInMeters: distanceInMeters)
    }
    
    var body: some View {
        VStack{
            Text(!landmarks.isEmpty ? "Search Results" : "")
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
                .onSubmit {
                    print("SearchResultsList onSubmit fired")

                }
                .onTapGesture {
                    print("SearchResultsList onTapGesture fired")
                    onSelect(landmark)
                    
                    withAnimation{
                        localSearchService.region = MKCoordinateRegion.regionFromLandmark(landmark)
                    }
                    selectedTab = "Map"
//                    Remove search list after an annotation is selected
                    self.showSearchView = false
                }
                
            }// List
            
        }
       
    }
        
}


struct SearchResultsListView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultsListView(landmarks: [], showSearchView: .constant(false) , selectedTab: .constant("Search"),onSelect: {_ in })
    }
    
    
}
