//
//  Task_Json.swift
//  Collaboration
//
//  Created by Kitti Almasy on 22/5/18.
//  Copyright © 2018 Kitti Almasy. All rights reserved.
//

import Foundation

class Task_Json {
    var forJson = Task(title: "test")
    
    var json: Data {
        get { return try! JSONEncoder().encode(forJson)}
        set { forJson = try! JSONDecoder().decode(Task.self, from: newValue)}
    }
}
