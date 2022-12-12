//
//  TurnByTurnView.swift
//  MapTestBed
//
//  Created by Joseph Jung on 12/12/22.
//

import SwiftUI

struct TurnByTurnView: View {
    
    @EnvironmentObject var appState: AppState
    var locationManager = LocationManager()
    
    var body: some View {
        VStack{
            Text("User Location")
            
            Text("Lat: \(appState.map.userLocation.coordinate.latitude)")
            Text("Lon: \(appState.map.userLocation.coordinate.longitude)")
            
            Text("Lat: \(locationManager.location?.coordinate.latitude ?? 1000.0)")
            Text("Lon: \(locationManager.location?.coordinate.longitude ?? 1000.0)")
        }
    }
}

struct TurnByTurnView_Previews: PreviewProvider {
    static var previews: some View {
        TurnByTurnView()
    }
}
