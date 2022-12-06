//
//  TimeFormatter.swift
//  MapTestBed
//
//  Created by Joseph Jung on 12/4/22.
//

import Foundation

class TimeFormatter {
    
    func expectedTravelTimeString(expectedTravelTime: TimeInterval ) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: expectedTravelTime) ?? "0 min"
    }
    
    func expectedArrivalTimeString(expectedTravelTime: TimeInterval) -> String {
        
        let now = Date.now
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "hh:mm a" // 12 hour clock
        
        let arrivalTime = now.addingTimeInterval(expectedTravelTime)
        
        return dateFormatter.string(from: arrivalTime)

    }
    
}
