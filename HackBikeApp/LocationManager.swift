//
//  LocationManager.swift
//  HackBikeApp
//
//  Created by Yasushi Sakai on 2/22/19.
//  Copyright © 2019 Yasushi Sakai. All rights reserved.
//

import Foundation
import CoreLocation

enum LocationError: Error {
    case userDisallowed
    case cannotFindLocation
    case unknown
}

protocol LocationPermissionDelegate: class{
    func authGranted()
    func authFailed(with status: CLAuthorizationStatus)
}

protocol LocationDelegate: class {
    func obtainedBreadCrumbs(_ breadcrumb: BreadCrumb)
    func failedWithError(_ error: LocationError)
}

struct Trip{
    var started: Date?
    var breadCrumbs: [BreadCrumb]
    
    init(){
        self.started = nil
        self.breadCrumbs = []
    }
}

struct BreadCrumb: CustomStringConvertible {

    let latitude: Double
    let longitude: Double
    let timestamp: Date
    
    var description: String {
        let epoch = Int(timestamp.timeIntervalSince1970)
        return "\(epoch) @ lat: \(latitude), lng:\(longitude)"
    }
    
    init(at location: CLLocation){
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        self.timestamp = location.timestamp
    }
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    private let manager = CLLocationManager()
    
    var isUpdating: Bool
    var trip: Trip
    
    weak var permissionDelegate: LocationPermissionDelegate?
    weak var delegate: LocationDelegate?
    
    init(
        permissionDelegate: LocationPermissionDelegate?,
        locationDelegate: LocationDelegate?
        ){
        self.permissionDelegate = permissionDelegate
        self.delegate = locationDelegate
        self.isUpdating = false
        self.trip = Trip()
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.distanceFilter = kCLDistanceFilterNone
    }
    
    static var isAuthorized: Bool {
        switch CLLocationManager.authorizationStatus(){
        case .authorizedWhenInUse: return true
        default: return false
        }
    }
    
    func requestAuthorization() throws {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        
        if authorizationStatus == .restricted || authorizationStatus == .denied {
            throw LocationError.userDisallowed
        } else if (authorizationStatus == .notDetermined) {
            manager.requestWhenInUseAuthorization()
        } else {
            return
        }
    }
    
    func requestLocation() {
        manager.requestLocation()
        // manager.startUpdatingLocation()
    }
    
    func toggleUpdate(){
        if isUpdating {
            manager.stopUpdatingLocation()
            // TODO: send or save the trip to a file
        } else {
            manager.startUpdatingLocation()
            // starting a trip over
            trip = Trip()
        }
        isUpdating = !isUpdating
    }
    
    // MARK: - delagate functions
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            permissionDelegate?.authGranted()
        } else {
            permissionDelegate?.authFailed(with: status)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let error = error as? CLError else {
            delegate?.failedWithError(.unknown)
            return
        }
        
        switch error.code {
        case .locationUnknown, .network:
            delegate?.failedWithError(.cannotFindLocation)
        case .denied:
            delegate?.failedWithError(.userDisallowed)
        default: return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {
            delegate?.failedWithError(.cannotFindLocation)
            return
        }
        
        let breadCrumb = BreadCrumb(at: location)
        
        if trip.started == .none {
                trip.started = breadCrumb.timestamp
        }
        trip.breadCrumbs.append(breadCrumb)
        
        delegate?.obtainedBreadCrumbs(breadCrumb)
    }
}
















