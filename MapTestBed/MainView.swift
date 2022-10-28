//
//  MainView.swift
//  MapTestBed
//
//  Created by Joseph Jung on 10/27/22.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab = "Map"
    @EnvironmentObject var settings: Settings

    var body: some View {
        TabView(selection: $selectedTab){
            
            MapScreen()
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Map")
                }
                .tag("Map")
            
            
            SearchScreen(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "magnifyingglass.circle.fill")
                    Text("Search")
                }
                .tag("Search")
            
            
            SettingsScreen(settings: settings)
                .tabItem {
                    Image(systemName: "gear.circle.fill")
                    Text("Settings")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
