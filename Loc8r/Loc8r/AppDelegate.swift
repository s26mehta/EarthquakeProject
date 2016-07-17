//
//  AppDelegate.swift
//  Loc8r
//
//  Created by Nehal Kanetkar on 2016-06-30.
//  Copyright © 2016 SYDE361. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import Contacts

// MARK: Global Variables
var contactList: [String] = []
var firstName: String = ""
var lastName: String = ""
var fullName: String = ""
var groupNames: [String] = []
var groupMembers: [[String]] = []
var groupNameMemberDict: [String:[String]] = [:]
var onboardingComplete: Bool = false
var safetyStatus: String = ""
var safetyLevel: Int = 3
let defaults = NSUserDefaults.standardUserDefaults()

var firstTimeOpenComplete: Bool = false

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    let locationServices = LocationServices()
    let notificationCenter = NSNotificationCenter.defaultCenter()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        locationServices.initialize()
        notificationCenter.addObserver(self, selector:#selector(AppDelegate.getContacts), name: "GetContacts", object: nil)
        
        getData()
        
        if onboardingComplete {
            getContacts()
            print("Getting contacts")
        }
        
        
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert , .Badge], categories: nil))
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        setData()
    }
    
    func getContacts() {
        // make sure user hadn't previously denied access
        
        let status = CNContactStore.authorizationStatusForEntityType(.Contacts)
        if status == .Denied || status == .Restricted {
            // user previously denied, so tell them to fix that in settings
            return
        }
        
        // open it
        
        let store = CNContactStore()
        store.requestAccessForEntityType(.Contacts) { granted, error in
            guard granted else {
                dispatch_async(dispatch_get_main_queue()) {
                    // user didn't grant authorization, so tell them to fix that in settings
                    print(error)
                }
                return
            }
            
            // get the contacts
            
            var contacts = [CNContact]()
            let request = CNContactFetchRequest(keysToFetch: [CNContactIdentifierKey, CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName)])
            do {
                try store.enumerateContactsWithFetchRequest(request) { contact, stop in
                    if (contact.givenName != "" || contact.familyName != "") {
                        contacts.append(contact)
                    }
                    
                }
            } catch {
                print("Hello")
            }
            
            // do something with the contacts array (e.g. print the names)
            
            let formatter = CNContactFormatter()
            formatter.style = .FullName
            for contact in contacts {
                contactList.append(formatter.stringFromContact(contact)!)
            }
        }
    }
    
    func getData() {
        // Onboarding key
        if (defaults.objectForKey("OnboardingComplete") != nil) {
            onboardingComplete = defaults.boolForKey("OnboardingComplete")
        } else {
            defaults.setBool(onboardingComplete, forKey: "OnboardingComplete")
        }
        print("onboarding complete" + String(onboardingComplete))
        
        // Group Member Dictionary
        if (defaults.objectForKey("Groups") != nil) {
            groupNameMemberDict = defaults.objectForKey("Groups") as! Dictionary
        } else {
            defaults.setObject(groupNameMemberDict, forKey: "Groups")
        }
        
        // Full Name
        if (defaults.objectForKey("Name") != nil) {
            fullName = defaults.objectForKey("Name") as! String
        } else {
            defaults.setObject(fullName, forKey: "Name")
        }
        print(fullName)
        
        // Safety Status Key
        if (defaults.objectForKey("SafetyStatus") != nil) {
            safetyStatus = defaults.objectForKey("SafetyStatus") as? String ?? ""
        } else {
            defaults.setObject("unsafe", forKey: "SafetyStatus")
        }
        
        // Safety Level Key
        if (defaults.objectForKey("SafetyLevel") != nil) {
            safetyLevel = defaults.integerForKey("SafetyLevel") ?? 3
        } else {
            defaults.setInteger(3, forKey: "SafetyLevel")
        }
    }
    
    func setData() {
        defaults.setBool(onboardingComplete, forKey: "OnboardingComplete")
        defaults.setObject(groupNameMemberDict, forKey: "Groups")
        defaults.setObject(fullName, forKey: "Name")
        defaults.setObject(safetyStatus, forKey: "SafetyStatus")
        defaults.setInteger(safetyLevel, forKey: "SafetyLevel")
        defaults.synchronize()
    }
}

