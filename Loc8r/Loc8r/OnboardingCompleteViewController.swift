//
//  OnboardingCompleteViewController.swift
//  Loc8r
//
//  Created by Nehal Kanetkar on 2016-07-12.
//  Copyright © 2016 SYDE361. All rights reserved.
//

import UIKit

class OnboardingCompleteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        if (identifier == "completedOnboarding") {
            onboardingComplete = true
            defaults.setBool(onboardingComplete, forKey: "OnboardingComplete")
        }
        return true
    }
}
