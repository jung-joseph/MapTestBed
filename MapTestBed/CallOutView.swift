//
//  CallOutView.swift
//  MapTestBed
//
//  Created by Joseph Jung on 10/21/22.
//

import SwiftUI
import MapKit

struct CallOutView: View {
    
    var mapView: MKMapView
    
    var selectedAnnotation: LandmarkAnnotation
    var snapShot: UIImage?
    var distanceFormatter = DistanceFormatter()

    @EnvironmentObject var appState: AppState
    

    var body: some View {
        VStack{
            HStack{
//MARK: - Directions Button
                Button(action:
                {
                    print("In CallOutView")
                    print("Selected Annotation: \(String(describing: selectedAnnotation.title))")
//                    print("End Destination: \(String(describing: appState.endDestination?.title))")

                    let start = MKMapItem.forCurrentLocation()
                    let interimDestination = MKMapItem(placemark: MKPlacemark(coordinate: appState.destinationLandmarks[0]?.coordinate ?? selectedAnnotation.coordinate ) )
                    let destination = MKMapItem(placemark: MKPlacemark(coordinate: appState.destinationLandmarks[1]?.coordinate ?? selectedAnnotation.coordinate ) )
//                    let destination = MKMapItem(placemark: MKPlacemark(coordinate: selectedAnnotation.coordinate ) )
                    
                    print()
                    print("coordinates: \(start.placemark.coordinate)")
                    print("currentLocation: \(start)")
//                    print("destination: \(destination)")
                    
                    
                    var routeCoords: [MKMapItem] = [start, interimDestination, destination] // Fix this
                    
                    var numberOfRoutes = routeCoords.count - 1
                    print("numberOfRoutes: \(numberOfRoutes)")
                    
                    // clear all annotations
                    mapView.removeAnnotations(mapView.annotations)
                    
                    // clear all overlays
                    mapView.removeOverlays(mapView.overlays)
                    
                    //remove all elements of previous routeSteps directions
                    appState.routeSteps.removeAll()

                    // iterate over each route segment. routeCoords[0] = "current location"
                    for index in 0...numberOfRoutes - 1{
                        print("index: \(index)")
                        //                        print("routeCoord: \(String(describing: routeCoords[index].coordinate))")
                        
                        
                        self.calculateRoute(start: routeCoords[index], destination: routeCoords[index + 1]) { route in
                            if let route = route {
                                print("Calculating Route inside CallOutView")
                                print("route#: \(index)")
                                print("start: \(start)")
//                                print("destination: \(self.destination)")
                                //
                                //
                                let controller = RouteContentViewController(route: route)
                                let routePopover = RoutePopover(controller: controller)
                                //
                                let positioningView = UIView(frame: CGRect(x: mapView.frame.width/2.6, y:0, width:
                                                                            mapView.frame.width/2, height: 0.0))
                                //
                                //
                                mapView.addSubview(positioningView)
                                //
                                //
                                // Add annotation
                                mapView.addAnnotation(appState.destinationLandmarks[index]!) // Fix
                                //
                                //
                                //
                                //                            // add overlay on the map
                                mapView.addOverlay(route.polyline, level: .aboveRoads)

                                
                                routePopover.show(routePopover, sender: self)
                                
                                //                            appState.route = route
                                
                                
                                for step in route.steps {
                                    if step.instructions.isEmpty {
                                        continue
                                    }
                                    
                                    let iconName = directionsIcon(step.instructions)
                                    let distance = "\(distanceFormatter.format(distanceInMeters: step.distance))"
                                    let stepInstructions = step.instructions
                                    
                                    print("\(iconName)")
                                    print("\(stepInstructions)")
                                    print("\(distance)")
                                    
                                    let arrayElement = RouteStep(imageName: iconName, instructions: stepInstructions, distance: distance)
                                    
                                    print("arrayElement: \(String(describing: arrayElement.imageName)), \(String(describing: arrayElement.instructions)), \(String(describing: arrayElement.distance))")
                                    
                                    appState.routeSteps.append(arrayElement)
                                    
                                }
                                
                                
                            }
                            
                        }
                    }
//
                    
//                    self.calculateRoute(start: start, destination: destination) { route in
                    //                        if let route = route {
                    //                            print("Calculating Route inside CallOutView")
                    //                            print("start: \(start)")
                    //                            print("destination: \(destination)")
                    //
                    //            //                view.detailCalloutAccessoryView = nil
                    //
                    //                            let controller = RouteContentViewController(route: route)
                    //                            let routePopover = RoutePopover(controller: controller)
                    //
                    //                            let positioningView = UIView(frame: CGRect(x: mapView.frame.width/2.6, y:0, width:
                    //                                                                        mapView.frame.width/2, height: 0.0))
                    //
                    //                            //                    view.autoresizesSubviews = true
                    //
                    //                            mapView.addSubview(positioningView)
                    //
                    //                            // clear all annotations
                    //                            mapView.removeAnnotations(mapView.annotations)
                    //                            //
                    //                            mapView.addAnnotation(selectedAnnotation)
                    //
                    //                            // clear all overlays
                    //                            mapView.removeOverlays(mapView.overlays)
                    //
                    //                            // add overlay on the map
                    //                            mapView.addOverlay(route.polyline, level: .aboveRoads)
                    //                            //                    routePopover.show(relativeTo: positioningView.frame, of: positioningView, preferredEdge: .minY)
                    //
                    //                            routePopover.show(routePopover, sender: self)
                    //
                    ////                            appState.route = route
                    //
                    //                            appState.routeSteps.removeAll() //remove all elements of previous routeSteps directions
                    //
                    //                            for step in route.steps {
                    //                                if step.instructions.isEmpty {
                    //                                    continue
                    //                                }
                    //
                    //                                let iconName = directionsIcon(step.instructions)
                    //                                let distance = "\(distanceFormatter.format(distanceInMeters: step.distance))"
                    //                                let stepInstructions = step.instructions
                    //
                    //                                print("\(iconName)")
                    //                                print("\(stepInstructions)")
                    //                                print("\(distance)")
                    //
                    //                                let arrayElement = RouteStep(imageName: iconName, instructions: stepInstructions, distance: distance)
                    //
                    //                                print("arrayElement: \(String(describing: arrayElement.imageName)), \(String(describing: arrayElement.instructions)), \(String(describing: arrayElement.distance))")
                    //
                    //                                appState.routeSteps.append(arrayElement)
                    //
                    //                            }
                    //
                    //
                    //                        }
                    //
                    //                    }
                    //
                },
                       label: {Text("Get Directions")})
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    .shadow(radius: 10)
                    
//MARK: - Set Final Destination Button
                Button(action: {
                    appState.destinationLandmarks.append(selectedAnnotation)

//                    if appState.destinationLandmarks.isEmpty {
//                        appState.destinationLandmarks.append(selectedAnnotation)
//                    } else {
//                        appState.destinationLandmarks.removeLast()
//                        appState.destinationLandmarks.append(selectedAnnotation)
//                    }
                },
                       label: {Text("Set As Final Destination")})
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(5)
                .shadow(radius: 10)
//MARK: - Set Interim Destination Button
                Button(action: {
                    if appState.destinationLandmarks.isEmpty {
                        appState.destinationLandmarks.append(selectedAnnotation)
                    } else if (appState.destinationLandmarks.count == 1){
                        let numDestinations = appState.destinationLandmarks.count
                        let lastElement = appState.destinationLandmarks[numDestinations - 1]
                        appState.destinationLandmarks.removeLast()
                        appState.destinationLandmarks.append(selectedAnnotation)
                        appState.destinationLandmarks.append(lastElement)

                    }else if (appState.destinationLandmarks.count > 1){
                        let numDestinations = appState.destinationLandmarks.count
                        appState.destinationLandmarks[numDestinations - 2] = selectedAnnotation
                    }
                },
                       label: {Text("Set As Interim Destination")})
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(5)
                .shadow(radius: 10)
            }
            
//MARK: - Add map snapShot
            if (snapShot != nil) {
                Image(uiImage: snapShot! )
            }
//MARK: - Add site information
            Text(selectedAnnotation.address ?? "")
                .font(.body)
                .padding(.bottom)
            HStack{
                Text(selectedAnnotation.phone ?? "")
                    .font(.body)
                Spacer()
            }
        }
        
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

//struct CallOutView_Previews: PreviewProvider {
//    static var previews: some View {
//        CallOutView(annotation:  <#T##LandmarkAnnotation#>)
//    }
//}
