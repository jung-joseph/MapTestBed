//
//  DestinationsView.swift
//  MapTestBed
//
//  Created by Joseph Jung on 11/6/22.
//

import SwiftUI
import MapKit

struct DestinationsView: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        
        NavigationView {
            VStack{
                Button("Print"){
                    for destination in appState.destinationLandmarks {
                        print("\(String(describing: destination?.title))")
                    }
                }
                
                List {
                    ForEach(appState.destinationLandmarks.indices, id: \.self) { index in
                        HStack {
                            Text("\(index + 1)")
                            Text(appState.destinationLandmarks[index]?.title ?? "")
                        }
                    }
                    .onMove(perform: move)
                    .onDelete(perform: delete)
                }
                .toolbar {
                    EditButton()
                }
            }
            .navigationTitle("Destinations")
        }
    }
    func move(from source: IndexSet, to destination: Int) {
        appState.destinationLandmarks.move(fromOffsets: source, toOffset: destination)
    }
    func delete(at offsets: IndexSet) {
        appState.destinationLandmarks.remove(atOffsets: offsets)
    }
}

struct DestinationsView_Previews: PreviewProvider {
    static var previews: some View {
        DestinationsView()
    }
}
