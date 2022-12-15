//
//  DirectionsViewModel.swift
//  AsyncDirections
//
//  Created by Mohammad Azam on 12/23/21.
//https://www.youtube.com/watch?v=laycQaNxwhY

import Foundation
import SwiftUI
import CoreLocation
import MapKit

@MainActor
class DirectionsViewModel: ObservableObject {
    
    @ObservedObject var settings: Settings
    @Published var steps: [MKRoute.Step] = []
    var distanceFormatter = DistanceFormatter()

    init(settings: Settings) {
        self.settings = settings
 
    }

    func calculateDirections(routePoints: [MKMapItem]) async -> [MKRoute]{
        var instructions: [RouteStep] = []
        var computedRoutes: [MKRoute] = []

        do {
            // loop over each segment of the route
            for index in 0...routePoints.count - 2{
                
               
                
                let directionsRequest = MKDirections.Request()
                directionsRequest.transportType = settings.transportationType
//                directionsRequest.transportType = .automobile

                
                directionsRequest.source = routePoints[index]
                directionsRequest.destination = routePoints[index + 1]
                
                
                
                
                let directions = MKDirections(request: directionsRequest)
//                MARK: - GET THE ROUTE
                let response = try await directions.calculate()
//                MARK: -
                
                guard let route = response.routes.first else {
                    return []
                }
 
                computedRoutes.append(route)
                
//                print("Destination: \(String(describing: routePoints[index].name))")
//                appState.arrivalVM.destination = routePoints[index].name
                
                // time Estimate
//                let expectedTravelTimeInSeconds = route.expectedTravelTime
                
//                let timeFormatter = TimeFormatter()
                
//                let travelTime = timeFormatter.expectedTravelTimeString(expectedTravelTime: expectedTravelTimeInSeconds)
                
                
                
//                print("Travel time: \(travelTime)")
                
             
                
//                let arrivalTime = timeFormatter.expectedArrivalTimeString(expectedTravelTime: expectedTravelTimeInSeconds)
                
                
                
                
//                print("Expected Arrival Time: \(arrivalTime)")

                
                

                //                steps = route.steps
                for step in route.steps{
                    //                        steps.append(route.steps[step])
                    
                    let iconName = self.directionsIcon(step.instructions)
                    let distance = "\(self.distanceFormatter.format(distanceInMeters: step.distance))"
                    let stepInstructions = step.instructions
                    
                    
                   
                    let arrayElement = RouteStep(imageName: iconName, instructions: stepInstructions, distance: distance)

                    
                    instructions.append(arrayElement)
                    
                }
                
                
            } // Loop over each Route Segment
            
        } catch {
                print(error)
           
        }
        return computedRoutes

    }
    

    
    private func getPlacemarkBy(address: String) async throws -> CLPlacemark? {
        
        let geoCoder = CLGeocoder()
        let placemark = try await geoCoder.geocodeAddressString(address)
        return placemark.first

    }
    
    private func getPlacemarkBy(coordinate: CLLocationCoordinate2D) async throws -> CLPlacemark? {
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let placemark = try await geoCoder.reverseGeocodeLocation(location)
        return placemark.first

    }
    //MARK: - directionIcons
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
    
}
