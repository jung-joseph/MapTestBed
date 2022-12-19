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
    var enteringRegion: Int
    var exitingRegion: Int
    let speechsynthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
    
    var body: some View {
        //        if !appState.routes.isEmpty{
        
        
        HStack{
            Image(systemName: appState.routeSteps[enteringRegion].imageName!)
            Text("\(appState.routeSteps[enteringRegion].distance!)")
            Text("\(appState.routeSteps[enteringRegion].instructions!) ")
                .onChange(of: enteringRegion, perform: {_ in
                    
                    
                    print("onRecieve")
                    print("region \(enteringRegion)")
                    print("\(appState.routeSteps[enteringRegion])")
                    
                    DispatchQueue.main.async {
                        self.speakNextInstruction(speech: speechsynthesizer, step: appState.routeSteps[enteringRegion])
                    }
                                       
                })

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
        TurnInstructionsView(enteringRegion: 0, exitingRegion: 0)
    }
}
