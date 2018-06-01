//
//  CollaborationTests.swift
//  CollaborationTests
//
//  Created by Kitti Almasy on 26/4/18.
//  Copyright © 2018 Kitti Almasy. All rights reserved.
//

import XCTest
@testable import Collaboration

class CollaborationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTaskComplete() {
        let id = "AB8419ED-058E-4726-AB87-1CC88CD573DE"
        let titl = "Get beer"
        let compl = false
        
        var task = Task(title: titl)
        task.task_id = id
        XCTAssertEqual([task.title], [titl])
        XCTAssertEqual([task.task_id!], [id])
        XCTAssertEqual([task.completed], [compl])
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd/MM/yy, HH:mm a"
        let dat = task.date
        let today = dateformatter.string(from: Date())
        
        XCTAssertEqual([dat], [today])
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
