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

            Spacer()
            Spacer()
            TextField("Search Map", text: $search)
                .textFieldStyle(.roundedBorder)
                .padding([.leading,.trailing],25)
                .onSubmit {
//                    DispatchQueue.main.async {
                        searchVM.search(query: search) {   landmarks in
                            appState.landmarks = landmarks
                        }
//                    }
                        showSearchResultsList = true
                }
            
            VStack{
                HStack{
                    Button("Clear"){
                        search = ""
                        appState.destinationLandmarks.removeAll()
                        appState.categoryOfInterest = ""
                        appState.landmarks.removeAll()
//                        showSearchResultsList.toggle()
                    }
                    .onSubmit {
//                        DispatchQueue.main.async {
//                            searchVM.search(query: search) {   landmarks in
//                                appState.landmarks = landmarks
//                            }
//                        }
//                        showSearchResultsList = true
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    .shadow(radius: 10)
                    
                    Button("Set Category of Interest"){
                        appState.categoryOfInterest = search
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    .shadow(radius: 10)
                    
                }
                .padding()
                
                ScrollView(.horizontal){
                    HStack{
                        Button("Dog Parks", action:
                        {
                            search = "Dog Parks"
                            appState.categoryOfInterest = "Dog Parks"
                            searchVM.search(query: search) {   landmarks in
                                appState.landmarks = landmarks
                            }
                            showSearchResultsList = true

                        })
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                        .shadow(radius: 10)
                        
                        Button("EV Chargers", action:
                        {
                            search = "EV Chargers"
                            appState.categoryOfInterest = "EV Chargers"
                            searchVM.search(query: search) {   landmarks in
                                appState.landmarks = landmarks
                            }
                            showSearchResultsList = true
                        })
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                        .shadow(radius: 10)
                        
                        Button("Historical Sites", action:
                        {
                            search = "Historical Sites"
                            appState.categoryOfInterest = "Historical Sites"
                            searchVM.search(query: search) {   landmarks in
                                appState.landmarks = landmarks
                            }
                            showSearchResultsList = true
                        })
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                        .shadow(radius: 10)
                        
                        Button("Coffee", action:
                        {
                            search = "Coffee"
                            appState.categoryOfInterest = "Coffee"
                            searchVM.search(query: search) {   landmarks in
                                appState.landmarks = landmarks
                            }
                            showSearchResultsList = true
                        })
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                        .shadow(radius: 10)
                        
                        
                        
                        Button("Rest Areas", action:
                        {
                            search = "Rest Areas"
                            appState.categoryOfInterest = "Rest Areas"
                            searchVM.search(query: search) {   landmarks in
                                appState.landmarks = landmarks
                            }
                            showSearchResultsList = true
                        })
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                        .shadow(radius: 10)
                        

                    }
                }
                .padding(.top, 0)
                
               
                VStack(alignment: .leading){
//                    Text("End Destination: \(appState.destinationLandmarks[appState.destinationLandmarks.count - 1]?.title ?? "")")
//                        Text("Interim Destination: \(appState.destinationLandmarks[appState.destinationLandmarks.count - 2]?.title ?? "")")
//                        Text("Interim Search Category: \(appState.categoryOfInterest ?? "")")
                    }
                
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
