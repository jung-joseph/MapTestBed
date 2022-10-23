//
//  Measurement+Extensions.swift
//  MapsMacOS
//
//  Created by Joseph Jung on 8/6/22.
//

import Foundation
import CoreLocation

enum DisplayDistanceUnit {
    case feet
    case meters
    case miles
    case kilometers
}
extension Measurement where UnitType: UnitLength {
    
    func displayDistance(_ units: DisplayDistanceUnit) -> String {
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        
        switch unit {
            case .feet, .meters:
                formatter.numberFormatter.maximumFractionDigits = 0
            case .miles, .kilometers:
                formatter.numberFormatter.maximumFractionDigits = 1
            default:
                formatter.numberFormatter.maximumFractionDigits = 0

        }
        return formatter.string(from: self)
    }
    
//    var distanceToDisplay: String {
//        let formatter = MeasurementFormatter()
//        formatter.unitOptions = .providedUnit
//        formatter.numberFormatter.maximumFractionDigits = 0
//        return formatter.string(from: self)
//    }
    
}

extension CLLocationDistance {
    
    func toFeet() -> Measurement<UnitLength> {
        let valueInMeters = Measurement(value: self, unit: UnitLength.meters)
        return valueInMeters.converted(to: .feet)
    }
    func toMeters() -> Measurement<UnitLength> {
        let valueInMeters = Measurement(value: self, unit: UnitLength.meters)
        return valueInMeters
    }
    func toMiles() -> Measurement<UnitLength> {
        let valueInMeters = Measurement(value: self, unit: UnitLength.meters)
        return valueInMeters.converted(to: .miles)
    }
    func toKms() -> Measurement<UnitLength> {
        let valueInMeters = Measurement(value: self, unit: UnitLength.meters)
        return valueInMeters.converted(to: .kilometers)
    }
}
