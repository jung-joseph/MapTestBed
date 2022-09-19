//
//  ContentView.swift
//  MapTestBed
//
//  Created by Joseph Jung on 9/18/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            MapScreen()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
