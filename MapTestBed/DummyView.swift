//
//  DummyView.swift
//  MapTestBed
//
//  Created by Joseph Jung on 10/29/22.
//

import SwiftUI

struct DummyView: View {
    var body: some View {
        NavigationView {
            ZStack{
                Color.green
            }
            .navigationTitle("Dummy")
        }
        
    }
}

struct DummyView_Previews: PreviewProvider {
    static var previews: some View {
        DummyView()
    }
}
