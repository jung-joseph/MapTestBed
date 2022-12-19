//
//  GetDirectionsButton.swift
//  MapTestBed
//
//  Created by Joseph Jung on 11/16/22.
//
import SwiftUI
import MapKit
import AVFoundation

struct GoDirectionsButton: View {
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var searchVM: SearchResultsViewModel
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var locationManager: LocationManager
    
    @Binding var showDestinationsView: Bool
    
    
    @State var speechsynthesizer = AVSpeechSynthesizer()
    
    var distanceFormatter = DistanceFormatter()
    
    var currentLocation: CLLocation {
        if let currentLocation = locationManager.location {
            return currentLocation
        } else {
            return CLLocation(latitude: 0.0, longitude: 0.0)
        }
    }
    
    var mapItemForCurrentLocation: MKMapItem {
        MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude:currentLocation.coordinate.latitude, longitude:currentLocation.coordinate.longitude)))
    }

    var body: some View {
        
        let directionsVM = DirectionsViewModel(settings: settings)
        var computedRoutes:[MKRoute] = []

        Button(action:
                {
//            print("  Go! Button")
//            print("startLocationType: \(appState.startLocationType)")
            
            showDestinationsView = false
            
           
            
//            Task{
                var start: MKMapItem? = nil
                
                if appState.startLocationType == "currentLocation" {
                    
                    start = mapItemForCurrentLocation

                    
                    appState.startLocation = LandmarkAnnotation(mapItem: start!)
//                    print("currentLocation lat: \(appState.startLocation!.coordinate.longitude) lon: \(appState.startLocation!.coordinate.latitude)")

                    
                } else if appState.startLocationType == "home" {
                    
                   
                  
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
                        start = mapItemForCurrentLocation
                        appState.startLocation = LandmarkAnnotation(mapItem: mapItemForCurrentLocation)

//                        start = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude:currentLocation.coordinate.latitude, longitude:currentLocation.coordinate.longitude)))
//                        appState.startLocation = LandmarkAnnotation(mapItem: MKMapItem.forCurrentLocation())
                    }
                    
                    
                    
                } else if appState.startLocationType == "selectedLocation" {
                    
                    if appState.selectedStartLocation != nil {
                        start = MKMapItem(placemark: MKPlacemark(coordinate: appState.selectedStartLocation!.coordinate))
                        appState.startLocation = appState.selectedStartLocation
                    } else {
                        start = mapItemForCurrentLocation
                        appState.startLocation = LandmarkAnnotation(mapItem: mapItemForCurrentLocation)

//                        start = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude:currentLocation.coordinate.latitude, longitude:currentLocation.coordinate.longitude)))
//                        appState.startLocation = LandmarkAnnotation(mapItem: MKMapItem.forCurrentLocation())
                    }

                                         
                } else {
//                    start = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude:currentLocation.coordinate.latitude, longitude:currentLocation.coordinate.longitude)))
                       start = mapItemForCurrentLocation
                }
           
            
            // Update map region to startLocation
            
            if appState.startLocationType == "currentLocation"{
                
//                let region = MKCoordinateRegion(center: appState.map.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
                
                let region = MKCoordinateRegion(center: currentLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
                appState.map.setRegion(region, animated: true)
            } else {
                
//                let region = MKCoordinateRegion(center: appState.startLocation?.coordinate ?? appState.map.userLocation.coordinate , span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
                
                let region = MKCoordinateRegion(center: appState.startLocation?.coordinate ?? currentLocation.coordinate , span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))

                appState.map.setRegion(region, animated: true)
            }

            // Put route coordinates into routeCoords array starting with the appropriate starting location (start)
            var routeCoords: [MKMapItem] = []
            

            routeCoords.append(start ?? MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 51.5073, longitude: -0.1277))))
            

