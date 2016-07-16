//
//  CreateGroupViewController.swift
//  Loc8r
//
//  Created by Nehal Kanetkar on 2016-07-06.
//  Copyright © 2016 SYDE361. All rights reserved.
//

import UIKit
import Foundation

class CreateGroupViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    @IBOutlet var tv: UITableView! // Table view
    @IBOutlet weak var searchBar: UISearchBar!
    
    var filteredData: [String] = []
    var searchActive: Bool = false
    var checked = [Bool]()
    
    override func viewDidLoad() {
        tv.delegate = self
        tv.dataSource = self
        searchBar.delegate = self
        
        for _ in contactList {
            checked.append(false)
        }
    }
    
    @IBAction func cancelPeople(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addPeople(sender: AnyObject) {
        for index in 0...checked.count - 1 {
            if (checked[index]) {
                if people.contains(contactList[index]) {
                    // Do not add person to list
                } else {
                    people.append(contactList[index])
                }
                
            }
        }
        groupMembers.append(people)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchActive) {
            return filteredData.count
        }
        return contactList.count
        
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
//        searchActive = true;
    }
    
    func searchBarTextDidChange(searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = contactList.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if(filteredData.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tv.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "person")
        
        if (searchActive) {
            cell.textLabel?.text = filteredData[indexPath.row]
        } else {
            cell.textLabel!.text = contactList[indexPath.row]
        }
        
        if !checked[indexPath.row] {
            cell.accessoryType = .None
        } else if checked[indexPath.row] {
            cell.accessoryType = .Checkmark
        }
        
        return cell
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filteredData.removeAll(keepCapacity: false)
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (contactList as NSArray).filteredArrayUsingPredicate(searchPredicate)
        filteredData = array as! [String]
        
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            if cell.accessoryType == .Checkmark {
                cell.accessoryType = .None
                checked[indexPath.row] = false
            } else {
                cell.accessoryType = .Checkmark
                checked[indexPath.row] = true
            }
        }    
    }
}
