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
        return groupNames.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tv.dequeueReusableCellWithIdentifier("firstCell") as! TableViewCell
        cell.groupLabel.text = groupNames[indexPath.row]
        
        let names = groupMembers[indexPath.row]
        var nameLabelText = ""
        
        for name in names {
            nameLabelText = nameLabelText + name + ", "
        }
        
        cell.nameLabel.text = nameLabelText
        return cell
    }
}
