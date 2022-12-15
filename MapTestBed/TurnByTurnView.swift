//
//  TurnByTurnView.swift
//  MapTestBed
//
//  Created by Joseph Jung on 12/12/22.
//

import SwiftUI
import CoreLocation
import MapKit
import AVFoundation

struct TurnByTurnView: View {
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var locationManager: LocationManager
    
    
   
    var body: some View {
        
        
        VStack{
            Text("User Location")
            
//            Text("Lat: \(appState.map.userLocation.coordinate.latitude)")
//            Text("Lon: \(appState.map.userLocation.coordinate.longitude)")
            
            Text("Lat: \(locationManager.location?.coordinate.latitude ?? CLLocation(latitude:0.0 , longitude: 0.0).coordinate.latitude)")
            Text("Lon: \(locationManager.location?.coordinate.longitude ?? CLLocation(latitude:0.0 , longitude: 0.0).coordinate.longitude)")

            Text("Entering Region: \(locationManager.enteringRegion ?? "-1")")
            Text("Exiting Region: \(locationManager.exitingRegion ?? "-1")")

            DestinationInfo()
        }
    }
    
    func getRouteSteps(route: MKRoute) {
        for monitoredRegion in locationManager.locationManager.monitoredRegions {
            locationManager.locationManager.stopMonitoring(for: monitoredRegion)
        }
    }
    
}

struct TurnByTurnView_Previews: PreviewProvider {
    static var previews: some View {
        TurnByTurnView()
    }
}

// MARK: - View for Destination Information

struct DestinationInfo: View {
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var locationManager: LocationManager
    
    @State var showNavigationView: Bool = false
    
    var speechsynthesizer = AVSpeechSynthesizer()
    
    var destinationInfoVM = DestinationInfoViewModel()
    
    var body: some View {
        let timeFormatter = TimeFormatter()
//        var message:String = ""
//        var travelTime = ""
//        var arrivalTime = ""
        VStack{
            
            if !appState.routes.isEmpty{
                Button(action: {

                    showNavigationView.toggle()
                    
                    speakNextInstruction(step: appState.routeSteps[0])


                }, label: {
                    Text("Navigate")

                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(5)
                .shadow(radius: 10)
            }
            
            if !appState.destinationLandmarks.isEmpty && showNavigationView{
                

                
                if !appState.routes.isEmpty{
                    
//                    let instructions = appState.routeSteps[0].instructions!
//
//                    let stepInstructions = appState.routeSteps[0].instructions!
//                    let distanceToNext = appState.routeSteps[0].distance!
//                    message = "In \(distanceToNext) \(stepInstructions)"
//                    message = destinationInfoVM.turnByTurnInstructions(instructions: appState.routeSteps[0].instructions!, stepDistance: appState.routes[0]!.distance)
                    HStack{
                        Image(systemName: appState.routeSteps[0].imageName!)
                        Text("\(appState.routeSteps[0].distance!)")
                        Text("\(appState.routeSteps[0].instructions!) ")
                    }
                    
                    if appState.travelTime[0] != nil {
//                        let expectedTravelTimeInSeconds = appState.travelTime[0]
//                        travelTime = timeFormatter.expectedTravelTimeString(expectedTravelTime: appState.travelTime[0]!)
//                        arrivalTime = timeFormatter.expectedArrivalTimeString(expectedTravelTime: appState.travelTime[0]!)
                        
                        Text("\(appState.destinationLandmarks[0]?.title ?? "")")

                        Text("Travel Time: \(timeFormatter.expectedTravelTimeString(expectedTravelTime: appState.travelTime[0]!))")
                        Text("Arrival Time: \(timeFormatter.expectedArrivalTimeString(expectedTravelTime: appState.travelTime[0]!))")
                    }
                }
                
                
                
            }
            
        
        }
    }
    func speakNextInstruction(step: RouteStep){
//        var speechsynthesizer = AVSpeechSynthesizer()

        let message = "In \(step.distance ?? "0") \(step.instructions ?? "0")"
        let speechUtterance = AVSpeechUtterance(string: message)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        speechsynthesizer.speak(AVSpeechUtterance(string: message))
    }
}

