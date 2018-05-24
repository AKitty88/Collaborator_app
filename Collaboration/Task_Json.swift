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
    
    var found = false
    
    var json: Data {
        get { return try! JSONEncoder().encode(taskInJson)}
        set { taskInJson = try! JSONDecoder().decode(Task.self, from: newValue)}
    }
    
    init(tasklist: [Task], id: String) {
        taskInJson = Task(title: "Not found task")
        var counter = -1
        
        for task in tasklist {
            counter += 1
            
            if (task.task_id == id) {
                found = true
                taskInJson = task
                taskInJson.found_index = counter
            }
        }
    }
    
    init(to_json: Task) {
        taskInJson = to_json
    }
    
    init() {
        taskInJson = Task(title: "Default")
    }
}
