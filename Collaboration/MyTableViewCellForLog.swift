//
//  MyTableViewCellForLog.swift
//  Collaboration
//
//  Created by Kitti Almasy on 16/5/18.
//  Copyright © 2018 Kitti Almasy. All rights reserved.
//

import Foundation
import UIKit

class MyTableViewCellForLog: UITableViewCell {
    
    @IBOutlet weak var myTextLabel: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var collaboratorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
