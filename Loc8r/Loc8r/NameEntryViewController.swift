//
//  NameEntryViewController.swift
//  Loc8r
//
//  Created by Nehal Kanetkar on 2016-06-30.
//  Copyright © 2016 SYDE361. All rights reserved.
//

import UIKit
import Foundation

class NameEntryViewController: UITableViewController {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    override func viewDidLoad() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(NameEntryViewController.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
    }
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.view.endEditing(true)
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        if (firstNameTextField.text == "") {
            let title = "No First Name Entered"
            let message = "Please enter in your first name"
            inputAlert(title, message: message)
            
            return false
        } else {
            if (lastNameTextField.text == "") {
                let title = "No Last Name Entered"
                let message = "Please enter in your last name"
                inputAlert(title, message: message)
                
                return false
            } else {
                firstName = firstNameTextField.text!
                lastName = lastNameTextField.text!
                fullName = firstName + " " + lastName
                defaults.setObject(fullName, forKey: "Name")
                return true
            }
        }
    }
    
    func inputAlert(title: String, message: String) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultErrorAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(defaultErrorAction)
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
    }
}
