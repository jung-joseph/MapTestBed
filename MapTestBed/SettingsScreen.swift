//
//  SettingsScreen.swift
//  MapsMacOS
//
//  Created by Joseph Jung on 8/6/22.
//

import SwiftUI

struct SettingsScreen: View {
    @ObservedObject var settings: Settings
//    @AppStorage("useLightMap") var useLightMap: Bool = false
//    @AppStorage("distanceUnit") var distanceUnit = DistanceUnit.miles
    
    var body: some View {
        VStack(alignment: .center, spacing: 20){
            
            Toggle(isOn: $settings.isDarkMode) {
                Text("Use Dark Map Appearance")
            }
            
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
            
        }.padding()
            .frame(minWidth:400, minHeight: 400)
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen(settings: Settings())
    }
}
