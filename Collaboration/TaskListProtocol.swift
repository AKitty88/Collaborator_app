//
//  TaskListProtocol.swift
//  Collaboration
//
//  Created by Kitti Almasy on 26/4/18.
//  Copyright © 2018 Kitti Almasy. All rights reserved.
//

import Foundation

/// Protocol to which MasterViewController must conform
protocol TaskListProtocol {
    /// the section of the task which is selected at the moment
    var selectedItemSection: Int? {get}
    /// the index of the task which is selected at the moment
    var selectedItemIndex: Int? {get}
    /// the task which is selected at the moment
    var selectedTask: Task? {get}
    
    /**
     Saves the task that is being edited
     - parameter task : description of task
     - parameter dateDue : date chosen by user
     - parameter isDue : tells us if the task has a duedate
     - parameter status : tells us if the task is completed
     */
    func save(withName task: String)
    
    /// cancels the editing of the current task
    func cancel()
}
