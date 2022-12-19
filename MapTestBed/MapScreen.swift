//
//  MapScreen.swift
//  MapsMacOS
//
//  Created by Joseph Jung on 8/2/22.
//

import SwiftUI
import MapKit

struct MapScreen: View {
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var locationManager: LocationManager
    
    
    var currentLocation: CLLocation {
        if let currentLocation = locationManager.location {
            return currentLocation
        } else {
            return CLLocation(latitude: 0.0, longitude: 0.0)
        }
    }
    var body: some View {
        
            ZStack {
                MapView(annotations: appState.landmarks,selectedLandmark: appState.selectedLandmark)
                .ignoresSafeArea(.all, edges: .top)
                    .onAppear{
//                        print("onAppear for MapView Called")
                    }
                
                VStack{
                    
                    TurnByTurnScreen()
                    
                    HStack{
                        
                        
                        Spacer()
                        Button(action: {
//                            let region = MKCoordinateRegion(center: appState.map.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
                            let region = MKCoordinateRegion(center: currentLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))

                            appState.map.setRegion(region, animated: true)
                        },
                               label: {
                            Image(systemName: "location.fill")
                                .resizable()
                                .frame(width: 25, height: 25)
                        }
                        )
                        .padding([.top, .trailing], 20)
                    }
                    Spacer()
                }
            }
            


            

    }
}

struct MapScreen_Previews: PreviewProvider {

    static var previews: some View {
        MapScreen()
    }
}
