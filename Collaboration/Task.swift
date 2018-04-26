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
    /// date of the task
    var date: Date?
    /// shows if the task has duedate
    var hasDueDate: Bool
    /// shows if the task is completed
    var complete: Bool
    
    /**
     Constructor of the class
     - parameter title : description of task
     - parameter date : date chosen by user
     - parameter hasDueDate : tells us if the task has a duedate, if I don't specify it, it's set to false
     - parameter complete : tells us if the task is completed, if I don't specify it, it's set to false
     */
    init(title: String, date: Date, hasDueDate: Bool = false, complete: Bool = false) {
        self.title = title
        /// date is set only if hasDueDate is true
        if hasDueDate {
            self.date = date
        } else {
            self.date = nil
        }
        self.hasDueDate = hasDueDate
        self.complete = complete
    }
}
