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
    
    @EnvironmentObject var appState: AppState
    
    var distanceFormatter = DistanceFormatter()

    var body: some View {
        VStack{
            HStack{
                Button(action:
                {
                    print("In CallOutView")
                    print("Selected Annotation: \(String(describing: selectedAnnotation.title))")
                    let start = MKMapItem.forCurrentLocation()
                    let destination = MKMapItem(placemark: MKPlacemark(coordinate: selectedAnnotation.coordinate ) )
                    print("coordinates: \(start.placemark.coordinate)")
                    print("currentLocation: \(start)")
                    print("destination: \(destination)")

                    self.calculateRoute(start: start, destination: destination) { route in
                        if let route = route {
                            print("Calculating Route inside didSelect")
                            print("start: \(start)")
                            print("destination: \(destination)")

            //                view.detailCalloutAccessoryView = nil
                            
                            let controller = RouteContentViewController(route: route)
                            let routePopover = RoutePopover(controller: controller)
                            
                            let positioningView = UIView(frame: CGRect(x: mapView.frame.width/2.6, y:0, width:
                                                                        mapView.frame.width/2, height: 0.0))
                            
                            //                    view.autoresizesSubviews = true
                            
                            mapView.addSubview(positioningView)
                            
                            // clear all annotations
                            mapView.removeAnnotations(mapView.annotations)
                            //
                            mapView.addAnnotation(selectedAnnotation)
                            
                            // clear all overlays
                            mapView.removeOverlays(mapView.overlays)
                            
                            // add overlay on the map
                            mapView.addOverlay(route.polyline, level: .aboveRoads)
                            //                    routePopover.show(relativeTo: positioningView.frame, of: positioningView, preferredEdge: .minY)
                            
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
                            
                            //
//                            for step in route.steps {
//                                if step.instructions.isEmpty {
//                                    continue
//                                }
//
//                                print(step.instructions)
//                            }
                            
                        }
                        
                    }
//
                },
                       label: {Text("Directions")})
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    .shadow(radius: 10)
                    
                Spacer()
            }
            if (snapShot != nil) {
                Image(uiImage: snapShot! )
            }
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
