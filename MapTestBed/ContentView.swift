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
       
            MapScreen()
            .ignoresSafeArea()
            
    

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
