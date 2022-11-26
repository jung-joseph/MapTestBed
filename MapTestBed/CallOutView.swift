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
    var annotationView: MKAnnotationView
    
    var distanceFormatter = DistanceFormatter()
    
    @EnvironmentObject var appState: AppState
    
    
    var body: some View {
        VStack{
            HStack{
                Text("Set as: ")
                    .frame(alignment: .topLeading)
                Spacer()
            }
            HStack{
                
                //MARK: - Add Destination Button
                Button(action: {
                    appState.destinationLandmarks.append(selectedAnnotation)
                    //    Remove selectedLandmark so that  annotationView Callout is dismissed
                    appState.selectedLandmark = nil
                    
                },
                       label: {Text("A Destination")})
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(5)
                .shadow(radius: 10)
                
                //MARK: - Set as Starting Location
                Button(action: {
                    
                    appState.selectedStartLocation = selectedAnnotation
                    appState.selectedStartLocation?.mapItem.name = "SelectedStartLocation"
                    //    Remove selectedLandmark so that  annotationView Callout is dismissed
                    appState.selectedLandmark = nil
                    
                },
                       label: {Text("Starting Location")})
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(5)
                .shadow(radius: 10)
                
                //MARK: - Set as Home
                Button(action: {
                    
                    appState.homeLocation = selectedAnnotation
                    appState.homeLocation?.mapItem.name = "Home"
                    //    Remove selectedLandmark so that  annotationView Callout is dismissed
                    appState.selectedLandmark = nil
                    
//                    https://stackoverflow.com/questions/56463518/how-to-save-an-array-of-type-mkmapitem
                    
//                    let defaults = UserDefaults.standard
//                    do {
//
//                            let data = try NSKeyedArchiver.archivedData(withRootObject: selectedAnnotation , requiringSecureCoding: false)
//                            defaults.set(data, forKey: "homeLocation")
//                            print("Data save with no errors")
//                            print()
//
//
//
//// ?? LandmarkAnnotation(mapItem: MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))))
////                        if let dataOut = UserDefaults.standard.data(forKey: "homeLocation"){
////                            if let temp = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(dataOut) as? MKMapItem {
////                                print("Data retrieved with no errors")
////                                print(temp)
////                            }
////                        }
//
//                    }
//                    catch {
//                        print("Couldn't save home location to UserDefaults")
//                        print(error)
//                    }
 
                    
                },
                       label: {Text("Home")})
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
            //MARK: - Add URL
            HStack{
                if selectedAnnotation.url != nil {
                    Text(selectedAnnotation.url!.absoluteString)
                        .font(.system(size: 14))
                        .foregroundColor(.blue)
                        .onTapGesture {
                            if UIApplication.shared.canOpenURL(selectedAnnotation.url!) {
                                UIApplication.shared.open(selectedAnnotation.url!)
                            }
                            
                        }
                    Spacer()
                }
            }
        }
        
        //            .onDisappear{
        //                print("CallOutView onDisappear called!")
        //            }
        
    }
    
    //MARK: - PROCESS ROUTES
    func processRoutes(computedRoutes: [MKRoute]) async {
        //        print("In processRoutesTest")
        //        print("number of Routes: \(computedRoutes.count)")
        let numberOfRoutes = computedRoutes.count
        
        
        // clear all overlays
        mapView.removeOverlays(mapView.overlays) // this call works!
        // clear all annotations
        
        mapView.removeAnnotations(mapView.annotations) // this call does not work!
        appState.landmarks.removeAll()
        
        for  index in 0...numberOfRoutes - 1{
            
            //            print("route#: \(index)")
            //
            //
            let controller = RouteContentViewController(route: computedRoutes[index])
            let routePopover = RoutePopover(controller: controller)
            //
            //                        //
            let positioningView = UIView(frame: CGRect(x: mapView.frame.width/2.6, y:0, width: mapView.frame.width/2, height: 0.0))
            //                        //
            //                        //
            mapView.addSubview(positioningView)
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
            mapView.addOverlay(computedRoutes[index].polyline, level: .aboveRoads)
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
    //MARK: - calculate route
    
    func calculateRoute(start: MKMapItem, destination: MKMapItem, completion: @escaping (MKRoute?) -> Void) {
        let directionsRequest = MKDirections.Request()
        directionsRequest.transportType = .automobile
        directionsRequest.source = start
        directionsRequest.destination = destination
        
        //        print(" In calculating route CallOutView")
        
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
