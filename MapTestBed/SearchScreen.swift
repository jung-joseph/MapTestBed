//
//  SearchScreen.swift
//  MapTestBed
//
//  Created by Joseph Jung on 10/27/22.
//

import SwiftUI

struct SearchScreen: View {
    
    @State private var search: String = ""
    @State  private var showSearchResultsList = false
    @Binding var selectedTab: String
    @EnvironmentObject var searchVM: SearchResultsViewModel
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var settings: Settings
    
    var body: some View {
        VStack{
            TextField("Search", text: $search)
                .textFieldStyle(.roundedBorder)
                .onSubmit {
                    DispatchQueue.main.async {
                        searchVM.search(query: search) {   landmarks in
                            appState.landmarks = landmarks
                        }
                    }
                        showSearchResultsList = true
                }
            
            SearchResultsList(landmarks: appState.landmarks, showSearchResultsList: $showSearchResultsList, selectedTab: $selectedTab) { landmark in
                appState.selectedLandmark = landmark
            }
        }
    }
}

struct SearchScreen_Previews: PreviewProvider {
    static var previews: some View {
        SearchScreen(selectedTab: .constant("Search"))
    }
}
