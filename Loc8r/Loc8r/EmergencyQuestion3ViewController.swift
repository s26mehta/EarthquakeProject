//
//  EmergencyQuestion3ViewController.swift
//  Loc8r
//
//  Created by Nehal Kanetkar on 2016-07-14.
//  Copyright © 2016 SYDE361. All rights reserved.
//

import UIKit

class EmergencyQuestion3ViewController: UIViewController {
    
    // TODO: Add call for safe

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        if identifier == "mapView" {
            setStatus()
        }
        return true
    }
    
    func setStatus() {
        let status = String(Int(0)) + String(Int(0)) + String(Int(0))
        let time = String(Int(NSDate().timeIntervalSince1970))
        
        let url = "http://waterloo.matthewgougeon.me:1801/setStatus"
        print(fullName)
        let name = "name=" + fullName + "&lat=" + String(currentLocation[0])
        let location = "&lon=" + String(currentLocation[1]) + "&status=" + status + "&time=" + time
        let message = name + location
        
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
