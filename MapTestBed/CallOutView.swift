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
                    //                    let interimDestination = MKMapItem(placemark: MKPlacemark(coordinate: appState.destinationLandmarks[0]?.coordinate ?? selectedAnnotation.coordinate ) )
                    //                    let destination = MKMapItem(placemark: MKPlacemark(coordinate: appState.destinationLandmarks[1]?.coordinate ?? selectedAnnotation.coordinate ) )
                    //                    let destination = MKMapItem(placemark: MKPlacemark(coordinate: selectedAnnotation.coordinate ) )
                    
                    print()
                    print("start coordinates: \(start.placemark.coordinate)")
                    print("currentLocation: \(start)")
                    //                    print("destination: \(destination)")
                    
                    
                    //                    var routeCoords: [MKMapItem] = [start, interimDestination, destination] // Fix this
                    var routeCoords: [MKMapItem] = []
                    routeCoords.append(start)
                    print()
                    for place in appState.destinationLandmarks {
                        print(place!.title!)
                        
                        routeCoords.append(MKMapItem(placemark: MKPlacemark(coordinate: place?.coordinate ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0) ) ))
                        
                        //                        routeCoords.append(MKMapItem(placemark: MKPlacemark(coordinate: place?.coordinate ?? start.placemark.coordinate ) ))
                    }
                    let numberOfRoutes = routeCoords.count - 1
                    print("numberOfRoutes: \(numberOfRoutes)")
                    
                    // clear all annotations
                    mapView.removeAnnotations(mapView.annotations)
                    
                    // clear all overlays
                    mapView.removeOverlays(mapView.overlays)
                    
                    //remove all elements of previous routeSteps directions
                    appState.routeSteps.removeAll()
                    
                    // iterate over each route segment. routeCoords[0] = "current location"
                    
                    
                    
//                    for index in 0...numberOfRoutes - 1{
//                        //                    for index in 0...1{
//                        print("index: \(index)")
//                        print("destination: \(String(describing: appState.destinationLandmarks[index]?.title))")
//                        //                        print("routeCoord: \(String(describing: routeCoords[index].coordinate))")
//                        print("Calculating Route inside CallOutView")
//                        print("route#: \(index)")
//                        print("start: \(start)")
//
//                        // calculate Routes and store in appState.routes
//                        self.calculateRoute(start: routeCoords[index], destination: routeCoords[index + 1]) { route in
//                            if let routeT = route {
//                                appState.routes.append(routeT)
//                            }
//                        }
//                    }
//
//                    for index in 0...numberOfRoutes - 1 {
//                        //                                print("destination: \(self.destination)")
//                        //
//                        print("in Second loop length of routes: \(appState.routes.count); index: \(index)")
//                        //
//                        let controller = RouteContentViewController(route: appState.routes[index]!)
//                        let routePopover = RoutePopover(controller: controller)
//                        //
//                        let positioningView = UIView(frame: CGRect(x: mapView.frame.width/2.6, y:0, width:
//                                                                    mapView.frame.width/2, height: 0.0))
//                        //
//                        //
//                        mapView.addSubview(positioningView)
//                        //
//                        //
//                        // Add annotation
//                        mapView.addAnnotation(appState.destinationLandmarks[index]!) // Fix
//                        //
//                        //
//                        //
//                        //                            // add overlay on the map
//                        mapView.addOverlay(appState.routes[index]!.polyline, level: .aboveRoads)
//
//
//                        routePopover.show(routePopover, sender: self)
//
//                        //                            appState.route = route
//
//
//                        for step in appState.routes[index]!.steps {
//                            if step.instructions.isEmpty {
//                                continue
//                            }
//
//                            let iconName = directionsIcon(step.instructions)
//                            let distance = "\(distanceFormatter.format(distanceInMeters: step.distance))"
//                            let stepInstructions = step.instructions
//
//                            print("\(iconName)")
//                            print("\(stepInstructions)")
//                            print("\(distance)")
//
//                            let arrayElement = RouteStep(imageName: iconName, instructions: stepInstructions, distance: distance)
//
//                            print("arrayElement: \(String(describing: arrayElement.imageName)), \(String(describing: arrayElement.instructions)), \(String(describing: arrayElement.distance))")
//
//                            appState.routeSteps.append(arrayElement)
//
//                        }
//                        let placeName = appState.destinationLandmarks[index]?.title
//                        appState.routeSteps.append(RouteStep(imageName: "", instructions: placeName, distance: ""))
//                        // add a blank line
//                        appState.routeSteps.append(RouteStep(imageName: "", instructions: "", distance: ""))
//
//                    }
//
                    
                        
                    
                    
                    for index in 0...numberOfRoutes - 1{
//                    for index in 0...1{
                        print("index: \(index)")
                        print("destination: \(String(describing: appState.destinationLandmarks[index]?.title))")
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
                                    let placeName = appState.destinationLandmarks[index]?.title
                                    appState.routeSteps.append(RouteStep(imageName: "", instructions: placeName, distance: ""))
                                    // add a blank line
                                    appState.routeSteps.append(RouteStep(imageName: "", instructions: "", distance: ""))

                                }
                            }


                    }
                    

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
                    } else {
                        let numDestinations = appState.destinationLandmarks.count
                        appState.destinationLandmarks.insert(selectedAnnotation,at: numDestinations - 1)
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
        
        print(" In calculating route CallOutView")
        
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
