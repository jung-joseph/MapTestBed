//
//  AddHomeButton.swift
//  MapTestBed
//
//  Created by Joseph Jung on 12/2/22.
//

import SwiftUI
import MapKit

struct AddHomeButton: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Button(action:{
            if appState.homeLocation == nil && homeIsStored() {
                DispatchQueue.main.async {
                    print("homeLocation is nil - but coords are stored")
                    let homeLat = UserDefaults.standard.double(forKey: "homeLat")
                    let homeLon = UserDefaults.standard.double(forKey: "homeLon")
                    let homeCoords = CLLocationCoordinate2D(latitude: homeLat, longitude: homeLon)
                    let home = LandmarkAnnotation(mapItem: MKMapItem(placemark: MKPlacemark(coordinate: homeCoords)))
                    appState.homeLocation = home
                    appState.homeLocation?.mapItem.name = "Home"
                }
            }
            DispatchQueue.main.async {
                appState.destinationLandmarks.append(appState.homeLocation)
            }
        },
            label: {
            
            Text("Add Home")
               
            
        })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .background(homeIsStored() ? Color.blue : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(5)
            .shadow(radius: 10)
            .disabled(!homeIsStored())
    }
}

struct AddHomeButton_Previews: PreviewProvider {
    static var previews: some View {
        AddHomeButton()
    }
}

func homeIsStored() -> Bool {
    if UserDefaults.standard.bool(forKey: "homeLat") && UserDefaults.standard.bool(forKey: "homeLon"){
//        print("coords are stored in UserDefaults")
        return true
    } else {
        return false
    }
}
