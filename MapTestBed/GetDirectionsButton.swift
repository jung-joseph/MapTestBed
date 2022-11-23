//
//  GetDirectionsButton.swift
//  MapTestBed
//
//  Created by Joseph Jung on 11/16/22.
//

import SwiftUI
import MapKit

struct GetDirectionsButton: View {
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var searchVM: SearchResultsViewModel
    @EnvironmentObject var settings: Settings
    
    @Binding var showDestinationsView: Bool
    
    var distanceFormatter = DistanceFormatter()

    var body: some View {
        
        let directionsVM = DirectionsViewModel()
        var computedRoutes:[MKRoute] = []

        Button(action:
                {
            print(" In GetDirectionsButton")
            
            showDestinationsView = false

            // start at the selected starting location (current location, Home, or Selected Start Location) or the current user location, if none selected
//            let start = appState.startLocation ?? MKMapItem.forCurrentLocation()
            let start = MKMapItem(placemark: MKPlacemark(coordinate: appState.startLocation?.coordinate ?? MKMapItem.forCurrentLocation().placemark.coordinate))
            print()
            print("******** start: \(start.placemark.coordinate) ************")
            // Put route coordinates into routeCoords array starting with the current user location (start)
            var routeCoords: [MKMapItem] = []
            
            print("\(routeCoords.count)")

            routeCoords.append(start)
            
            print("\(routeCoords.count)")
            print()
            
            for place in appState.destinationLandmarks {
                print(place!.title!)
                
                routeCoords.append(MKMapItem(placemark: MKPlacemark(coordinate: place?.coordinate ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0) ) ))
                
            }
            // set the number of route segments
            let numberOfRoutes = routeCoords.count - 1
            print("numberOfRouteSegments: \(numberOfRoutes)")
            // clear all annotations
            appState.landmarks.removeAll() // this works
//            **************************************************
            //clear all overlays
            appState.map.removeOverlays(appState.map.overlays) // this does not work
//            ***************************************************
            //remove all elements of previous routeSteps directions
            appState.routeSteps.removeAll()
            
            //MARK: - call to async directions
            Task {
                //                        computedRoutes.append(await directionsVM.calculateDirections(routePoints: routeCoords))
                
                computedRoutes = await directionsVM.calculateDirections(routePoints: routeCoords)
                await processRoutes(computedRoutes: computedRoutes)
            }
            //MARK: -
            
        },
               label:
                {Text("Get Directions")})
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(5)
        .shadow(radius: 10)

       
    }
    
    
    struct GetDirectionsButton_Previews: PreviewProvider {
        static var previews: some View {
            GetDirectionsButton(showDestinationsView: .constant(false))
        }
    }
    
    //MARK: - PROCESS ROUTES
    func processRoutes(computedRoutes: [MKRoute]) async {
        print("In processRoutesTest")
        print("number of Routes: \(computedRoutes.count)")
        let numberOfRoutes = computedRoutes.count
        
        
        // clear all overlays
        //        mapView.removeOverlays(mapView.overlays) // ?
        // clear all annotations
        
        //        mapView.removeAnnotations(mapView.annotations) // ?
        appState.landmarks.removeAll()
        
        // add annotation for starting point
        let startLandmark = appState.startLocation ?? MKMapItem.forCurrentLocation()

        print("In GetDirections, \(MKMapItem.forCurrentLocation().placemark.coordinate)")
//        let startLandmark = LandmarkAnnotation(mapItem: appState.startLocation ?? MKMapItem.forCurrentLocation())
        
        appState.landmarks.append(appState.startLocation ?? LandmarkAnnotation(mapItem: MKMapItem.forCurrentLocation()))

        for  index in 0...numberOfRoutes - 1{
            
            print("route#: \(index)")
            //
            //
            let controller = RouteContentViewController(route: computedRoutes[index])
            let routePopover = RoutePopover(controller: controller)
            //
            //                        //
            let positioningView = UIView(frame: CGRect(x: appState.map.frame.width/2.6, y:0, width: appState.map.frame.width/2, height: 0.0))
            //                        //
            //                        //
            appState.map.addSubview(positioningView)
            //                        //
            
            //            appState.landmarks.removeAll()
            
            
            
            //                        //
            // Add annotation
            //            mapView.addAnnotation(appState.destinationLandmarks[index]!) // This does not work
            appState.landmarks.append(appState.destinationLandmarks[index]!)
            //                        //
            //                        //
            //                        //
            //                            // add overlay on the map
            appState.map.addOverlay(computedRoutes[index].polyline, level: .aboveRoads)
            //
            //
            routePopover.show(routePopover, sender: self)
            //
            for step in computedRoutes[index].steps {
                if step.instructions.isEmpty {
                    continue
                }
                //
                let iconName = directionsIcon(step.instructions)
                let distance = "\(distanceFormatter.format(distanceInMeters: step.distance))"
                let stepInstructions = step.instructions
                //
                //                            print("\(iconName)")
                //                            print("\(stepInstructions)")
                //                            print("\(distance)")
                //
                let arrayElement = RouteStep(imageName: iconName, instructions: stepInstructions, distance: distance)
                //
                //                            print("arrayElement: \(String(describing: arrayElement.imageName)), \(String(describing: arrayElement.instructions)), \(String(describing: arrayElement.distance))")
                //
                appState.routeSteps.append(arrayElement)
                //
                //                        }
                //                        let placeName = appState.destinationLandmarks[index]?.title
                //                        appState.routeSteps.append(RouteStep(imageName: "", instructions: placeName, distance: ""))
                //                        // add a blank line
                //                        appState.routeSteps.append(RouteStep(imageName: "", instructions: "", distance: ""))
                //
                //
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
    
}
