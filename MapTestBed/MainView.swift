//
//  MainView.swift
//  MapTestBed
//
//  Created by Joseph Jung on 10/27/22.
//

import SwiftUI
import MapKit

struct MainView: View {
    @State private var selectedTab = "Map"
    @State var showRouteSheet: Bool = false
    @State var showDestinationsView: Bool = false
    @State var showSearchView: Bool = false
    @State var showSettingsView: Bool = false

    
    @EnvironmentObject var settings: Settings
    
    var body: some View {
        let tabColor = Color(.black)
        
        TabView(selection: $selectedTab){
//MARK: - MAPSCREEN
            MapScreen()
                .tabItem {
                    Image(systemName: "map.fill").foregroundColor(tabColor)
                    Text("Map")
                }
                .tag("Map")
            
            

            
//MARK: - SEARCHSCREEN

            DummyView()
                .onAppear(){
//                    selectedTab = "Map"
                    selectedTab = ""

                    showSearchView.toggle()
                }
                .tabItem {
                    Image(systemName: "magnifyingglass.circle.fill").foregroundColor(tabColor)
                    Text("Search")
                }
                .tag("Search")
                .sheet(isPresented: $showSearchView) {
                    SearchScreen(selectedTab: $selectedTab,showSearchView: $showSearchView)
                        .presentationDetents([.large, .medium, .fraction(0.75), .fraction(0.50)])
                }
            
            

            
//MARK: - DESTINATIONSVIEW

            DummyView()
                .onAppear(){
                    selectedTab = "Map"
                    showDestinationsView.toggle()
                }
                .tabItem {
                    Image(systemName: "mappin.and.ellipse").foregroundColor(tabColor)
                    Text("Destinations")
                }
                .tag("Destinations")
                .sheet(isPresented: $showDestinationsView) {
                    DestinationsView(showDestinationsView: $showDestinationsView)
                        .presentationDetents([.large, .medium, .fraction(0.75), .fraction(0.35)])
                }
            
//MARK: - ROUTEVIEW

            DummyView()
                .onAppear(){
                    selectedTab = "Map"
                    showRouteSheet.toggle()
                }
                .tabItem {
                    Image(systemName: "point.topleft.down.curvedto.point.bottomright.up.fill").foregroundColor(tabColor)
                    Text("Route")
                }
                .tag("Route")
        
        .sheet(isPresented: $showRouteSheet) {
            RouteView()
                .presentationDetents([.large, .medium, .fraction(0.75), .fraction(0.25), .fraction(0.05)])
        }
            

            

            
//MARK: - SETTINGS SCREEN

            DummyView()
                .onAppear(){
                    selectedTab = "Map"
                    showSettingsView.toggle()
                }
                .tabItem {
                    Image(systemName: "gear.circle.fill").foregroundColor(tabColor)
                    Text("Settings")
                }
                .tag("Settings")
        
        .sheet(isPresented: $showSettingsView) {
            SettingsScreen(settings: settings)
                .presentationDetents([.large, .medium, .fraction(0.75), .fraction(0.50)])
        }
        }

    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

extension UITabBarController {
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let standardAppearance = UITabBarAppearance()
    
        standardAppearance.selectionIndicatorTintColor = .red

        tabBar.standardAppearance = standardAppearance
    }
}
