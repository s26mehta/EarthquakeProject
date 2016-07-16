//
//  GroupTableViewController.swift
//  Loc8r
//
//  Created by Nehal Kanetkar on 2016-07-16.
//  Copyright © 2016 SYDE361. All rights reserved.
//

import UIKit
import Foundation

class GroupTableViewController: UITableViewController {
    
    @IBOutlet var tv: UITableView!
    
    override func viewDidLoad() {
        tableView.registerNib(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "firstCell")
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
        if nameLabelText != "" {
            nameLabelText.removeAtIndex(nameLabelText.endIndex.predecessor())
            nameLabelText.removeAtIndex(nameLabelText.endIndex.predecessor())
        }
        
        cell.groupLabel.text = groupLabelText
        cell.nameLabel.text = nameLabelText
        return cell
    }
}