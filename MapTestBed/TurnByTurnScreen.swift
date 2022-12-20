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
    @State var showTurnByTurnInstructionsView: Bool = false
    
    @State var speakStepNumber: Int  = 0
    @State var instructionsStepNumber: Int = 0
    @State var arrival: Bool = false
    
//    var enteringRegion: Int
//    var exitingRegion: Int
   
    var body: some View {
        

        
        let speechsynthesizer = AVSpeechSynthesizer()

        
        VStack{
            /*
             Text("User Location")
             Text("Lat: \(locationManager.location?.coordinate.latitude ?? CLLocation(latitude:0.0 , longitude: 0.0).coordinate.latitude)")
             Text("Lon: \(locationManager.location?.coordinate.longitude ?? CLLocation(latitude:0.0 , longitude: 0.0).coordinate.longitude)")
             */
            //            regionIn = locationManager.enteringRegion
            
            
            /*
             
             Text("Entering Region: \(locationManager.enteringRegion )")
             Text("Exiting Region: \(locationManager.exitingRegion )")
             Text("Region: \(locationManager.enteringRegion)")
             
             */
            
            
            if !appState.routes.isEmpty{
                Button(action: {
                    
                    showTurnByTurnInstructionsView.toggle()
                    
                    //                   // DispatchQueue.main.async {
                    //                    speakNextInstruction(speech:speechsynthesizer, step: appState.routeSteps[0])
                    //                    //}
                    
                }, label: {
                    if !showTurnByTurnInstructionsView {
                        Text("Start Navigation")
                    } else {
                        Text("Stop Navigation")
                    }
                    
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(5)
                .shadow(radius: 10)
            
            
            if showTurnByTurnInstructionsView {
                TurnInstructionsView(stepNumber: instructionsStepNumber,arrival: arrival)
                    .onReceive(locationManager.$enteringRegion){region in
                        
                        if  let index = Int(region)  {
                            print("onReceiveInTByTScreen entering Region: \(index)")
//                            speakStepNumber = 0
//                            instructionsStepNumber = 0
                            
                            if index != 0 {
                                speakStepNumber = index
                                arrival = false
                                if index == appState.routeSteps.count { // arrival
                                    instructionsStepNumber = index - 1
                                    arrival = true
                                }
                            }
                            //                                print("index \(index)")
                            //                                print("\(appState.routeSteps[index])")
                            
                            //                                DispatchQueue.main.async {
                            //                                    self.speakNextInstruction(speech: speechsynthesizer, step: appState.routeSteps[index])
                            //                                }
                        }
                    }
                
                    .onReceive(locationManager.$exitingRegion){region in
                        
                        if  let index = Int(region)  {
                            print("onReceiveInTByTScreen exiting Region: \(index)")
                            if index != 0 {
                                instructionsStepNumber = index
                            }
                            //                                print("index \(index)")
                            //                                print("\(appState.routeSteps[index])")
                            
                            //                                DispatchQueue.main.async {
                            //                                    self.speakNextInstruction(speech: speechsynthesizer, step: appState.routeSteps[index])
                            //                                }
                        }
                    }
            }
            
            
            if !appState.routes.isEmpty {
                DestinationInfoView()
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
        print("in speak - onReceive InTByT")
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

