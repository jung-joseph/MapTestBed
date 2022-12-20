//
//  TurnInstructionsView.swift
//  MapTestBed
//
//  Created by Joseph Jung on 12/19/22.
//

import SwiftUI
import AVFoundation

struct TurnInstructionsView: View {
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var locationManager: LocationManager

    var stepNumber: Int
    var arrival: Bool
    
    let speechsynthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
    
    var body: some View {
        //        if !appState.routes.isEmpty{
        
        
        if !appState.routeSteps.isEmpty{
            HStack{
                if !arrival { // general case
                    Image(systemName: appState.routeSteps[stepNumber].imageName!)
                    Text("\(appState.routeSteps[stepNumber].distance!)")
                    Text("\(appState.routeSteps[stepNumber].instructions!) ")
                } else { // arrival
                    Image(systemName: appState.routeSteps[stepNumber].imageName!)
                    Text("\(appState.routeSteps[stepNumber].instructions!) ")

                }
            }
        }
    }
    
        func speakNextInstruction(speech: AVSpeechSynthesizer, step: RouteStep){
        //        let speechsynthesizer = AVSpeechSynthesizer()
            print("from button")
            let message = "In \(step.distance ?? "0") \(step.instructions ?? "0")"
            print("message: \(message)")
            let speechUtterance = AVSpeechUtterance(string: message)
            speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
            speech.speak(AVSpeechUtterance(string: message))
        }
    
}
    
struct TurnInstructionsView_Previews: PreviewProvider {
    static var previews: some View {
        TurnInstructionsView(stepNumber: 0, arrival: false)
    }
}
