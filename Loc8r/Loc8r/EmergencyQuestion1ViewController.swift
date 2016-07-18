//
//  EmergencyQuestion1ViewController.swift
//  Loc8r
//
//  Created by Nehal Kanetkar on 2016-07-13.
//  Copyright © 2016 SYDE361. All rights reserved.
//

import UIKit

class EmergencyQuestion1ViewController: UIViewController {

    override func viewWillAppear(animated: Bool) {
        if !cancelShouldAppear {
            self.navigationItem.leftBarButtonItem = nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
