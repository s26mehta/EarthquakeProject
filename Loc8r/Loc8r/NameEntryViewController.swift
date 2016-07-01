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
    // Keyboard hiding function
    // Return button on keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Touch anywhere outside of the keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }

    @IBAction func nextButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier("SetUp", sender: nil)
    }
}
