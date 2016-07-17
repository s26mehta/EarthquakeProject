//
//  OnboardingCompleteViewController.swift
//  Loc8r
//
//  Created by Nehal Kanetkar on 2016-07-12.
//  Copyright © 2016 SYDE361. All rights reserved.
//

import UIKit

class OnboardingCompleteViewController: UIViewController {

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
            sendNewPerson()
            defaults.setBool(onboardingComplete, forKey: "OnboardingComplete")
        }
        return true
    }
    
    func sendNewPerson() {
        let url = "http://waterloo.matthewgougeon.me:1801/newPerson"
        let message = "name=" + fullName
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPBody = message.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if error == nil {
                print("Data sent")
            } else {
                // TODO: Deal with the Error of the user not having a data connection or the server being down
                
            }
        })
        task.resume()
    }
}
