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
//            print("  Go! Button")
//            print("startLocationType: \(appState.startLocationType)")
            
            showDestinationsView = false
            

            
            var start: MKMapItem? = nil
            
            if appState.startLocationType == "currentLocation" {
           
                start = MKMapItem.forCurrentLocation()
                appState.startLocation = LandmarkAnnotation(mapItem: start!)

                
            } else if appState.startLocationType == "home" {
                
                //                let homeLatExist = UserDefaults.standard.bool(forKey: "homeLat")
                //                let homeLonExist = UserDefaults.standard.bool(forKey: "homeLon")
              
                let homeLon:Double? = UserDefaults.standard.double(forKey: "homeLon")
                let homeLat:Double? = UserDefaults.standard.double(forKey: "homeLat")
                
                if appState.homeLocation != nil {
                    let homeCoords = CLLocationCoordinate2D(latitude: homeLat!, longitude: homeLon!)
                    let homeStart = LandmarkAnnotation(mapItem: MKMapItem(placemark: MKPlacemark(coordinate: homeCoords)))
                    appState.homeLocation = homeStart
                    appState.homeLocation?.mapItem.name = "Home"
                    appState.startLocation = appState.homeLocation
                    
                    start = MKMapItem(placemark: MKPlacemark(coordinate: homeCoords))
                    
                    //                    start = MKMapItem(placemark: MKPlacemark(coordinate: appState.homeLocation!.coordinate))
                    //                    appState.startLocation = appState.homeLocation
                } else {
                    start = MKMapItem.forCurrentLocation()
                    appState.startLocation = LandmarkAnnotation(mapItem: MKMapItem.forCurrentLocation())
                }
                
                
                
            } else if appState.startLocationType == "selectedLocation" {
                
                if appState.selectedStartLocation != nil {
                    start = MKMapItem(placemark: MKPlacemark(coordinate: appState.selectedStartLocation!.coordinate))
                    appState.startLocation = appState.selectedStartLocation
                } else {
                    start = MKMapItem.forCurrentLocation()
                    appState.startLocation = LandmarkAnnotation(mapItem: MKMapItem.forCurrentLocation())
                }

                                     
            } else {
                   start = MKMapItem.forCurrentLocation()
            }
                                     

            // Put route coordinates into routeCoords array starting with the current user location (start)
            var routeCoords: [MKMapItem] = []
            

            routeCoords.append(start ?? MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 51.5073, longitude: -0.1277))))
            

//            print("routeCoords.count \(routeCoords.count)")
            
            for place in appState.destinationLandmarks {
//                print("Place:\(place!.title!)")
//                print("destinationLandmarks.count \(appState.destinationLandmarks.count)")
                
                routeCoords.append(MKMapItem(placemark: MKPlacemark(coordinate: place?.coordinate ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0) ) ))
                

                
            }
            // set the number of route segments
//            let numberOfRoutes = routeCoords.count - 1

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
                
                computedRoutes = await directionsVM.calculateDirections(routePoints: routeCoords)
                await processRoutes(computedRoutes: computedRoutes)
                
            }
            //MARK: -
            
        },
               label:
                {Text("Go!")})
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
//        print("In processRoutesTest")
//        print("number of Routes: \(computedRoutes.count)")
        let numberOfRoutes = computedRoutes.count
        
        

        // clear all annotations
        
        appState.landmarks.removeAll()
        
        // add annotation for starting point
        
        appState.landmarks.append(appState.startLocation ?? LandmarkAnnotation(mapItem: MKMapItem.forCurrentLocation()))
        
        for  index in 0...numberOfRoutes - 1{
            
//            print("route#: \(index)")
            //
            //
            let controller = RouteContentViewController(route: computedRoutes[index])
            let routePopover = RoutePopover(controller: controller)
            //
            //                        //
            let positioningView = UIView(frame: CGRect(x: appState.map.frame.width/2.6, y:0, width: appState.map.frame.width/2, height: 0.0))
  
            appState.map.addSubview(positioningView)
  
            
            // Add annotation
            appState.landmarks.append(appState.destinationLandmarks[index]!)
        
            // add overlay on the map
            appState.map.addOverlay(computedRoutes[index].polyline, level: .aboveRoads)
            
            
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
              
                
                let arrayElement = RouteStep(imageName: iconName, instructions: stepInstructions, distance: distance)
                
                
                appState.routeSteps.append(arrayElement)
                
                
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
