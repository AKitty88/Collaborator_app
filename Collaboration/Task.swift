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
    
    var date: String
    var collaborators: String
    // var log2 = [String]()       // []
    // var log3 = [String()]       // [""]
    var logs = [String()]
    
    /**
     Constructor of the class
     - parameter title : description of task
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
    
    func getToday() -> String
    {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd/MM/yy, HH:mm a"
        let today = dateformatter.string(from: Date())
        return today
    }
    
    func addLog() {
        self.logs.append("changed " + "\"" + "\(title)" + "\"")
    }
    
    func logMovedToCompleted() {
        self.logs.append("changed status of " + "\"" + "\(title)" + "\" to completed")
    }
    
    func logMovedToOngoing() {
        self.logs.append("changed status of " + "\"" + "\(title)" + "\" to ongoing")
    }
    
    func taskNameChangedLog() {
        self.logs.append("changed topic to " + "\"" + "\(title)" + "\"")
    }
}