//            print("routeCoords.count \(routeCoords.count)")
            
            for place in appState.destinationLandmarks {
                
//                print("Destination:\(place!.title!)")
                
                
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
            
            //MARK: - COMPUTE ROUTES         call to async calculateDirections
            Task {
                
                computedRoutes = await directionsVM.calculateDirections(routePoints: routeCoords)
                await processRoutes(computedRoutes: computedRoutes)
                
            }
            //MARK: -
            
        },
               label:
                {Text("Show Route")})
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(5)
        .shadow(radius: 10)

       
    }
    
    
    struct GoDirectionsButton_Previews: PreviewProvider {
        static var previews: some View {
            GoDirectionsButton(showDestinationsView: .constant(false))
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
        
//        appState.landmarks.append(appState.startLocation ?? LandmarkAnnotation(mapItem: MKMapItem.forCurrentLocation()))
        appState.landmarks.append(appState.startLocation ?? LandmarkAnnotation(mapItem: MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude:currentLocation.coordinate.latitude, longitude:currentLocation.coordinate.longitude)))))
// clear previous travel times
        appState.travelTime.removeAll()
        
// clear all routes
        appState.routes.removeAll()
        
//remove all elements of previous routeSteps directions
        appState.routeSteps.removeAll()
        
//        MARK: - Loop over all route segments
        for  index in 0...numberOfRoutes - 1{
            

            for route in computedRoutes {
                appState.routes.append(route)
            }
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
            // Stop monitoring all previous monitoredRegions
            for monitoredRegion in locationManager.locationManager.monitoredRegions {
                locationManager.locationManager.stopMonitoring(for: monitoredRegion)
            }
            // Extract Segment Travel Time
            let expectedTravelTimeInSeconds = computedRoutes[index].expectedTravelTime
            appState.travelTime.append(expectedTravelTimeInSeconds)
            //
            var stepCounter = 0
            // set-up region at user location
//            if let location = locationManager.location {
//                 let currentLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude , longitude: location.coordinate.longitude)
//                // set-up regions around step coordinates
//                let region = CLCircularRegion(center: currentLocation, radius: 20, identifier: "\(stepCounter)")
//
//                locationManager.locationManager.startMonitoring(for: region)
//            } else {
//                let currentLocation = CLLocationCoordinate2D(latitude: 51.5072 , longitude: -0.1276)
//               // set-up regions around step coordinates
//               let region = CLCircularRegion(center: currentLocation, radius: 20, identifier: "\(stepCounter)")
//                locationManager.locationManager.startMonitoring(for: region)
//            }
            // set-up start region
            print("stepCounter: \(stepCounter)")
            print("latitude: \(computedRoutes[index].steps[0].polyline.coordinate.latitude)")
            print("longitude: \(computedRoutes[index].steps[0].polyline.coordinate.longitude)")
            
            let region = CLCircularRegion(center: computedRoutes[index].steps[0].polyline.coordinate, radius: 20, identifier: "\(stepCounter)")
            locationManager.locationManager.startMonitoring(for: region)
            
            
//            for step in computedRoutes[index].steps {
            for(loopIndex, step) in computedRoutes[index].steps.enumerated() {
                print("loopIndex: \(loopIndex)")
                
                
                if step.instructions.isEmpty {
                    continue
                }
                
                stepCounter += 1

                //
                let iconName = directionsIcon(step.instructions)
                let distance = "\(distanceFormatter.format(distanceInMeters: step.distance))"
                let stepInstructions = step.instructions
              
                
                let arrayElement = RouteStep(imageName: iconName, instructions: stepInstructions, distance: distance)
                
                
                appState.routeSteps.append(arrayElement)
                
                // set-up regions around step coordinates
                print("stepCounter: \(stepCounter)")
                print("coordinates: \(step.polyline.coordinate.latitude)")
                print("coordinates: \(step.polyline.coordinate.longitude)")

                let region = CLCircularRegion(center: step.polyline.coordinate, radius: 20, identifier: "\(stepCounter)")
                locationManager.locationManager.startMonitoring(for: region)
                
                
              
            }

        }
//               // speech test
//
//                    let initialMessage = "turn here, then turn there"
//                    let speechUtterance = AVSpeechUtterance(string: initialMessage)
//                    speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
//                    speechsynthesizer.speak(speechUtterance)
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
