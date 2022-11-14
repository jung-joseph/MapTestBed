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
    @EnvironmentObject var settings: Settings
    
    var body: some View {
        let tabColor = Color(.black)
        
        TabView(selection: $selectedTab){
            
            MapScreen()
                .tabItem {
                    Image(systemName: "map.fill").foregroundColor(tabColor)
                    Text("Map")
                }
                .tag("Map")
            
            
            SearchScreen(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "magnifyingglass.circle.fill")
                        .foregroundColor(.red)
                    Text("Search")
                }
                .tag("Search")
            
//            DestinationsView()
//                .tabItem {
//                    Image(systemName: "mappin.and.ellipse")
//                    Text("Destinations")
//                }
//                .tag("Destinations")
            DummyView()
                .onAppear(){
                    selectedTab = "Map"
                    showDestinationsView.toggle()
                }
                .tabItem {
                    Image(systemName: "map.fill").foregroundColor(tabColor)
                    Text("Destinations")
                }
                .tag("Destinations")
            
            DummyView()
                .onAppear(){
                    selectedTab = "Map"
                    showRouteSheet.toggle()
                }
                .tabItem {
                    Image(systemName: "map.fill").foregroundColor(tabColor)
                    Text("Route")
                }
                .tag("Route")
        
        .sheet(isPresented: $showRouteSheet) {
            RouteView()
                .presentationDetents([.large, .medium, .fraction(0.75), .fraction(0.25), .fraction(0.05)])
        }
            
        .sheet(isPresented: $showDestinationsView) {
            DestinationsView()
                .presentationDetents([.large, .medium, .fraction(0.75), .fraction(0.25)])
        }
            
            SettingsScreen(settings: settings)
                .tabItem {
                    Image(systemName: "gear.circle.fill").foregroundColor(tabColor)
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

extension UITabBarController {
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let standardAppearance = UITabBarAppearance()
    
        standardAppearance.selectionIndicatorTintColor = .red

        tabBar.standardAppearance = standardAppearance
    }
}
