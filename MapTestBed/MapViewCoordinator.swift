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
    @EnvironmentObject var settings: Settings
    
    

    // MARK: - mapViewDidChangeVisibleRegion
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        
//        print("ChangeVisibleRegion: \(mapView.centerCoordinate)")
        
    }
    
    //MARK: - didSelect view
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        


        // Create SwiftUI callout for this annotation
        guard let annotation = view.annotation as? LandmarkAnnotation else {
            return
        }



        view.canShowCallout = true

        let options = MKMapSnapshotter.Options()
        let size = 250.0
        options.size = CGSize(width: size, height: size/2)
        options.showsBuildings = true
        options.mapType = .standard
        options.camera = MKMapCamera(lookingAtCenter: annotation.coordinate, fromDistance: 500, pitch: 65, heading: 0)
        let snapshotter = MKMapSnapshotter(options: options)

//        DispatchQueue.main.async {
            snapshotter.start { snapshot, error in
                guard let snapshot = snapshot, error == nil else {
                    print(error as Any)
                    return
                }



//            DispatchQueue.main.async {
                let imageView = UIImageView(frame: CGRect(x:0, y: 0, width: 100, height: 75))

//                let imageView = UIImageView(frame: CGRect(x:0, y: 0, width: 100, height: 100))
                imageView.image = snapshot.image
                // customView = CallOutView is a SwiftUI View

                let customView = CallOutView(mapView: mapView,selectedAnnotation: annotation,snapShot: imageView.image, annotationView: view)
                
//                                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)

                let callout = MapCalloutView(rootView: AnyView(customView))
                view.detailCalloutAccessoryView = callout
//            }
        }

        

        
        
    }
    
//        MARK: - viewFor annotation
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    


            if annotation.title == "Home" || annotation.title == "SelectedStartLocation"{
                let annotationView = MKMarkerAnnotationView()
                annotationView.glyphTintColor = .blue
                annotationView.markerTintColor = .green
                return annotationView
            }
            
            return nil
        }
    
    
    //MARK: - didUpdate userLocation
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        //        let tempCoord = CLLocationCoordinate2D(latitude: 35.16444, longitude: -106.511666)
        
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        mapView.setRegion(region, animated: true)
    }
    
    
    //    MARK: - calloutAccessoryControlTapped
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//

    }
    

    
    // MARK: - renderFor overlay
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.lineWidth = 3.0
        renderer.strokeColor = .blue
        return renderer
    }
    
    
//    //MARK: - viewFor overlay
//
//     func mapView(_ mapView: MKMapView, viewFor overlay: MKOverlay) -> MKOverlayRenderer {
//        <#code#>
//    }
    
    
}
