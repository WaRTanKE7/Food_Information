//
//  LocationManager.swift
//  Food_Information
//
//  Created by E7 on 2022/6/8.
//

import SwiftUI
import CoreLocation

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    var manager: CLLocationManager?
    
    @Published var location = CLLocationCoordinate2D(latitude: 121.5234778325681, longitude: 25.04432575514154)
    @Published var noLocationAuthorization: Bool = false
    
    func checkIfLocationServicesIsEnable() {
        if CLLocationManager.locationServicesEnabled() {
            manager = CLLocationManager()
            manager!.delegate = self
        } else {
            
        }
    }
    
    func checkLocationAuthorization() {
        guard let manager = manager else  { return }
        
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            noLocationAuthorization = true
        case .authorizedAlways, .authorizedWhenInUse:
            location = manager.location!.coordinate
            break
        default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
