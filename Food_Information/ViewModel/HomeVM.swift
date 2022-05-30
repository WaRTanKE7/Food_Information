//
//  HomeVM.swift
//  Food_Information
//
//  Created by E7 on 2022/5/24.
//

import SwiftUI
//import MapKit
import CoreLocation

class HomeVM: ObservableObject {
    @Published var noLocationAuthorization: Bool = false
    
    let locationManager = CLLocationManager()
    
    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            noLocationAuthorization = false
        case .restricted, .denied:
            noLocationAuthorization = true
        default:
            noLocationAuthorization = false
        }
    }
    
    func getCurrentLocation() {
        
    }
    
    func searchNearbyPlace(withKeyword keyword: String) {
        
    }
    
}
