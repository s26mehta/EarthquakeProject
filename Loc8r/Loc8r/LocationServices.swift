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

var setEarthquakeNotifications: Bool = false

class LocationServices: CLLocationManager, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    let notificationCenter = NSNotificationCenter.defaultCenter()
    
    var counter = 0
    
    func initialize() {
        setUpNotifications()
        locationManager.delegate = self
    }
    
    func setUpNotifications() {
        notificationCenter.addObserver(self, selector:#selector(LocationServices.requestAuthorization), name: "RequestAuthorization", object: nil)
        notificationCenter.addObserver(self, selector:#selector(LocationServices.startUpdating), name: "StartUpdating", object: nil)
    }
    
    func requestAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }
    
    func startUpdating() {
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        counter += 1
        
        if (counter%20 == 0) {
            checkForEarthquake()
        }
    }
    
    func checkForEarthquake() {
        let url = "http://waterloo.matthewgougeon.me:1801/isEarthquake"
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if error == nil {
                self.parseResponse(data!)
            } else {
                // TODO: Deal with the Error of the user not having a data connection or the server being down
                
            }
        })
        task.resume()
    }
    
    private func parseResponse(data: NSData) {
        let response = NSString(data: data, encoding: NSUTF8StringEncoding)
        
        if (response == "true" || response == "True") {
            // Send the notification
            if (!setEarthquakeNotifications) {
                if let notificationSettings = UIApplication.sharedApplication().currentUserNotificationSettings() {
                    if notificationSettings.types.contains([.Alert, .Badge]) {
                        // Have full notification access
                        let localNotification = UILocalNotification()
                        localNotification.fireDate = NSDate(timeIntervalSinceNow: 0)
                        localNotification.alertTitle = "Earthquake Alert"
                        localNotification.alertBody = "Earthquake detected in your area. Slide to mark yourself safe."
                        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
                        setEarthquakeNotifications = true
                        notificationCenter.postNotificationName("HideNoAlert", object: nil)
                    } else {
                        // Don't have full authorization, need to figure out what to do here
                    }
                }
            }
        }
    }
}
