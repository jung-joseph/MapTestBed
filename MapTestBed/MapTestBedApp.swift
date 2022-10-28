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
    @StateObject var searchVM = SearchResultsViewModel()
    @StateObject var localSearchService = LocalSearchService()
    @StateObject var settings = Settings()


    var body: some Scene {
        WindowGroup {
//            ContentView()
            MainView()
                .environmentObject(appState)
                .environmentObject(locationManager)
                .environmentObject(searchVM)
                .environmentObject(localSearchService)
                .environmentObject(settings)
                .preferredColorScheme(settings.isDarkMode ? .dark : .light)



        }
    }
}
