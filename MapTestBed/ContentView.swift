//
//  ContentView.swift
//  MapTestBed
//
//  Created by Joseph Jung on 9/18/22.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
//    @EnvironmentObject var locationManager: LocationManager
    @State private var search: String = ""
    @State  private var showSearchResultsList = false

    @EnvironmentObject var searchVM: SearchResultsViewModel
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var userSettings: UserSettings

    var body: some View {
        ZStack {
            MapScreen()
            .ignoresSafeArea()
            
            VStack{
                Spacer()
                TextField("Search", text: $search)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit {
                        
                        DispatchQueue.main.async {
                            
                            searchVM.search(query: search) {   landmarks in
                                appState.landmarks = landmarks
                            }
                            
                        
                        }
                        
                            showSearchResultsList = true
                        
                    }.padding()
                    .sheet(isPresented: $showSearchResultsList) {
                        SearchResultsList(landmarks: appState.landmarks, showSearchResultsList: $showSearchResultsList) { landmark in
                            appState.selectedLandmark = landmark
                        }
                        .presentationDetents([.large, .medium, .fraction(0.75), .fraction(0.25)])
    
                    }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
