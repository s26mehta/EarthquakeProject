//
//  EmergencyQuestion4ViewController.swift
//  Loc8r
//
//  Created by Nehal Kanetkar on 2016-07-14.
//  Copyright © 2016 SYDE361. All rights reserved.
//

import UIKit

class EmergencyQuestion4ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tv: UITableView!
    var medical: Bool = false
    var fire: Bool = false
    var police: Bool = false
    
    @IBOutlet weak var nextViewControllerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tv.delegate = self
        tv.dataSource = self
        tv.alwaysBounceVertical = false
        
        nextViewControllerButton.enabled = false
        nextViewControllerButton.alpha = 0.5
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
                setButton()
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
                setButton()
            }
        }
    }
    
    func setButton() {
        if (medical || fire || police) {
            nextViewControllerButton.enabled = true
            UIView.animateWithDuration(0.5, animations: {
                self.nextViewControllerButton.alpha = 1.0
            })
            
        } else {
            nextViewControllerButton.enabled = false
            UIView.animateWithDuration(0.5, animations: {
                self.nextViewControllerButton.alpha = 0.5
            })
        }
    }
    
    func setStatus() {
        let status = String(Int(medical)) + String(Int(fire)) + String(Int(police))
        let time = String(Int(NSDate().timeIntervalSince1970))
        
        let url = "http://waterloo.matthewgougeon.me:1801/setStatus"
        let name = "name=" + fullName + "&lat=" + String(currentLocation[0])
        let location = "&lon=" + String(currentLocation[1]) + "&status=" + status + "&time=" + time
        let message = name + location
        
        print(status)
        print(message)
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        print(request)
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
