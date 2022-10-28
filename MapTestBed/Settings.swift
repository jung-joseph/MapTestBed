//
//  Settings.swift
//  POIRouter
//
//  Created by Joseph Jung on 9/8/22.
//

import Foundation
import SwiftUI

class Settings: ObservableObject {
    
    @Published var isDarkMode: Bool = false
    @Published var distanceUnit: DistanceUnit = .miles
}
