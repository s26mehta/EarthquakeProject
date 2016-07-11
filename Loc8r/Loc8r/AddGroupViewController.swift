//
//  AddGroupViewController.swift
//  Loc8r
//
//  Created by Nehal Kanetkar on 2016-07-06.
//  Copyright © 2016 SYDE361. All rights reserved.
//

import UIKit

var people:[String] = []

class AddGroupViewController: UITableViewController {
    @IBOutlet weak var groupNameTextField: UITextField! // Text Field for group name

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveButton(sender: AnyObject) {
        if (groupNameTextField.text! == "") {
            let title = "No Group Name Entered"
            let message = "Please enter in a group name"
            inputAlert(title, message: message)
        } else {
            groupNames.append(groupNameTextField.text!)
            groupNameMemberDict.updateValue(people, forKey: groupNames.last!)
            defaults.setObject(groupNameMemberDict, forKey: "Groups")
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func inputAlert(title: String, message: String) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultErrorAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(defaultErrorAction)
        presentViewController(alert, animated: true, completion: nil)
    }
}
