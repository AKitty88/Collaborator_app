//
//  Task_Json.swift
//  Collaboration
//
//  Created by Kitti Almasy on 22/5/18.
//  Copyright © 2018 Kitti Almasy s5110592. All rights reserved.
//

import Foundation

class Task_Json {
    var taskInJson: Task
    
    var json: Data {
        get { return try! JSONEncoder().encode(taskInJson)}
        set { taskInJson = try! JSONDecoder().decode(Task.self, from: newValue)}
    }
    
    func find(tasklist: [Task], id: String) -> Int {
        var index = -1
        
        for task in tasklist {
            index += 1
            
            if (task.task_id == id) {
                return index
            }
        }
        return -1
    }
    
    init(to_json: Task) {
        taskInJson = to_json
    }
    
    init() {
        taskInJson = Task(title: "Default")
    }
}
