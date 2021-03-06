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
var earthquakeOver: Bool = false
var currentLocation: [Double] = []
var peopleStatus: AnyObject!

class LocationServices: CLLocationManager, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    let notificationCenter = NSNotificationCenter.defaultCenter()
    
    var counter = 0
    
    func initialize() {
        setUpNotifications()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
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
        setEarthquakeNotifications = false
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation.removeAll()
        currentLocation.append((locations.last?.coordinate.latitude)!)
        currentLocation.append((locations.last?.coordinate.longitude)!)
        counter += 1
        
        if (counter%5 == 0) {
            checkForEarthquake()
            getPeople()
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
        var flag: Bool = false
        
        if response! == "True" {
            flag = true
        } else {
            flag = false
        }
        
        if (flag) {
            // Send the notification
            if (!setEarthquakeNotifications) {
                
                if let notificationSettings = UIApplication.sharedApplication().currentUserNotificationSettings() {
                    if notificationSettings.types.contains([.Alert, .Badge]) {
                        // Have full notification access
                        let localNotification = UILocalNotification()
                        localNotification.fireDate = NSDate(timeIntervalSinceNow: 0)
                        localNotification.alertTitle = "Earthquake Alert"
                        localNotification.alertBody = "Earthquake detected in your area. Slide to update your status."
                        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
                        setEarthquakeNotifications = true
                        earthquakeOver = false
                        defaults.setBool(setEarthquakeNotifications, forKey: "EarthquakeStatus")
                        notificationCenter.postNotificationName("HideNoAlert", object: nil)
                    } else {
                        // Don't have full authorization, need to figure out what to do here
                    }
                }
            }
        } else {
            if !earthquakeOver {
                notificationCenter.postNotificationName("EarthquakeEnd", object: nil)
                setEarthquakeNotifications = false
                earthquakeOver = true
            }
        }
    }
    
    func getPeople() {
        // FUCK
        let url = "http://waterloo.matthewgougeon.me:1801/getPeople"
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if error == nil {
                self.parseJSONResponse(data!)
            } else {
                // TODO: Deal with the Error of the user not having a data connection or the server being down
                
            }
        })
        task.resume()
    }
    
    private func parseJSONResponse(data: NSData) {
        let options:NSJSONReadingOptions = [.AllowFragments]
        var json: AnyObject!
        do {
            json = try NSJSONSerialization.JSONObjectWithData(data, options: options)
        } catch {
            return
        }
        let obj = json as! NSArray
        peopleStatus = obj
    }
}
