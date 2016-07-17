//
//  PeopleStatusTableViewController.swift
//  Loc8r
//
//  Created by Nehal Kanetkar on 2016-07-16.
//  Copyright © 2016 SYDE361. All rights reserved.
//

import Foundation
import UIKit

var gn: String = ""

class PeopleStatusTableViewController: UITableViewController {
    @IBOutlet var tv: UITableView!
    let safeColour = UIColor(colorLiteralRed: 118/255, green: 198/255, blue: 98/255, alpha: 1.0) // Green
    let unknownColour = UIColor(colorLiteralRed: 255/255, green: 138/255, blue: 36/255, alpha: 1.0) // Orange
    let unsafecolour = UIColor(colorLiteralRed: 255/255, green: 59/255, blue: 48/255, alpha: 1.0) // Red
    
    let kStatusSAFE = "Safe"
    let kStatusUNSAFE = "Unsafe"
    let kStatusUNKNOWN = "Unknown"
    
    let peopleArray = groupNameMemberDict[gn]
    
    override func viewDidLoad() {
        
    }
    
    override func viewWillAppear(animated: Bool) {
        people.removeAll()
        tv.reloadData()
        tv.rowHeight = 44
        self.navigationController?.topViewController?.title = gn
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peopleArray!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tv.dequeueReusableCellWithIdentifier("personStatusCell") as! StatusTableViewCell
        let name = peopleArray![indexPath.row]
        let arrayOfPeople = peopleStatus as! NSArray
        cell.nameLabel.text = name

        let arrayLength = arrayOfPeople.count - 1
        
        for i in 0...arrayLength {
            let person = arrayOfPeople[i] as! NSDictionary
            
            if let jsonName = person["name"] as? String {
                if (jsonName == name) {
                    // The person is in the array
                    if let sts = person["status"] as? Int {
                        let intsts = Int(sts)
                        if (intsts == -1) {
                            cell.statusLabel.text = kStatusUNKNOWN
                            cell.statusLabel.backgroundColor = unknownColour
                        } else if (intsts == 0) {
                            cell.statusLabel.text = kStatusSAFE
                            cell.statusLabel.backgroundColor = safeColour
                        } else {
                            cell.statusLabel.text = kStatusUNSAFE
                            cell.statusLabel.backgroundColor = unsafecolour
                        }
                    }
                } else {
//                    cell.statusLabel.text = kStatusUNKNOWN
//                    cell.statusLabel.backgroundColor = unknownColour
                }
            }
        }
        return cell
    }
}
