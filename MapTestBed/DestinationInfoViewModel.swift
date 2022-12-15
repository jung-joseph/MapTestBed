//
//  DestinationInfoViewModel.swift
//  MapTestBed
//
//  Created by Joseph Jung on 12/14/22.
//

import Foundation
import MapKit
import SwiftUI


class DestinationInfoViewModel: ObservableObject {
    
    
    init(){}
 
//    @ObservedObject var appState: AppState
    
    func destinationTitle(title: String!) -> String {
        if let title = title {
            return title
        } else {
            return ""
        }
    }
    
    func turnByTurnInstructions(instructions: String!, stepDistance: CLLocationDistance) -> String {
        let distanceFormatter: DistanceFormatter = DistanceFormatter()

        if let instructions = instructions {
            let iconName = directionsIcon(instructions)
            let distance = "\(distanceFormatter.format(distanceInMeters: stepDistance))"
            return " \(iconName) In \(distance) \(instructions)"
        } else {
            return ""
        }
    }
    
    func turnByTurnSpeech(instructions: String!, stepDistance: Double) -> String {
        let distanceFormatter: DistanceFormatter = DistanceFormatter()

        if let instructions = instructions {
//            let iconName = directionsIcon(instructions)
            let distance = "\(distanceFormatter.format(distanceInMeters: stepDistance))"
            return "In \(distance) \(instructions)"
        } else {
            return ""
        }
    }
    
    //MARK: - directionIcons
    private func directionsIcon(_ instruction: String) -> String {
        if instruction.contains("Turn right"){
            return "arrow.turn.up.right"
        } else if instruction.contains("Turn left") {
            return "arrow.turn.up.left"
        } else if instruction.contains("destination") {
            return "mappin.circle.fill"
        } else {
            return "arrow.up"
        }
    }
    
}


