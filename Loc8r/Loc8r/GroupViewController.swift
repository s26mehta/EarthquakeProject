//
//  NextViewController.swift
//  Loc8r
//
//  Created by Nehal Kanetkar on 2016-07-01.
//  Copyright © 2016 SYDE361. All rights reserved.
//

import UIKit
import Foundation

class GroupViewController: UITableViewController {
    @IBOutlet var tv: UITableView!
    @IBOutlet weak var NextBarButtonItem: UIBarButtonItem!
    var shouldPerformSegue: Bool = false
    
    override func viewDidLoad() {
        tableView.registerNib(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "firstCell")
        if (onboardingComplete) {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        // TODO: Check for groups
        if identifier == "FinishOnboarding" {
            if shouldPerformSegue {
                return true
            } else {
                if (groupNameMemberDict.count < 1) {
                    let title = "No Groups Added!"
                    let message = "Are you sure you don't want to add groups now. If not, you can always add them later by hitting groups."
                    inputAlert(title, message: message)
                    return false
                }
                return true
            }
        } else {
            return true
        }
    }

    override func viewWillAppear(animated: Bool) {
        tv.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupNameMemberDict.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let groupDict: [String:[String]] = groupNameMemberDict
        
        let cell = tv.dequeueReusableCellWithIdentifier("firstCell") as! TableViewCell
        var nameLabelText = ""
        var groupLabelText = ""
        var count = 0
        
        for (key, value) in groupDict {
            if count == indexPath.row {
                for name in value {
                    nameLabelText = nameLabelText + name + ", "
                }
                groupLabelText = key
            }
            count += 1
        }
        
        // Removes the last two indicies
        nameLabelText.removeAtIndex(nameLabelText.endIndex.predecessor())
        nameLabelText.removeAtIndex(nameLabelText.endIndex.predecessor())
        
        cell.groupLabel.text = groupLabelText
        cell.nameLabel.text = nameLabelText
        return cell
    }
    
    func finishOnboarding() {
        performSegueWithIdentifier("FinishOnboarding", sender: nil)
    }
    
    func inputAlert(title: String, message: String) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultErrorAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        let addLaterAction = UIAlertAction(title: "Add Groups Later", style: .Default) { (action) in
            self.shouldPerformSegue = true
            self.finishOnboarding()
        }
        alert.addAction(defaultErrorAction)
        alert.addAction(addLaterAction)
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
    }
}
