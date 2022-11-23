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
    //
//    let currentLocation = MKMapItem.forCurrentLocation()
//    let currentLocationAnnotation = Landmark(placemark: currentLocation.placemark)
    //LandmarkAnnotation(mapItem: MKMapItem.forCurrentLocation())
    var body: some View {
        
        NavigationView {
            VStack{
                
                Text("Set Start Location:")
                
//                Picker(selection: $appState.startLocation) {
//                    Text("Current Location").tag(currentLocation)
//                    Text("Home").tag(MKMapItem(placemark: MKPlacemark(coordinate: appState.homeLocation!.coordinate  ))  )
//                    Text("Selected Start Location").tag(appState.selectedStartLocation != nil  ? appState.selectedStartLocation : nil)
//                } label: {
//                    EmptyView()
//                }.pickerStyle(.segmented)

//                print("Start Location: \(startLocation.title)")
                
                HStack{
                    Button("Current Location"){
                        appState.startLocation =  LandmarkAnnotation(mapItem: MKMapItem.forCurrentLocation())

//                        appState.startLocation =  MKMapItem.forCurrentLocation()
                    }
                    .frame(width: 100, height: 50)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    .shadow(radius: 10)
                    
                    Button("Home"){
//                        appState.startLocation = MKMapItem()
                        appState.startLocation = appState.homeLocation
//                        appState.startLocation = MKMapItem(placemark: MKPlacemark(coordinate: appState.homeLocation?.coordinate ?? currentLocation.placemark.coordinate))
                    }
                    .frame(width: 100, height: 50)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    .shadow(radius: 10)
                    Button("Selected Start Location"){
                        appState.startLocation = appState.selectedStartLocation
//                        appState.startLocation = MKMapItem(placemark: MKPlacemark(coordinate: appState.selectedStartLocation?.coordinate ?? currentLocation.placemark.coordinate ))

                    }
                    .frame(width: 125, height: 50)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    .shadow(radius: 10)
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
