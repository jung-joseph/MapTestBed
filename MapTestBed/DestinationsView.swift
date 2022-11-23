//
//  DestinationsView.swift
//  MapTestBed
//
//  Created by Joseph Jung on 11/6/22.
//

import SwiftUI
import MapKit

struct DestinationsView: View {
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var searchVM: SearchResultsViewModel
    
    @State var startLocation: LandmarkAnnotation?
    @Binding var showDestinationsView: Bool
   
    
    var currentLocation:MKMapItem = MKMapItem.forCurrentLocation()


    var body: some View {
        
        NavigationView {
            VStack{
                
                Text("Set Start Location:")
                

                
                HStack{
                    
                    Picker(selection: $appState.startLocationType) {
                        Text("Current Location").tag("currentLocation")
                        Text("Home").tag("home").tag("home")
                        Text("Selected Location").tag("selectedLocation")
                    } label:{
                        EmptyView()
                    }.pickerStyle(.segmented)
                    
                }
                if appState.startLocationType == "currentLocation" && appState.startLocation?.title != nil{
                    Text("Starting location: Using Current Location")
                } else if appState.startLocationType == "home" && appState.homeLocation?.title != nil{
                    Text("Starting location: \(appState.homeLocation!.title!)")
                } else if  appState.startLocationType == "selectedLocation" && appState.selectedStartLocation?.title != nil {
                    Text("Starting location: \(appState.selectedStartLocation!.title!)")
                } else {
                    Text("Starting location: Using Current Location")
                }
                List {
                    ForEach(appState.destinationLandmarks.indices, id: \.self) { index in
                        HStack {
                            Text("\(index + 1)")
                            Text(appState.destinationLandmarks[index]?.title ?? "")
                        }
                    }
                    .onMove(perform: move)
                    .onDelete(perform: delete)
                }
                .toolbar {
                    ToolbarItem(placement: .navigation){
                        GetDirectionsButton(showDestinationsView: $showDestinationsView)
                            
                    }
                    ToolbarItem(){
                        EditButton()
                    }
                    
                }
            }
            .navigationTitle("Destinations")
            .onDisappear{
                print("DestinationView onDisappear called")
            }
            
        }
    }
    func move(from source: IndexSet, to destination: Int) {
        appState.destinationLandmarks.move(fromOffsets: source, toOffset: destination)
    }
    func delete(at offsets: IndexSet) {
        appState.destinationLandmarks.remove(atOffsets: offsets)
    }
}

struct DestinationsView_Previews: PreviewProvider {
    static var previews: some View {
        DestinationsView(showDestinationsView: .constant(false))
    }
}
