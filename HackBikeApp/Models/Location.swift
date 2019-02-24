//
//  Breadcrumb.swift
//  HackBikeApp
//
//  Created by Yasushi Sakai on 2/24/19.
//  Copyright © 2019 Yasushi Sakai. All rights reserved.
//

import Foundation
import CoreLocation

struct Location {
    let latitude: Double
    let longitude: Double
    let timestamp: Date
}

extension Location: CustomStringConvertible{
    
    var description: String {
        return "\(timestamp.epoch()) @ lat: \(latitude), lng:\(longitude)"
    }
    
    init(at location: CLLocation){
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        self.timestamp = location.timestamp
    }
}

extension Date {
    func epoch() -> Int {
        return Int(self.timeIntervalSince1970)
    }
}
