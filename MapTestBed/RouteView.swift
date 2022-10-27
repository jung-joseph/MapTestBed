//
//  RouteView.swift
//  MapTestBed
//
//  Created by Joseph Jung on 10/27/22.
//

import SwiftUI

struct RouteView: View {
    
    @EnvironmentObject var appState: AppState

    
    var body: some View {
        VStack {
            Text("Route")
            ForEach(appState.routeSteps, id: \.self) { step in
                VStack{
                    HStack{
                        Image(systemName: step.imageName ?? "")
                        Text(step.instructions ?? "")
                    }
                    Text(step.distance ?? "0")
                }
            }
        }
    }
}

private func directionsIcon(_ instruction: String) -> String {
    if instruction.contains("Turn right"){
        return "arrow.turn.up.right"
    } else if instruction.contains("Turn left") {
        return "arrow.turn.up.left"
    } else if instruction.contains("destination") {
        return "mappin.circle.fill"
    } else {
        return "arrow.up"
    }
}

struct RouteView_Previews: PreviewProvider {
    static var previews: some View {
        RouteView()
    }
}