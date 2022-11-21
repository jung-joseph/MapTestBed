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
    @EnvironmentObject var searchVM: SearchResultsViewModel
    
    @Binding var showDestinationsView: Bool
    
    var body: some View {
        
        NavigationView {
            VStack{
                
                
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
                    ToolbarItem(placement: .navigation){
                        GetDirectionsButton(showDestinationsView: $showDestinationsView)
                            
                    }
                    ToolbarItem(){
                        EditButton()
                    }
                    
                }
            }
            .navigationTitle("Destinations")
            .onDisappear{
                print("DestinationView onDisappear called")
            }
            
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
        DestinationsView(showDestinationsView: .constant(false))
    }
}
