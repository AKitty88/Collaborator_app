//
//  Task.swift
//  Collaboration
//
//  Created by Kitti Almasy on 26/4/18.
//  Copyright © 2018 Kitti Almasy. All rights reserved.
//

import Foundation

/// Properties and methods of the tasks
class Task: Codable {
    ///  description of the task
    var title: String
    /// date of the log (when it was created)
    var date: String
    /// people who worked on the log
    var collaborators: String
    // var log2 = [String]()       // []
    // var log3 = [String()]       // [""]
    /// array for the logs
    var logs = [String()]
    
    /**
     Constructor of the class
     - parameter title : description of the task
     - collaborators : people who worked on the log
     */
    init(title: String, collaborators: String = "Tim") {
        self.title = title
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd/MM/yy, HH:mm a"
        let today = dateformatter.string(from: Date())
        
        self.date = today
        self.collaborators = collaborators
        self.logs[0] = "created " + "\"" + "\(title)" + "\""
    }
    /// Returns the actual date and time
    func getToday() -> String
    {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd/MM/yy, HH:mm a"
        let today = dateformatter.string(from: Date())
        return today
    }
    /// Gets invoked when the Add button is clicked, adds a new log line to the logs array
    func addLog() {
        self.logs.append("changed " + "\"" + "\(title)" + "\"")
    }
    /// Gets invoked when the task is moved from the Ongoing section to the Completed section
    func logMovedToCompleted() {
        self.logs.append("changed status of " + "\"" + "\(title)" + "\" to completed")
    }
    /// Gets invoked when the task is moved from the Completed section to the Ongoing section
    func logMovedToOngoing() {
        self.logs.append("changed status of " + "\"" + "\(title)" + "\" to ongoing")
    }
    /// Gets invoked when the task's name is edited and return is pressed
    func taskNameChangedLog() {
        self.logs.append("changed topic to " + "\"" + "\(title)" + "\"")
    }
}

