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
    
//    lazy var locationManager = {
//        return LocationManager(permissionDelegate: self)
//    }()
    
    lazy var locationManager = {
        LocationManager(permissionDelegate: self, locationDelegate: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        do {
            try locationManager.requestAuthorization()
        } catch let error {
            print("error: \(error)")
        }
        
        // trying to write to a file
        
        let file = FileWriter(fileName: "test.csv")
        do {
            try file.writeLines(contents: ["data, data", "test, data"], to: .Documents)
        } catch let error{
            print("error: \(error.localizedDescription)")
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
            locationButton.setTitle("stop recording", for: .normal)
        } else {
            locationButton.setTitle("start recording", for: .normal)
        }
    }
    
    // MARK: - Location Permission Delegate
    func authGranted() {
        
        locationButton.isEnabled = true
        locationButton.addTarget(self, action: #selector(ViewController.toggleUpdatingLocation), for:.touchUpInside)
        
        locationButton.setTitle("start recording", for: .normal)
    }
    
    func authFailed(with status: CLAuthorizationStatus) {
        // locationButton.isEnabled = false;
        switch status {
            case .denied : print("user denied location authorization")
            default : print("authorization status: \(status)")
        }
    }
    
    // MARK: - Location Delegate
    func obtainedBreadCrumbs(_ breadcrumb: BreadCrumb) {
        // TODO: communicate to the user that we are getting breadcrumbs
    }
    
    func failedWithError(_ error: LocationError) {
        print(":( \(error)")
    }
    
}

