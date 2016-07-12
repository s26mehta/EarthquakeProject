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
    
    override func viewDidLoad() {
        tableView.registerNib(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "firstCell")
        if (onboardingComplete) {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        if (identifier == "completedOnboarding") {
            onboardingComplete = true
            defaults.setBool(onboardingComplete, forKey: "OnboardingComplete")
        }
        return true
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
        
        cell.groupLabel.text = groupLabelText
        cell.nameLabel.text = nameLabelText
        return cell
    }
}
