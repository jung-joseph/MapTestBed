//
//  MapViewCoordinator.swift
//  MapTestBed
//
//  Created by Joseph Jung on 9/18/22.
//

import Foundation
import MapKit
import SwiftUI

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
        
        let start = MKMapItem(placemark: MKPlacemark(coordinate: mapView.userLocation.coordinate) )
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
        
        
        snapshotter.start { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                print(error as Any)
                return
                
            }
            
            
            
            DispatchQueue.main.async {
                let imageView = UIImageView(frame: CGRect(x:0, y: 0, width: 100, height: 100))
                imageView.image = snapshot.image
                let customView = CallOutView(annotation: annotation,snapShot: imageView.image)
                let callout = MapCalloutView(rootView: AnyView(customView))
                view.detailCalloutAccessoryView = callout
            }
        }
        

        // construct route

        
        
        self?.calculateRoute(start: start, destination: destination) { route in
            if let route = route {

                view.detailCalloutAccessoryView = nil

                let controller = RouteContentViewContoller(route: route)
                let routePopover = RoutePopOver(controller: controller)
            }

        }
        
        
    }
    
    //    MARK: - viewFor annotation
    //    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
    
    //
    //
    //        if let place = annotation.title {
    //            print("place: \(place!)")
    //            if (place == "My Location") {
    //                return nil
    //            }
    //        } else {
    //            print("place is nil")
    //        }
    //
    //
    //        guard let mapPlace = annotation.title else {return nil}
    //        print("mapPlace: \(mapPlace!)")
    //        print("subtitle: \(String(describing: annotation.subtitle))")
    //        // attempt to find a previous used cell
    ////        var view = mapView.dequeueReusableAnnotationView(withIdentifier: (mapPlace!)) as? MKMarkerAnnotationView
    //
    //        if let view = mapView.dequeueReusableAnnotationView(withIdentifier: (mapPlace!)) as? MKMarkerAnnotationView {
    //            print("view for \(mapPlace!) found")
    //            view.annotation = annotation
    //            let view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: (mapPlace!))
    //            view.subtitleVisibility = .visible
    //            view.displayPriority = .required
    //            view.canShowCallout = true
    //            view.titleVisibility = .hidden
    //
    //            let annotation = view.annotation
    //            let callout: MapCalloutView
    //            let customView = CallOutView()
    //            callout = MapCalloutView(rootView: AnyView(customView))
    //            view.detailCalloutAccessoryView = callout
    //
    //            return view
    //
    //        } else {
    //            print("view for \(mapPlace!)  not found")
    //            let view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: (mapPlace!))
    //            view.subtitleVisibility = .visible
    //            view.displayPriority = .required
    //            view.canShowCallout = true
    //            view.titleVisibility = .hidden
    //
    //            let annotation = view.annotation
    //            let callout: MapCalloutView
    //
    //            if (annotation?.subtitle != nil){
    //                let customView = CallOutView()
    //                callout = MapCalloutView(rootView: AnyView(customView))
    //            } else {
    //                let customView = Text("This view passes no title")
    //                callout = MapCalloutView(rootView: AnyView(customView))
    //            }
    //
    //            view.detailCalloutAccessoryView = callout
    //            return view
    //
    //        }
    
    // we didn't find one; make a new cell
    //        if(view == nil) {
    //            let view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: (mapPlace!))
    //            view.subtitleVisibility = .visible
    //            view.displayPriority = .required
    //            view.canShowCallout = true
    //            view.titleVisibility = .hidden
    //
    //            let annotation = view.annotation
    //            let callout: MapCalloutView
    //
    //            if (annotation?.subtitle != nil){
    //                let customView = CallOutView()
    //                callout = MapCalloutView(rootView: AnyView(customView))
    //            } else {
    //                let customView = Text("This view passes no title")
    //                callout = MapCalloutView(rootView: AnyView(customView))
    //            }
    //
    //            view.detailCalloutAccessoryView = callout
    //
    //        } else {
    //            // we have a view to reuse, give it a new annotation
    //            view.annotation = annotation
    //        }
    //        return view
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
    }
    
}
