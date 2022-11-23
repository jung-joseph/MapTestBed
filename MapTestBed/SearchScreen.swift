//
//  SearchScreen.swift
//  MapTestBed
//
//  Created by Joseph Jung on 10/27/22.
//

import SwiftUI

struct SearchScreen: View {
    
    @State private var search: String = ""
    @State private var selectedCategory: String = ""
    @Binding var selectedTab: String
    @Binding var showSearchView:Bool

    @EnvironmentObject var searchVM: SearchResultsViewModel
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var settings: Settings
    

    
    var body: some View {
        VStack{

            Spacer()
            Spacer()
            TextField("Search Map" , text: $search)

                .textFieldStyle(.roundedBorder)
                .padding([.leading,.trailing],25)
                .onSubmit {
//                    DispatchQueue.main.async {
                        searchVM.search(query: search) {   landmarks in
                            appState.landmarks = landmarks
                        }
//                    }
                        showSearchView = true
                }
                .onAppear{
                    search = appState.categoryOfInterest ?? ""
                }
            
            VStack{
//                ScrollView(.horizontal){
                    HStack{
//MARK: - CLEAR ALL
                        Button("Clear All"){
                            search = ""
                            appState.destinationLandmarks.removeAll()
                            appState.categoryOfInterest = ""
                            appState.landmarks.removeAll()
                            appState.map.removeOverlays(appState.map.overlays)
                            appState.routeSteps.removeAll()
                            appState.startLocation = nil
                            selectedCategory = "Clear All"
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .background(selectedCategory == "Clear All" ? Color(#colorLiteral(red: 0.4982050061, green: 0.5490344763, blue: 0.5528618097, alpha: 1)) : Color(#colorLiteral(red: 0.9254772663, green: 0.9412199855, blue: 0.9449794888, alpha: 1)))
                        .foregroundColor(selectedCategory == "Clear All" ? Color.white: Color(#colorLiteral(red: 0.204610765, green: 0.2861392498, blue: 0.3685011268, alpha: 1)))
                        .clipShape(RoundedRectangle(cornerRadius: 16.0, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))

                        
//MARK: - SET AS SEARCH CATEGORY

                        Button("Set as Search Category"){
                            appState.categoryOfInterest = search
                            search = appState.categoryOfInterest ?? ""
                            //                    DispatchQueue.main.async {
                                                    searchVM.search(query: search) {   landmarks in
                                                        appState.landmarks = landmarks
                                                    }
                            //                    }
                                                    showSearchView = true
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .background(selectedCategory == "Set as Search Category" ? Color(#colorLiteral(red: 0.4982050061, green: 0.5490344763, blue: 0.5528618097, alpha: 1)) : Color(#colorLiteral(red: 0.9254772663, green: 0.9412199855, blue: 0.9449794888, alpha: 1)))
                        .foregroundColor(selectedCategory == "Set as Search Category" ? Color.white: Color(#colorLiteral(red: 0.204610765, green: 0.2861392498, blue: 0.3685011268, alpha: 1)))
                        .clipShape(RoundedRectangle(cornerRadius: 16.0, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
                        
                    } .padding()
//                }
               
                
                ScrollView(.horizontal){
                    HStack{
                        
                        CategoryButton(name: "Dog Parks", search: $search, showSearchResultsList: $showSearchView, selectedCategory: $selectedCategory)

                        
                        CategoryButton(name: "EV Chargers", search: $search, showSearchResultsList: $showSearchView, selectedCategory: $selectedCategory)

                        
                        
                        CategoryButton(name: "Historical Sites", search: $search, showSearchResultsList: $showSearchView, selectedCategory: $selectedCategory)


                        CategoryButton(name: "Hotels", search: $search, showSearchResultsList: $showSearchView, selectedCategory: $selectedCategory)



                        CategoryButton(name: "Coffee", search: $search, showSearchResultsList: $showSearchView, selectedCategory: $selectedCategory)


 
                        CategoryButton(name: "Rest Areas", search: $search, showSearchResultsList: $showSearchView, selectedCategory: $selectedCategory)

                        

                    }
                }
                .padding(.top, 0)

                
            }
            
            SearchResultsListView(landmarks: appState.landmarks, showSearchView: $showSearchView, selectedTab: $selectedTab) { landmark in
                appState.selectedLandmark = landmark
//                print("SearchResultsListView Trailing closure")
//                print("selected landmark: \(String(describing: landmark.title))")
            }
        }
    }
}

struct SearchScreen_Previews: PreviewProvider {
    static var previews: some View {
        SearchScreen(selectedTab: .constant("Search"), showSearchView: .constant(false) )
    }
}
