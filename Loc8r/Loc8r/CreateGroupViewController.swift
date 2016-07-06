//
//  CreateGroupViewController.swift
//  Loc8r
//
//  Created by Nehal Kanetkar on 2016-07-06.
//  Copyright © 2016 SYDE361. All rights reserved.
//

import UIKit
import Foundation

class CreateGroupViewController: UITableViewController {
    
    @IBAction func cancelGroup(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveGroup(sender: AnyObject) {
        print("Group Saved")
        dismissViewControllerAnimated(true, completion: nil)
    }
}
