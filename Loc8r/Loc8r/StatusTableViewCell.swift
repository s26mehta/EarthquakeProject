//
//  StatusTableViewCell.swift
//  Loc8r
//
//  Created by Nehal Kanetkar on 2016-07-16.
//  Copyright © 2016 SYDE361. All rights reserved.
//

import Foundation
import UIKit

class StatusTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
