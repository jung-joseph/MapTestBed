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
    
    @Published var steps: [MKRoute.Step] = []
    var distanceFormatter = DistanceFormatter()

    

    func calculateDirections(routePoints: [MKMapItem]) async -> [MKRoute]{
        var instructions: [RouteStep] = []
        var computedRoutes: [MKRoute] = []

        do {
            for index in 0...routePoints.count - 2{
                
                //                    guard let startPlacemark = try await getPlacemarkBy(coordinate: routePoints[index]),
                //                          let destinationPlacemark = try await getPlacemarkBy(coordinate: routePoints[index + 1]) else {
                //                        return
                //                    }
                
                let directionsRequest = MKDirections.Request()
                directionsRequest.transportType = .automobile
                
                directionsRequest.source = routePoints[index]
                directionsRequest.destination = routePoints[index + 1]
                
                //                directionsRequest.source = MKMapItem(placemark: MKPlacemark(placemark: startPlacemark))
                //                directionsRequest.destination = MKMapItem(placemark: MKPlacemark(placemark: destinationPlacemark))
                
                let directions = MKDirections(request: directionsRequest)
                let response = try await directions.calculate()
                
                guard let route = response.routes.first else {
                    return []
                }
                print("calculateDirections")
                print("routePoints.count: \(routePoints.count)")
                computedRoutes.append(route)
                
                //                steps = route.steps
                for step in route.steps{
                    //                        steps.append(route.steps[step])
                    
                    let iconName = self.directionsIcon(step.instructions)
                    let distance = "\(self.distanceFormatter.format(distanceInMeters: step.distance))"
                    let stepInstructions = step.instructions
                    
                    print("iconName: \(iconName) stepInstructions: \(stepInstructions) distance: \(distance)")
//                    print("stepInstructions: \(stepInstructions)")
//                    print("distance: \(distance)")
                    
                    let arrayElement = RouteStep(imageName: iconName, instructions: stepInstructions, distance: distance)
//                    print("arrayElement: \(String(describing: arrayElement.imageName)), \(String(describing: arrayElement.instructions)), \(String(describing: arrayElement.distance))")
                    instructions.append(arrayElement)
                    
                }
                
                
            }
        } catch {
                print(error)
           
        }
        return computedRoutes

    }
    
//    func calculateDirections(routePoints: [String]) async {
//
//            do {
//                for index in 0...routePoints.count - 2{
//
//                    guard let startPlacemark = try await getPlacemarkBy(address: routePoints[index]),
//                          let destinationPlacemark = try await getPlacemarkBy(address: routePoints[index + 1]) else {
//                        return
//                    }
//
//                let directionsRequest = MKDirections.Request()
//                directionsRequest.transportType = .automobile
//                directionsRequest.source = MKMapItem(placemark: MKPlacemark(placemark: startPlacemark))
//                directionsRequest.destination = MKMapItem(placemark: MKPlacemark(placemark: destinationPlacemark))
//
//                let directions = MKDirections(request: directionsRequest)
//                let response = try await directions.calculate()
//
//                guard let route = response.routes.first else {
//                    return
//                }
//                    //                steps = route.steps
//                    for step in 0...route.steps.count - 1 {
//                        steps.append(route.steps[step])
//                    }
//
//            }
//            } catch {
//                print(error)
//
//        }
//
//    }
    
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
