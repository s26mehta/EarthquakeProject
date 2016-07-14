//
//  UpdateNameViewController.swift
//  Loc8r
//
//  Created by Nehal Kanetkar on 2016-07-13.
//  Copyright © 2016 SYDE361. All rights reserved.
//

import UIKit

class UpdateNameViewController: UIViewController {
    @IBOutlet weak var firstNameTextLabel: UITextField!
    @IBOutlet weak var lastNameTextLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func saveButton(sender: AnyObject) {
        if ((firstNameTextLabel.text == "") || (lastNameTextLabel.text == "")) {
            let title = "No Name Entered"
            let message = "Please enter a name before saving"
            inputAlert(title, message: message)
        } else {
            firstName = firstNameTextLabel.text!
            lastName = lastNameTextLabel.text!
            fullName = firstName + " " + lastName
            sendNewPerson()
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func inputAlert(title: String, message: String) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultErrorAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(defaultErrorAction)
        presentViewController(alert, animated: true, completion: nil)
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
            } else {
                // TODO: Deal with the Error of the user not having a data connection or the server being down
                
            }
        })
        task.resume()
    }
}
