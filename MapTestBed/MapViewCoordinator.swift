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
import AVFoundation

final class MapViewCoordinator: NSObject, MKMapViewDelegate{
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var settings: Settings
    
    @State var speechsynthesizer = AVSpeechSynthesizer()

    
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
        snapshotter.start { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                print(error as Any)
                return
            }
            //MARK: - ADD PIN TO ANNOTATION LOCATION
            // https://stackoverflow.com/questions/49136068/draw-mkpointannotation-with-title-in-mksnapshot-image
            
            let customPin = UIImage(systemName: "mappin.and.ellipse")?.withTintColor(.red,renderingMode: .alwaysOriginal)
            
            
            UIGraphicsBeginImageContextWithOptions(snapshot.image.size, true, snapshot.image.scale)
            snapshot.image.draw(at: CGPoint.zero)
            let point:CGPoint = snapshot.point(for: annotation.coordinate)
            if let customPin = customPin {
                self.drawPin(point: point, customPin: customPin)
            }
            if let title = annotation.title {
                self.drawTitle(title: title, at: point, attributes: self.titleAttributes())
            }
            let compositeImage = UIGraphicsGetImageFromCurrentImageContext()
            let imageView = UIImageView(frame: CGRect(x:0, y: 0, width: 100, height: 75)) // save Original code <-
            
            imageView.image = compositeImage
            
            //            DispatchQueue.main.async { // put on the main queue
            
            
            //                imageView.image = snapshot.image // <- original code
            
            // customView = CallOutView is a SwiftUI View
            
            let customView = CallOutView(mapView: mapView,selectedAnnotation: annotation,snapShot: imageView.image, annotationView: view)
            
            //                                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            //                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            let callout = MapCalloutView(rootView: AnyView(customView))
            view.detailCalloutAccessoryView = callout
            //                }
        }
        
        
        
        
        
    }
    
    //        MARK: - viewFor annotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        
        if annotation.title == "Home" {
            let annotationView = MKMarkerAnnotationView()
            annotationView.glyphImage = UIImage(systemName: "house.circle")
            annotationView.glyphTintColor = .blue
            annotationView.markerTintColor = .red
            annotationView.displayPriority = .required
            return annotationView
            
        } else if annotation.title == "SelectedStartLocation"{
            let annotationView = MKMarkerAnnotationView()
            annotationView.displayPriority = .required
            annotationView.glyphTintColor = .blue
            annotationView.markerTintColor = .green
            return annotationView
            
        } else if annotation.title != "My Location"{
            let annotationView = MKMarkerAnnotationView()
            // set display Priority to .required
            annotationView.displayPriority = .required
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
    
    
    //MARK: - HELPER FUNCTIONS
    
    private func drawTitle(title: String,
                           at point: CGPoint,
                           attributes: [NSAttributedString.Key: NSObject]) {
        let titleSize = title.size(withAttributes: attributes)
        title.draw(with: CGRect(
            x: point.x - titleSize.width / 2.0,
            y: point.y + 1,
            width: titleSize.width,
            height: titleSize.height),
                   options: .usesLineFragmentOrigin,
                   attributes: attributes,
                   context: nil)
    }
    
    private func titleAttributes() -> [NSAttributedString.Key: NSObject] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let titleFont = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.semibold)
        let attrs = [NSAttributedString.Key.font: titleFont,
                     NSAttributedString.Key.paragraphStyle: paragraphStyle]
        return attrs
    }
    
    private func drawPin(point: CGPoint, customPin: UIImage) {
        let pinPoint = CGPoint(
            x: point.x - customPin.size.width / 2.0,
            y: point.y - customPin.size.height)
        customPin.draw(at: pinPoint)
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
//                       // speech test
//        
//                            let initialMessage = "turn here, then turn there"
//                            let speechUtterance = AVSpeechUtterance(string: initialMessage)
//                            speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
//                            speechsynthesizer.speak(speechUtterance)
    }
}



