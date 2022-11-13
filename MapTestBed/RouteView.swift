//
//  RouteView.swift
//  MapTestBed
//
//  Created by Joseph Jung on 10/27/22.
//

import SwiftUI
import MapKit

struct RouteView: View {
    
    @EnvironmentObject var appState: AppState
    var distanceFormatter = DistanceFormatter()
    
    //    var mapView: MKMapView
    //    var selectedAnnotation: LandmarkAnnotation

    
    var body: some View {
    
        VStack {
            Text("Route")
                .font(.title)
            

            ScrollView {
                ForEach(appState.routeSteps, id: \.self) { step in
                    VStack{
//                        Text("Route to: \(appState.destinationLandmarks[appState.routeSteps.indices])")
                        HStack{
//                            Spacer()
                            Image(systemName: step.imageName ?? "")
                            Text(step.distance ?? "0")
                            Text(step.instructions ?? "")
                            
                            Spacer()
                            Spacer()
                            
                        }
                        .padding(.leading)
//                        
                    }
                }
            }
            
        }
 
    }
    
    
    //MARK: - calculate route

    func calculateRoute(start: MKMapItem, destination: MKMapItem, completion: @escaping (MKRoute?) -> Void) {
        let directionsRequest = MKDirections.Request()
        directionsRequest.transportType = .automobile
        directionsRequest.source = start
        directionsRequest.destination = destination
        
        print(" calculating route")
        
        let directions = MKDirections(request: directionsRequest)
        directions.calculate { response, error in
            if let error = error {
                print("Unable to calculate directions \(error)")
            }
            
            guard let response = response,
                  let route = response.routes.first else {
                return
            }
            completion(route)
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



//struct RouteView_Previews: PreviewProvider {
//    static var previews: some View {
//        RouteView()
//    }
//}
