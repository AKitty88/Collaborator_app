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
        let titl = "Get beer"
        let compl = false
        
        var task = Task(title: titl)
        XCTAssertEqual([task.title], [titl])
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
