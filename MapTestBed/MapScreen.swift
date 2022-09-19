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
    
    var body: some View {
        MapView(annotations: appState.landmarks,selectedLandmark: appState.selectedLandmark)
    }
}

struct MapScreen_Previews: PreviewProvider {

    static var previews: some View {
        MapScreen()
    }
}
