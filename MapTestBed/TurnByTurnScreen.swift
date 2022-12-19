//
//  TurnByTurnScreen.swift
//  MapTestBed
//
//  Created by Joseph Jung on 12/12/22.
//

import SwiftUI
import CoreLocation
import MapKit
import AVFoundation

struct TurnByTurnScreen: View {
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var locationManager: LocationManager
    
    @State var showDestinationInfoView: Bool = false
    @State var showNavigationView: Bool = false
   
    var body: some View {
        

        
        let speechsynthesizer = AVSpeechSynthesizer()

        
        VStack{
            /*
                Text("User Location")
                Text("Lat: \(locationManager.location?.coordinate.latitude ?? CLLocation(latitude:0.0 , longitude: 0.0).coordinate.latitude)")
                Text("Lon: \(locationManager.location?.coordinate.longitude ?? CLLocation(latitude:0.0 , longitude: 0.0).coordinate.longitude)")
             */
//            regionIn = locationManager.enteringRegion

            Text("Entering Region: \(locationManager.enteringRegion )")
            Text("Exiting Region: \(locationManager.exitingRegion )")

            Text("Region: \(locationManager.enteringRegion)")
            
            if !appState.routes.isEmpty {
                DestinationInfoView(showDestinationInfoView: $showDestinationInfoView,enteringRegion: Int(locationManager.enteringRegion)!, exitingRegion: Int(locationManager.exitingRegion)!  )
                    .onReceive(locationManager.$enteringRegion){region in
                        
                        if  let index = Int(region)  {
                            print("onRecieve")
                            print("region \(region)")
                            print("index \(index)")
                            print("\(appState.routeSteps[index])")
                            
                            DispatchQueue.main.async {
                                self.speakNextInstruction(speech: speechsynthesizer, step: appState.routeSteps[index])
                            }
                        }
                      
                    }
                
            }
        }
    }
    
    func getRouteSteps(route: MKRoute) {
        for monitoredRegion in locationManager.locationManager.monitoredRegions {
            locationManager.locationManager.stopMonitoring(for: monitoredRegion)
        }
    }
    func speakNextInstruction(speech: AVSpeechSynthesizer, step: RouteStep){
    //        let speechsynthesizer = AVSpeechSynthesizer()

        let message = "In \(step.distance ?? "0") \(step.instructions ?? "0")"
        print("in speak - onRecieve")
        print("message: \(message)")
        let speechUtterance = AVSpeechUtterance(string: message)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        speech.speak(AVSpeechUtterance(string: message))
    }
}

struct TurnByTurnScreen_Previews: PreviewProvider {
    static var previews: some View {
        TurnByTurnScreen()
    }
}

