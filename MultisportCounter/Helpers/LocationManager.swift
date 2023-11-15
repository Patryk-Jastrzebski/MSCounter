//
//  LocationManager.swift
//  MultisportCounter
//
//  Created by Patryk Jastrzębski on 12/11/2023.
//

import Foundation
import MapKit

class LocationManager: NSObject, ObservableObject {
    @Published var userLocation: UserLocation?
    
    var location: CLLocation?
    var geoCoder = CLGeocoder()
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    fileprivate func saveLocation() {
        guard let location else { return }
        geoCoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self,
                    let placeMark = placemarks?.first,
                    let street = placeMark.thoroughfare,
                    let city = placeMark.locality else {
                return
            }
            
            self.userLocation = UserLocation(city: city,
                                             street: street,
                                             lon: location.coordinate.longitude,
                                             lat: location.coordinate.latitude)
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last, self.location == nil else { return }
        self.location = location
        self.saveLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("notDetermined")
            manager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
}
