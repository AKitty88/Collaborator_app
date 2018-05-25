//
//  MyTableViewCellForLog.swift
//  Collaboration
//
//  Created by Kitti Almasy on 16/5/18.
//  Copyright © 2018 Kitti Almasy s5110592. All rights reserved.
//

import Foundation
import UIKit

/// Cell class for the cell that displays the log messages
class MyTableViewCellForLog: UITableViewCell {
    
    @IBOutlet weak var myTextLabel: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var collaboratorLabel: UILabel!
}
