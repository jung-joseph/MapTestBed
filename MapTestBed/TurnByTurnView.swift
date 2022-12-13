//
//  TurnByTurnView.swift
//  MapTestBed
//
//  Created by Joseph Jung on 12/12/22.
//

import SwiftUI
import CoreLocation

struct TurnByTurnView: View {
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var locationManager: LocationManager
    
    
   
    var body: some View {
        
        
        VStack{
            Text("User Location")
            
//            Text("Lat: \(appState.map.userLocation.coordinate.latitude)")
//            Text("Lon: \(appState.map.userLocation.coordinate.longitude)")
            
            Text("Lat: \(locationManager.location?.coordinate.latitude ?? CLLocation(latitude:0.0 , longitude: 0.0).coordinate.latitude)")
            Text("Lon: \(locationManager.location?.coordinate.longitude ?? CLLocation(latitude:0.0 , longitude: 0.0).coordinate.longitude)")

        }
    }
}

struct TurnByTurnView_Previews: PreviewProvider {
    static var previews: some View {
        TurnByTurnView()
    }
}
