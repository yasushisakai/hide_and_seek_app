//
//  ViewController.swift
//  HackBikeApp
//
//  Created by Yasushi Sakai on 2/22/19.
//  Copyright © 2019 Yasushi Sakai. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, LocationPermissionDelegate, LocationDelegate{

    @IBOutlet weak var locationButton: UIButton!
    
    lazy var locationManager = {
        LocationManager(permissionDelegate: self, locationDelegate: self)
    }()
    
    var trip: Trip?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try locationManager.requestAuthorization()
        } catch let error {
            print("error: \(error)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func requestLocation(){
        locationManager.requestLocation()
    }
    
    @objc func toggleUpdatingLocation(){
        locationManager.toggleUpdate()
        if locationManager.isUpdating {
            // reset the trip
            trip = Trip(started: Date())
            locationButton.setTitle("stop recording", for: .normal)
        } else {
            // save the trip to a file
            if let trip = trip {
                let fileName = "trip_\(trip.started.epoch()).csv"
                do {
                    try FileWriter.write(to: fileName, contents: trip.breadCrumbString())
                } catch let error {
                    fatalError(error.localizedDescription)
                }
            }
            locationButton.setTitle("start recording", for: .normal)
        }
    }
    
    // MARK: - Location Permission Delegate Function
    func authGranted() {
        locationButton.isEnabled = true
        locationButton.addTarget(self, action: #selector(ViewController.toggleUpdatingLocation), for:.touchUpInside)
        locationButton.setTitle("start recording", for: .normal)
    }
    
    func authFailed(with status: CLAuthorizationStatus) {
        switch status {
            case .denied : print("user denied location authorization")
            default : print("authorization status: \(status)")
        }
    }
    
    // MARK: - Location Delegate Function
    func obtainedLocation(_ location: Location) {
        trip?.append(breadCrumb: location)
    }
    
    func failedWithError(_ error: LocationError) {
        fatalError("Location Error: \(error)")
    }
    
    
    // MARK: Background Foreground toggle
    func toBackground() {
        locationManager.toBackground()
    }
    
    func toForeground() {
        locationManager.toForeground()
    }
    
}

