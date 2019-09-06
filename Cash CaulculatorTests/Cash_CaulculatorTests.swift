//
//  Cash_CaulculatorTests.swift
//  Cash CaulculatorTests
//
//  Created by Salamender Li on 1/9/19.
//  Copyright © 2019 Salamender Li. All rights reserved.
//

import XCTest
@testable import Cash_Caulculator

class Cash_CaulculatorTests: XCTestCase {

    let fileHelper = FileHelper()

    
    override func setUp() {
      
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        fileHelper.removeFile()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
       assert (fileHelper.getArrayFromJson().count != 0)
    }
    

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
