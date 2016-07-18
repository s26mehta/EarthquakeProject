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
    @IBOutlet var tv: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(UINib(nibName: "GroupMemberTableViewCell", bundle: nil), forCellReuseIdentifier: "personCell")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(NameEntryViewController.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(animated: Bool) {
        tv.reloadData()
    }
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.view.endEditing(true)
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
            people.removeAll()
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
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tv.dequeueReusableCellWithIdentifier("personCell") as! GroupMemberTableViewCell
        cell.memberName.text = people[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            people.removeAtIndex(indexPath.row)
//            groupNameMemberDict.updateValue(people, forKey: gn)
//            defaults.setObject(groupNameMemberDict, forKey: "Groups")
            UIView.animateWithDuration(0.4, animations: {
                self.tv.reloadData()
            })
        }
    }
}
