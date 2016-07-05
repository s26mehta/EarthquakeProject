//
//  LocationServices.swift
//  Loc8r
//
//  Created by Nehal Kanetkar on 2016-07-04.
//  Copyright © 2016 SYDE361. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

class LocationServices: CLLocationManager, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    let notificationCenter = NSNotificationCenter.defaultCenter()
    
    func initialize() {
        setUpNotifications()
        locationManager.delegate = self
    }
    
    func setUpNotifications() {
        notificationCenter.addObserver(self, selector:#selector(LocationServices.requestAuthorization), name: "RequestAuthorization", object: nil)
        notificationCenter.addObserver(self, selector:#selector(LocationServices.startUpdating), name: "StartUpdating", object: nil)
    }
    
    @objc func requestAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }
    
    @objc func startUpdating() {
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Updating locationManager")
    }
}
