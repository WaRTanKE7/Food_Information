//
//  TabBarVM.swift
//  Food_Information
//
//  Created by E7 on 2022/5/31.
//

import SwiftUI
import CoreLocation

class TabBarVM: ObservableObject {
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
