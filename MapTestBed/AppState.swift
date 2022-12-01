//
//  AppState.swift
//  POIRouter
//
//  Created by Joseph Jung on 9/8/22.
//

import Foundation
import MapKit
import SwiftUI

class AppState: ObservableObject {
    @Published var landmarks: [LandmarkAnnotation] = []
    @Published var selectedLandmark: LandmarkAnnotation?
    @Published var route: MKRoute?
    @Published var routeSteps: [RouteStep] = []
    @Published var routes: [MKRoute?] = []
    @Published var destinationLandmarks: [LandmarkAnnotation?] = []

    @Published var categoryOfInterest: String?
    @Published var startLocation: LandmarkAnnotation?
    @Published var startLocationType: String = "currentLocation"

    @Published var homeLocation: LandmarkAnnotation? 
    @Published var selectedStartLocation: LandmarkAnnotation?

    @Published var map = MKMapView()
    

    
//    init(){
//        if let tempData =  UserDefaults.standard.data(forKey: "homeLocation") {
//            do {
////                if let tempData2:LandmarkAnnotation = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(self.homeLocation?) as? LandmarkAnnotation {
////                    self.homeLocation = tempData2
////                let temp = try NSKeyedUnarchiver.unarchivedObject(ofClass: LandmarkAnnotation.self, from: tempData) {
////                    self.homeLocation = temp
////                }
//
//            } catch {
//                print(" Can't get data back")
//            }
//        }
//        https://stackoverflow.com/questions/56463518/how-to-save-an-array-of-type-mkmapitem
//        if let data = defaults("homeLocation") {
//            if let arr = (((NSKeyedUnarchiver.unarchiveObject(with:data)) != nil) is MKMapItem) != nil {
//                print("got the data!")
//            }
//            if let data = NSKeyedUnarchiver.unarchiveObject(with:data) is MKMapItem {
//                print("got the data!")
//            }
        //        if homeLocation != nil {
        //            self.homeLocation = homeLocation
        //            print("Retrieving homeLocation from UserDefaults")
        //        }
        

    }



struct RouteStep: Hashable {
    var id = UUID()
    var imageName: String?
    var instructions: String?
    var distance: String?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
