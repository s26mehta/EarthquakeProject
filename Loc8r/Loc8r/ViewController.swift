//
//  ViewController.swift
//  Loc8r
//
//  Created by Nehal Kanetkar on 2016-06-30.
//  Copyright © 2016 SYDE361. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var aboutEmergencyButton: UIButton!
    @IBOutlet weak var setupEmergencyButton: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func aboutButtonAction(sender: AnyObject) {
        
    }
    
    
    @IBAction func setupButtonAction(sender: AnyObject) {
        performSegueWithIdentifier("SetUp", sender: nil)
    }
}

