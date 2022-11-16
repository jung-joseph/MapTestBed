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
    @State private var selectedCategory: String = ""
    @Binding var selectedTab: String
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
                        showSearchResultsList = true
                }
                .onAppear{
                    search = appState.categoryOfInterest ?? ""
                }
            
            VStack{
                HStack{
                    Button("Clear All"){
                        search = ""
                        appState.destinationLandmarks.removeAll()
                        appState.categoryOfInterest = ""
                        appState.landmarks.removeAll()
                        appState.map.removeOverlays(appState.map.overlays)
                        selectedCategory = "Clear All"
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .background(selectedCategory == "Clear All" ? Color(#colorLiteral(red: 0.4982050061, green: 0.5490344763, blue: 0.5528618097, alpha: 1)) : Color(#colorLiteral(red: 0.9254772663, green: 0.9412199855, blue: 0.9449794888, alpha: 1)))
                    .foregroundColor(selectedCategory == "Clear All" ? Color.white: Color(#colorLiteral(red: 0.204610765, green: 0.2861392498, blue: 0.3685011268, alpha: 1)))
                    .clipShape(RoundedRectangle(cornerRadius: 16.0, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
                    
                    Button("Set as Search Category"){
                        appState.categoryOfInterest = search
                        search = appState.categoryOfInterest ?? ""
                        //                    DispatchQueue.main.async {
                                                searchVM.search(query: search) {   landmarks in
                                                    appState.landmarks = landmarks
                                                }
                        //                    }
                                                showSearchResultsList = true
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .background(selectedCategory == "Set as Search Category" ? Color(#colorLiteral(red: 0.4982050061, green: 0.5490344763, blue: 0.5528618097, alpha: 1)) : Color(#colorLiteral(red: 0.9254772663, green: 0.9412199855, blue: 0.9449794888, alpha: 1)))
                    .foregroundColor(selectedCategory == "Set as Search Category" ? Color.white: Color(#colorLiteral(red: 0.204610765, green: 0.2861392498, blue: 0.3685011268, alpha: 1)))
                    .clipShape(RoundedRectangle(cornerRadius: 16.0, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
                    
                }
                .padding()
                
                ScrollView(.horizontal){
                    HStack{
                        
                        CategoryButton(name: "Dog Parks", search: $search, showSearchResultsList: $showSearchResultsList, selectedCategory: $selectedCategory)

                        
                        CategoryButton(name: "EV Chargers", search: $search, showSearchResultsList: $showSearchResultsList, selectedCategory: $selectedCategory)

                        
                        
                        CategoryButton(name: "Historical Sites", search: $search, showSearchResultsList: $showSearchResultsList, selectedCategory: $selectedCategory)


                        CategoryButton(name: "Hotels", search: $search, showSearchResultsList: $showSearchResultsList, selectedCategory: $selectedCategory)



                        CategoryButton(name: "Coffee", search: $search, showSearchResultsList: $showSearchResultsList, selectedCategory: $selectedCategory)


 
                        CategoryButton(name: "Rest Areas", search: $search, showSearchResultsList: $showSearchResultsList, selectedCategory: $selectedCategory)

                        

                    }
                }
                .padding(.top, 0)

                
            }
            
            SearchResultsList(landmarks: appState.landmarks, showSearchResultsList: $showSearchResultsList, selectedTab: $selectedTab) { landmark in
                appState.selectedLandmark = landmark
            }
        }
    }
}

struct SearchScreen_Previews: PreviewProvider {
    static var previews: some View {
        SearchScreen(selectedTab: .constant("Search") )
    }
}
