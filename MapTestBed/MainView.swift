//
//  MainView.swift
//  MapTestBed
//
//  Created by Joseph Jung on 10/27/22.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView{
            
            MapScreen()
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Map")
                }
            
            SearchScreen()
                .tabItem {
                    Image(systemName: "magnifyingglass.circle.fill")
                    Text("Search")
                }
            
            RouteView()
                .tabItem {
                    Image(systemName: "map.circle")
                    Text("Route")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
