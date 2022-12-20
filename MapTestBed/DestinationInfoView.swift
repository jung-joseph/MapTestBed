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
    
    
    
    var speechsynthesizer = AVSpeechSynthesizer()
    
    var destinationInfoVM = DestinationInfoViewModel()
    
    var body: some View {
        
        VStack{
            
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

struct DestinationInfoView_Previews: PreviewProvider {
    static var previews: some View {
        DestinationInfoView()
    }
}


