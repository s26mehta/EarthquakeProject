//
//  AboutAppViewController.swift
//  Loc8r
//
//  Created by Nehal Kanetkar on 2016-07-16.
//  Copyright © 2016 SYDE361. All rights reserved.
//

import Foundation
import UIKit

class AboutAppViewController: UIViewController {
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.topViewController?.title = "About Emergency Services"
    }
    
    override func viewDidLoad() {
        
    }
}
