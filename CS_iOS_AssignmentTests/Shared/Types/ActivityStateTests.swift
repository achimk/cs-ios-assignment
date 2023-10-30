//
//  ActivityStateTests.swift
//  CS_iOS_AssignmentTests
//
//  Created by Joachim Kret on 06/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import XCTest
@testable import CS_iOS_Assignment

final class ActivityStateTests: XCTestCase {
    
    typealias State = ActivityState<Int, String>
    
    struct TestError: Error, Equatable { }
    
    func testIsInitial() {
        let state = State.initial
        XCTAssertTrue(state.isInitial == true)
    }
    
    func testInvokedInitial() {
        var invoked = false
        let state = State.initial
        state.ifInitial { invoked = true }
        XCTAssertTrue(invoked == true)
    }
    
    func testInitialValue() {
        let state = State.initial
        XCTAssertTrue(state.value == nil)
    }
    
    func testInitialError() {
        let state = State.initial
        XCTAssertTrue(state.error == nil)
    }
    
    func testIsLoading() {
        let state = State.loading
        XCTAssertTrue(state.isLoading)
    }
    
    func testInvokedLoading() {
        var invoked = false
        let state = State.loading
        state.ifLoading { invoked = true }
        XCTAssertTrue(invoked)
    }
    
    func testLoadingValue() {
        let state = State.loading
        XCTAssertTrue(state.value == nil)
    }
    
    func testLoadingError() {
        let state = State.loading
        XCTAssertTrue(state.error == nil)
    }
    
    func testIsSuccess() {
        let state = State.success(1)
        XCTAssertTrue(state.isSuccess)
    }
    
    func testInvokedSuccess() {
        var invokedValue: Int?
        let state = State.success(1)
        state.ifSuccess { invokedValue = $0 }
        XCTAssertTrue(invokedValue == 1)
    }
    
    func testSuccessValue() {
        let state = State.success(1)
        XCTAssertTrue(state.value == 1)
    }
    
    func testSuccessError() {
        let state = State.success(1)
        XCTAssertTrue(state.error == nil)
    }
    
    func testIsFailure() {
        let state = State.failure("test")
        XCTAssertTrue(state.isFailure)
    }
    
    func testInvokedFailure() {
        var invokedValue: String?
        let state = State.failure("test")
        state.ifFailure { invokedValue = $0 }
        XCTAssertTrue(invokedValue == "test")
    }
    
    func testFailureValue() {
        let state = State.failure("test")
        XCTAssertTrue(state.value == nil)
    }
    
    func testFailureError() {
        let state = State.failure("test")
        XCTAssertTrue(state.error == "test")
    }
    
    func testEquatable() {
        let initial = State.initial
        let loading = State.loading
        let success = State.success(1)
        let failure = State.failure("test")
        
        XCTAssertTrue(initial == initial)
        XCTAssertTrue(loading == loading)
        XCTAssertTrue(success == success)
        XCTAssertTrue(failure == failure)
    }
    
    func testNotEquatable() {
        let initial = State.initial
        let loading = State.loading
        let success = State.success(1)
        let failure = State.failure("test")
        
        XCTAssertTrue(initial != loading)
        XCTAssertTrue(initial != success)
        XCTAssertTrue(initial != failure)
        XCTAssertTrue(loading != initial)
        XCTAssertTrue(loading != success)
        XCTAssertTrue(loading != failure)
        XCTAssertTrue(success != initial)
        XCTAssertTrue(success != loading)
        XCTAssertTrue(success != failure)
        XCTAssertTrue(failure != initial)
        XCTAssertTrue(failure != loading)
        XCTAssertTrue(failure != success)
    }
    
    func testResultConversion() {
     
        let initial = ActivityState<Int, TestError>.initial
        let loading = ActivityState<Int, TestError>.loading
        let success = ActivityState<Int, TestError>.success(1)
        let failure = ActivityState<Int, TestError>.failure(TestError())
        
        XCTAssertTrue(initial.result == nil)
        XCTAssertTrue(loading.result == nil)
        XCTAssertTrue(success.result != nil)
        XCTAssertTrue(failure.result != nil)
        
        success.result.ifPresent { (result) in
            XCTAssertTrue(result.value == 1)
        }
        
        failure.result.ifPresent { (result) in
            XCTAssertTrue(result.error == TestError())
        }
    }
    
    func testStringConversion() {
        
        let initial = ActivityState<Int, TestError>.initial
        let loading = ActivityState<Int, TestError>.loading
        let success = ActivityState<Int, TestError>.success(1)
        let failure = ActivityState<Int, TestError>.failure(TestError())
        
        XCTAssertTrue(initial.stringValue == "initial")
        XCTAssertTrue(loading.stringValue == "loading")
        XCTAssertTrue(success.stringValue == "success")
        XCTAssertTrue(failure.stringValue == "failure")
    }
    
    func testMap() {
        let initial = ActivityState<Int, TestError>.initial.map { String($0) }
        let loading = ActivityState<Int, TestError>.loading.map { String($0) }
        let success = ActivityState<Int, TestError>.success(1).map { String($0) }
        let failure = ActivityState<Int, TestError>.failure(TestError()).map { String($0) }
        
        XCTAssertTrue(initial.stringValue == "initial")
        XCTAssertTrue(loading.stringValue == "loading")
        XCTAssertTrue(success.stringValue == "success")
        XCTAssertTrue(failure.stringValue == "failure")

        XCTAssertTrue(initial.value == nil)
        XCTAssertTrue(loading.value == nil)
        XCTAssertTrue(success.value == "1")
        XCTAssertTrue(failure.value == nil)
    }
    
    func testMapError() {
        
        let initial = ActivityState<Int, TestError>.initial.mapError { String(describing: $0) }
        let loading = ActivityState<Int, TestError>.loading.mapError { String(describing: $0) }
        let success = ActivityState<Int, TestError>.success(1).mapError { String(describing: $0) }
        let failure = ActivityState<Int, TestError>.failure(TestError()).mapError { String(describing: $0) }
        
        XCTAssertTrue(initial.stringValue == "initial")
        XCTAssertTrue(loading.stringValue == "loading")
        XCTAssertTrue(success.stringValue == "success")
        XCTAssertTrue(failure.stringValue == "failure")

        XCTAssertTrue(initial.error == nil)
        XCTAssertTrue(loading.error == nil)
        XCTAssertTrue(success.error == nil)
        XCTAssertTrue(failure.error == "TestError()")
    }
}
