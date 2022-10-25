//
//  MapViewCoordinator.swift
//  MapTestBed
//
//  Created by Joseph Jung on 9/18/22.
//

import Foundation
import MapKit
import SwiftUI
import UIKit

final class MapViewCoordinator: NSObject, MKMapViewDelegate{
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var locationManager: LocationManager
    
    
    //    var parent: MapView
    //
    //    init(_ parent: MapView) {
    //        self.parent = parent
    //    }
    
    // MARK: - mapViewDidChangeVisibleRegion
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        
        print("ChangeVisibleRegion: \(mapView.centerCoordinate)")
        
    }
    
    //MARK: - didSelect view
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        print("in Did Select ")
        
        // Create SwiftUI callout for this annotation
        guard let annotation = view.annotation as? LandmarkAnnotation else {
            return
        }
        print("annotationTitle: \(String(describing: annotation.title))")
        print("annotationAddress: \(String(describing: annotation.address))")
        print("annotationCoordinates: \(annotation.coordinate)")
        
//        let start = MKMapItem(placemark: MKPlacemark(coordinate: mapView.userLocation.coordinate) )
        let start = MKMapItem.forCurrentLocation()
        print("coordinates: \(start.placemark.coordinate)")
        print("currentLocation: \(start)")
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: annotation.coordinate ) )
        print("destination: \(destination)")
        
        
        view.canShowCallout = true
        
        let options = MKMapSnapshotter.Options()
        let size = 250.0
        options.size = CGSize(width: size, height: size/2)
        options.showsBuildings = true
        options.mapType = .hybrid
        options.camera = MKMapCamera(lookingAtCenter: annotation.coordinate, fromDistance: 500, pitch: 65, heading: 0)
        let snapshotter = MKMapSnapshotter(options: options)
        
//        DispatchQueue.main.async {
            snapshotter.start { snapshot, error in
                guard let snapshot = snapshot, error == nil else {
                    print(error as Any)
                    return
                }
                
                
                
            DispatchQueue.main.async {
                let imageView = UIImageView(frame: CGRect(x:0, y: 0, width: 100, height: 100))
                imageView.image = snapshot.image
                                let customView = CallOutView(mapView: mapView,selectedAnnotation: annotation,snapShot: imageView.image)
                //                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                let callout = MapCalloutView(rootView: AnyView(customView))
                view.detailCalloutAccessoryView = callout
            }
        }
        
        
        // construct route
        
        
        
//        self.calculateRoute(start: start, destination: destination) { route in
//            if let route = route {
//                print("Calculating Route inside didSelect")
//                print("start: \(start)")
//                print("destination: \(destination)")
//
////                view.detailCalloutAccessoryView = nil
//                
//                let controller = RouteContentViewController(route: route)
//                let routePopover = RoutePopover(controller: controller)
//                
//                let positioningView = UIView(frame: CGRect(x: mapView.frame.width/2.6, y:0, width:
//                                                            mapView.frame.width/2, height: 0.0))
//                
//                //                    view.autoresizesSubviews = true
//                
//                mapView.addSubview(positioningView)
//                
//                // clear all annotations
////                mapView.removeAnnotations(mapView.annotations)
//                //
//                
//                
////                mapView.addAnnotation(annotation)
//                // clear all overlays
//                mapView.removeOverlays(mapView.overlays)
//                
//                // add overlay on the map
//                mapView.addOverlay(route.polyline, level: .aboveRoads)
//                //                    routePopover.show(relativeTo: positioningView.frame, of: positioningView, preferredEdge: .minY)
//                
//                routePopover.show(routePopover, sender: self)
//                
//                // let
//            }
//            
//        }
        
        
    }
    
    //    MARK: - viewFor annotation
    //    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
  
    //    }
    
    
    //MARK: - didUpdate userLocation
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        //        let tempCoord = CLLocationCoordinate2D(latitude: 35.16444, longitude: -106.511666)
        
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        mapView.setRegion(region, animated: true)
    }
    
    
    //    MARK: - calloutAccessoryControlTapped
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("CallOut control tapped")
        
       
        guard let name = view.annotation else {return}
//        let name = view.annotation
        print("Callout \(String(describing: name.title)) tapped")
        
        
//        let landmarkCalloutView = LandmarkCalloutView(annotation: name, selectShowDirections: <#T##(LandmarkAnnotation) -> Void#>)
        
        
        let currentPlaceCoordinate = (view.annotation?.coordinate)!
        
        let start = MKMapItem.forCurrentLocation()
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: currentPlaceCoordinate))
        
        self.calculateRoute(start: start, destination: destination) {route in
            if let route = route {
                
                view.detailCalloutAccessoryView = nil
                
                let controller = RouteContentViewController(route: route)
                let routePopover = RoutePopover(controller: controller)
                
                let positioningView = UIView(frame: CGRect(x: mapView.frame.width/2.6, y:0, width:
                                                            mapView.frame.width/2, height: 0.0))
//                    view.autoresizesSubviews = true

                mapView.addSubview(positioningView)
                
                // clear all annotations
                mapView.removeAnnotations(mapView.annotations)
                // clear all overlays
                mapView.removeOverlays(mapView.overlays)
                
                // add overlay on the map
                mapView.addOverlay(route.polyline, level: .aboveRoads)
//                    routePopover.show(relativeTo: positioningView.frame, of: positioningView, preferredEdge: .minY)
                
                routePopover.show(routePopover, sender: self)
                print("Exiting calloutAccessoryControlTapped")
                
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
    
    // MARK: - renderFor overlay
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.lineWidth = 5.0
        renderer.strokeColor = .blue
        return renderer
    }
    

}
