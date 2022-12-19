//
//  DestinationInfoView.swift
//  MapTestBed
//
//  Created by Joseph Jung on 12/19/22.
//

import SwiftUI
import AVFoundation

// MARK: - View for Destination Information

struct DestinationInfoView: View {
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var locationManager: LocationManager
    
    @Binding var showDestinationInfoView: Bool
    
    var enteringRegion: Int
    var exitingRegion: Int
    
    var speechsynthesizer = AVSpeechSynthesizer()
    
    var destinationInfoVM = DestinationInfoViewModel()
    
    var body: some View {
        let timeFormatter = TimeFormatter()
        
        VStack{
            
            //            if !appState.routes.isEmpty{
            //                Button(action: {
            //
            //                    showNavigationView.toggle()
            ////                   // DispatchQueue.main.async {
            ////                    speakNextInstruction(speech:speechsynthesizer, step: appState.routeSteps[0])
            ////                    //}
            //
            //                }, label: {
            //                    if !showNavigationView {
            //                        Text("Start Navigate")
            //                    } else {
            //                        Text("Stop Navigation")
            //                    }
            //
            //                })
            //                .textFieldStyle(RoundedBorderTextFieldStyle())
            //                .background(Color.blue)
            //                .foregroundColor(.white)
            //                .cornerRadius(5)
            //                .shadow(radius: 10)
            //            }
            
            //            if !appState.destinationLandmarks.isEmpty && showNavigationView{
            
            if !appState.destinationLandmarks.isEmpty {
                
                
                
                let timeFormatter = TimeFormatter()
                
                if appState.travelTime[0] != nil {
                    
                    
                    VStack{
                        Text("\(appState.destinationLandmarks[0]?.title ?? "")")
                        
                        Text("Travel Time: \(timeFormatter.expectedTravelTimeString(expectedTravelTime: appState.travelTime[0]!))")
                        Text("Arrival Time: \(timeFormatter.expectedArrivalTimeString(expectedTravelTime: appState.travelTime[0]!))")
                    }
                }
                
            }
            
        }
    }
}

struct DestinationInfoView_Previews: PreviewProvider {
    static var previews: some View {
        DestinationInfoView(showDestinationInfoView: .constant(false), enteringRegion: 0, exitingRegion: 0)
    }
}
                    
            //        var message:String = ""
            //        var travelTime = ""
            //        var arrivalTime = ""
//                    VStack{
//
//                        if !appState.routes.isEmpty{
//                            Button(action: {
//
//                                showNavigationView.toggle()
//            //                   // DispatchQueue.main.async {
//            //                    speakNextInstruction(speech:speechsynthesizer, step: appState.routeSteps[0])
//            //                    //}
//
//                            }, label: {
//                                if !showNavigationView {
//                                    Text("Start Navigate")
//                                } else {
//                                    Text("Stop Navigation")
//                                }
//
//                            })
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                            .background(Color.blue)
//                            .foregroundColor(.white)
//                            .cornerRadius(5)
//                            .shadow(radius: 10)
//                        }
//
//                        if !appState.destinationLandmarks.isEmpty && showNavigationView{
//
//
//
//                            if !appState.routes.isEmpty{
//
//
//                                HStack{
//                                    Image(systemName: appState.routeSteps[enteringRegion].imageName!)
//                                    Text("\(appState.routeSteps[enteringRegion].distance!)")
//                                    Text("\(appState.routeSteps[enteringRegion].instructions!) ")
//                                        .onChange(of: enteringRegion, perform: {_ in
//
//
//                                                print("onRecieve")
//                                                print("region \(enteringRegion)")
//                                                print("\(appState.routeSteps[enteringRegion])")
//
//                                                DispatchQueue.main.async {
//                                                    self.speakNextInstruction(speech: speechsynthesizer, step: appState.routeSteps[enteringRegion])
//                                                }
//            //                                }
//
//                                        })
//
//                                }
//
//
//                        }
//
//
//                    }
//                }
 
//            }


                
//                if !appState.routes.isEmpty{
//
//
//                    HStack{
//                        Image(systemName: appState.routeSteps[enteringRegion].imageName!)
//                        Text("\(appState.routeSteps[enteringRegion].distance!)")
//                        Text("\(appState.routeSteps[enteringRegion].instructions!) ")
//                            .onChange(of: enteringRegion, perform: {_ in
//
//
//                                    print("onRecieve")
//                                    print("region \(enteringRegion)")
//                                    print("\(appState.routeSteps[enteringRegion])")
//
//                                    DispatchQueue.main.async {
//                                        self.speakNextInstruction(speech: speechsynthesizer, step: appState.routeSteps[enteringRegion])
//                                    }
////                                }
//
//                            })
//
//                    }
//
//
//
//
//
//            }
            
        
//        }
//    }
//    func speakNextInstruction(speech: AVSpeechSynthesizer, step: RouteStep){
//    //        let speechsynthesizer = AVSpeechSynthesizer()
//        print("from button")
//        let message = "In \(step.distance ?? "0") \(step.instructions ?? "0")"
//        print("message: \(message)")
//        let speechUtterance = AVSpeechUtterance(string: message)
//        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
//        speech.speak(AVSpeechUtterance(string: message))
//    }
        




//struct DestinationInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        DestinationInfoView(enter)
//    }
//}
