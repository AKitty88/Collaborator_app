//
//  Task_Json.swift
//  Collaboration
//
//  Created by Kitti Almasy on 22/5/18.
//  Copyright © 2018 Kitti Almasy. All rights reserved.
//

import Foundation

class Task_Json {
    var taskInJson: Task
    
    var json: Data {
        get { return try! JSONEncoder().encode(taskInJson)}
        set { taskInJson = try! JSONDecoder().decode(Task.self, from: newValue)}
    }
    
    init(tasklist: [Task], id: String) {
        var found = false
        
        for task in tasklist {
            if (task.task_id == id) {
                found = true
            }
            
            if found {
                taskInJson = task
                return
            }
        }
        
        if found == false {
            taskInJson = Task(title: "Not found task")
        } else {
            taskInJson = Task(title: "Found task")
        }
    }
    
    init(to_json: Task) {
        taskInJson = to_json
    }
    
    init() {
        taskInJson = Task(title: "Default")
    }
}
