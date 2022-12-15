//
//  SettingsScreen.swift
//  MapsMacOS
//
//  Created by Joseph Jung on 8/6/22.
//

import SwiftUI
import MapKit

struct SettingsScreen: View {
    @ObservedObject var settings: Settings
    
    let  mapTypes = [MKMapType.standard, MKMapType.hybrid, MKMapType.satellite]
    let transportationTypes = [MKDirectionsTransportType.automobile, MKDirectionsTransportType.walking, MKDirectionsTransportType.transit]
    
    var body: some View {
        
        NavigationView {
            VStack(alignment: .center, spacing: 20){
                
                Toggle(isOn: $settings.isDarkMode) {
                    Text("Use Dark Map Appearance")
                }
                .padding(EdgeInsets(top: 0,leading:50,bottom: 0, trailing:50))
                
                Divider()
                
                HStack{
                    
                    
                        Text("Distance Units")
                        Picker("", selection: $settings.distanceUnit){
                            ForEach(DistanceUnit.allCases, id: \.self) {distance in
                                Text(distance.title)
                                
                            }
                    
                    }.fixedSize()
                        .padding(.trailing, 20)
                }
                
                Divider()
                
                HStack{
                    Text("Map Type")
                    //            Picker("", selection: $settings.mapType){
                    
                    Picker("", selection: $settings.mapType){
                        ForEach(mapTypes, id: \.self) {type in
                            Text(type.title)
                        }
                        
                    }.fixedSize()
                        .padding(.trailing, 20)
                }
                
                Divider()
                
                HStack{
                    Text("Transportation Type")
                    //            Picker("", selection: $settings.mapType){
                    
                    Picker("", selection: $settings.transportationType){
                        ForEach(transportationTypes, id: \.self) {type in
                            Text(type.title)
                        }
                        
                    }.fixedSize()
                        .padding(.trailing, 20)
                }
                
           
            }.padding()
                .frame(minWidth:400, minHeight: 400)
                .navigationTitle("Settings")
        }
        
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen(settings: Settings())
    }
}

