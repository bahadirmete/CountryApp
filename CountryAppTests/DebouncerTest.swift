//
//  DebouncerTest.swift
//  CountryApp
//
//  Created by BB Mete on 4/25/25.
//

import XCTest
@testable import CountryApp

final class DebouncerTests: XCTestCase {
    
    var debouncer: Debouncer!
    
    override func tearDown() {
        debouncer = nil
        super.tearDown()
    }
    
    func testDebouncerExecutesActionAfterDelay() {
        let expectation = XCTestExpectation(description: "Debounced action is executed after delay")
        debouncer = Debouncer(delay: 0.1)
        
        var executed = false
        
        debouncer.run {
            executed = true
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.2)
        XCTAssertTrue(executed)
    }
    
    func testDebouncerCancelsPreviousWorkItem() {
        let expectation = XCTestExpectation(description: "Only the last debounced action should execute")
        debouncer = Debouncer(delay: 0.1)
        
        var firstActionExecuted = false
        var secondActionExecuted = false
        
        debouncer.run {
            firstActionExecuted = true
        }
        
        debouncer.run {
            secondActionExecuted = true
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.2)
        
        XCTAssertFalse(firstActionExecuted, "First action should have been cancelled")
        XCTAssertTrue(secondActionExecuted, "Second action should have been executed")
    }
}
