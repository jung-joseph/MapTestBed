//
//  MKTypeExtension.swift
//  MapTestBed
//
//  Created by Joseph Jung on 10/30/22.
//

import MapKit

extension MKMapType {
    var title: String {
        switch self {
        case .satellite:
            return "satellite"
        case .hybrid:
            return "hybrid"
        case .standard:
            return "standard"
        default:
            return "standard"
        }
    }
}
