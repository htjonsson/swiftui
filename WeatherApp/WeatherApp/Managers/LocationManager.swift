//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Hordur Thor Jonsson on 25/03/2024.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    // Creating an instance of CLLocationManager, the framework we use to get the coordinates
    let manager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D?
    @Published var isLoading = false
    @Published var authorizationStatus: CLAuthorizationStatus?
    
    override init() {
        super.init()
        
        // Assigning a delegate to our CLLocationManager instance
        manager.delegate = self
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch(manager.authorizationStatus) {
            case .authorizedWhenInUse:  // Location services are available.
                // Insert code here of what should happen when Location services are authorized
                authorizationStatus = .authorizedWhenInUse
                manager.requestLocation()
                break
                
            case .restricted, .denied:  // Location services currently unavailable.
                // Insert code here of what should happen when Location services are NOT authorized
                authorizationStatus = .denied
                break
                
            case .notDetermined:        // Authorization not determined yet.
                manager.requestWhenInUseAuthorization()
                authorizationStatus = .notDetermined
                break
                
            default:
                break
        }
    }
    
    // Requests the one-time delivery of the user’s current location, see https://developer.apple.com/documentation/corelocation/cllocationmanager/1620548-requestlocation
    func requestLocation() {
        isLoading = true
        manager.requestLocation()
    }
    
    // Set the location coordinates to the location variable
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
        isLoading = false
    }
    
    
    // This function will be called if we run into an error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location", error)
        isLoading = false
    }
}
