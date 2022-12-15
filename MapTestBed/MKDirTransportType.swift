//
//  MKDirTransportType.swift
//  MapTestBed
//
//  Created by Joseph Jung on 12/15/22.
//

import MapKit

extension MKDirectionsTransportType: Hashable{
    var title: String {
        switch self {
        case .automobile:
            return "automobile"
        case .walking:
            return "walking"
        case .transit:
            return "transit"
        default:
            return "automobile"
        }
    }
}
