//
//  Task.swift
//  Collaboration
//
//  Created by Kitti Almasy on 26/4/18.
//  Copyright © 2018 Kitti Almasy. All rights reserved.
//

import Foundation

/// Properties and methods of the tasks
class Task {
    ///  description of the task
    var title: String
    
    var collaborators: String
    
    var log: String
    
    /**
     Constructor of the class
     - parameter title : description of task
     */
    init(title: String, collaborators: String = "") {
        self.title = title
        self.collaborators = collaborators
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd/MM/yy, HH:mm"
        // dateformatter.timeStyle = .short
        let today = dateformatter.string(from: Date())
        
        self.log = "\(today)" + " Tim " + "created " + "\"" + "\(title)" + "\""
    }
}

