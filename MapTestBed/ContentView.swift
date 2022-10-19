//
//  ContentView.swift
//  MapTestBed
//
//  Created by Joseph Jung on 9/18/22.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
 
    
    var body: some View {
        NavigationView {
            VStack {
                MapScreen()
            }.ignoresSafeArea()
                .navigationTitle("MapTest Bed")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
