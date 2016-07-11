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
    @IBOutlet weak var noAlertView: UIView!
    @IBOutlet weak var alertQuestionView: UIView!
    @IBOutlet weak var questionTitleLabel: UILabel!
    
    @IBOutlet weak var Question1View: UIView!
    @IBOutlet weak var Question2View: UIView!
    @IBOutlet weak var Question3View: UIView!
    
    @IBOutlet weak var negativeButton: UIButton!
    @IBOutlet weak var positiveButton: UIButton!
    
    
    let notificationCenter = NSNotificationCenter.defaultCenter()
    
    override func viewWillAppear(animated: Bool) {
        if (setEarthquakeNotifications) {
            alertQuestionView.hidden = false
            noAlertView.hidden = true
        } else {
            alertQuestionView.hidden = true
            noAlertView.hidden = false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        notificationCenter.postNotificationName("StartUpdating", object: nil)
        
        notificationCenter.addObserver(self, selector:#selector(EmergencyAlertViewController.hideNoAlertView), name: "HideNoAlert", object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Question1No(sender: AnyObject) {
        Question1View.hidden = true
        Question2View.hidden = false
        Question3View.hidden = true
    }
    
    @IBAction func Question2Yes(sender: AnyObject) {
        Question1View.hidden = true
        Question2View.hidden = true
        Question3View.hidden = false
    }
    
    @IBAction func Question2SafeNo(sender: AnyObject) {
        safetyStatus = 0
        performSegueWithIdentifier("mapView", sender: nil)
    }
    
    @IBAction func Question2SafeYes(sender: AnyObject) {
        safetyStatus = 1
        performSegueWithIdentifier("mapView", sender: nil)
    }
    
    @IBAction func Question2HelpNo(sender: AnyObject) {
        safetyStatus = 2
        performSegueWithIdentifier("mapView", sender: nil)
    }
    
    @IBAction func Question2HelpYes(sender: AnyObject) {
        safetyStatus = 3
        performSegueWithIdentifier("mapView", sender: nil)
    }
    
    func hideNoAlertView() {
        noAlertView.hidden = true
        alertQuestionView.hidden = false
        Question1View.hidden = false
        Question2View.hidden = true
        Question3View.hidden = true
    }
}
