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
    
    // var log2 = [String]()       // []
    // var log3 = [String()]       // [""]
    var logs = [String()]
    
    /**
     Constructor of the class
     - parameter title : description of task
     */
    init(title: String, collaborators: String = "") {
        self.title = title
        self.collaborators = collaborators
        self.logs[0] = "\(getToday())" + " Tim " + "created " + "\"" + "\(title)" + "\""
    }
    
    func getToday() -> String
    {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd/MM/yy, HH:mm"
        // dateformatter.timeStyle = .short
        let today = dateformatter.string(from: Date())
        return today
    }
    
    func addLog() {
        self.logs.append("\(getToday())" + " Tim " + "changed " + "\"" + "\(title)" + "\"")
    }
    
    func logMovedToCompleted() {
        self.logs.append("\(getToday())" + " Tim " + "changed status of " + "\"" + "\(title)" + "\" to completed")
    }
    
    func logMovedToOngoing() {
        self.logs.append("\(getToday())" + " Tim " + "changed status of " + "\"" + "\(title)" + "\" to ongoing")
    }
    
    func taskNameChangedLog() {
        self.logs.append("\(getToday())" + " Tim " + "changed topic to " + "\"" + "\(title)" + "\"")
    }
}

