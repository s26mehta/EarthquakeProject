//
//  EmergencyQuestion2ViewController.swift
//  Loc8r
//
//  Created by Nehal Kanetkar on 2016-07-13.
//  Copyright © 2016 SYDE361. All rights reserved.
//

import UIKit

class EmergencyQuestion2ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tv: UITableView!
    var medical: Bool = true
    var fire: Bool = true
    var police: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        tv.delegate = self
        tv.dataSource = self

        tv.alwaysBounceVertical = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        if identifier == "mapView" {
            setStatus()
            return true
        }
        return true
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tv.dequeueReusableCellWithIdentifier("emergencyCell") as! EmergencyTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.typeLabel.text = "Medical"
        case 1:
            cell.typeLabel.text = "Fire"
        case 2:
            cell.typeLabel.text = "Police"
        default:
            cell.typeLabel.text = "Your Mom"
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            if cell.accessoryType == .Checkmark {
                cell.accessoryType = .None
                
                let tempCell = cell as! EmergencyTableViewCell
                let tempCellText = tempCell.typeLabel.text!
                
                switch tempCellText {
                case "Medical":
                    medical = false
                case "Fire":
                    fire = false
                case "Police":
                    police = false
                default: break
                    
                }
            } else {
                cell.accessoryType = .Checkmark
                
                let tempCell = cell as! EmergencyTableViewCell
                let tempCellText = tempCell.typeLabel.text!
                
                switch tempCellText {
                case "Medical":
                    medical = true
                case "Fire":
                    fire = true
                case "Police":
                    police = true
                default: break
                    
                }
            }
        }
    }
    
    func setStatus() {
        let status = String(Int(medical)) + String(Int(fire)) + String(Int(police))
        
        let url = "http://waterloo.matthewgougeon.me:1801/setStatus"
        let name = "name=" + fullName + "lat=" + String(currentLocation[0])
        let location = "lon=" + String(currentLocation[1]) + "status=" + status
        let message = name + location
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPBody = message.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if error == nil {
                print("Data sent")
            } else {
                // TODO: Deal with the Error of the user not having a data connection or the server being down
                
            }
        })
        task.resume()
    }
}
