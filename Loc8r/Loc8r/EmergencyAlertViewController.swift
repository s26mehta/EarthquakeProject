//
//  EmergencyAlertViewController.swift
//  Loc8r
//
//  Created by Nehal Kanetkar on 2016-07-10.
//  Copyright © 2016 SYDE361. All rights reserved.
//

import UIKit

class EmergencyAlertViewController: UIViewController {
    var level = 1
    var safetyStatus = 0 // Value between 0 and 3 corresponding to their safety status [Safe, Unsafe Low, Unsafe Med, Unsafe High]
    var safety: Int = 2
    
    
    let notificationCenter = NSNotificationCenter.defaultCenter()
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.title = "Emergency Alerts"
        
        if (setEarthquakeNotifications) {
            
        } else {
            self.navigationItem.leftBarButtonItem?.title = "Settings"
        }
        performSegueWithIdentifier("earthquake", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        notificationCenter.postNotificationName("StartUpdating", object: nil)
        
        notificationCenter.addObserver(self, selector:#selector(EmergencyAlertViewController.hideNoAlertView), name: "HideNoAlert", object: nil)
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationItem.title = "Back"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hideNoAlertView() {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
    }
}
