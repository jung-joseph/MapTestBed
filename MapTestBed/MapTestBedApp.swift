//
//  MapTestBedApp.swift
//  MapTestBed
//
//  Created by Joseph Jung on 9/18/22.
//

import SwiftUI

@main
struct MapTestBedApp: App {
    @StateObject var appState = AppState()
    @StateObject var locationManager = LocationManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environmentObject(locationManager)

        }
    }
}
