//
//  Task_Json.swift
//  Collaboration
//
//  Created by Kitti Almasy on 22/5/18.
//  Copyright © 2018 Kitti Almasy. All rights reserved.
//

import Foundation

class Task_Json {
    var forJson: Task
    
    var json: Data {
        get { return try! JSONEncoder().encode(forJson)}
        set { forJson = try! JSONDecoder().decode(Task.self, from: newValue)}
    }
    
    init(tasklist: [Task], id: String) {
        var found = false
        
        for task in tasklist {
            if (task.task_id == id) {
                found = true
            }
            
            if found {
                forJson = task
                return
            }
        }
        
        if found == false {
            forJson = Task(title: "Not found task")
        } else {
            forJson = Task(title: "Found task")
        }
    }
    
    init(to_json: Task) {
        forJson = to_json
    }
    
    init() {
        forJson = Task(title: "Default")
    }
}
