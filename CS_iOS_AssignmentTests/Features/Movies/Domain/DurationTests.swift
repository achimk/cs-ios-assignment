//
//  DurationTests.swift
//  CS_iOS_AssignmentTests
//
//  Created by Joachim Kret on 06/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import XCTest
@testable import CS_iOS_Assignment

final class DurationTests: XCTestCase {
    
    func test_initWithEmptyValue_shouldReturnEmpty() {
        let duration = Duration(nil)
        XCTAssertNil(duration)
    }
    
    func test_initWithNonEmptyValue_shouldReturnDuration() {
        let duration = Duration(1)
        XCTAssertNotNil(duration)
    }
    
    func test_initWithInvalidValue_shouldReturnEmpty() {
        let duration = Duration(0)
        XCTAssertNil(duration)
    }
    
    func test_whenEqualTheSameValues_shouldMatch() {
        let lhs = Duration(100)
        let rhs = Duration(100)
        XCTAssertEqual(lhs, rhs)
    }
    
    func test_whenEqualDifferentValues_shouldNotMatch() {
        let lhs = Duration(100)
        let rhs = Duration(101)
        XCTAssertNotEqual(lhs, rhs)
    }
    
    func test_initWithSomeValue_shouldMatchValue() {
        let duration = Duration(101)
        XCTAssertEqual(duration?.minutes, 101)
    }
    
    func test_whenDurationLessThanOneHour_shouldMatchComponents() {
        let duration = Duration(59)
        XCTAssertEqual(duration?.components.hours, 0)
        XCTAssertEqual(duration?.components.minutes, 59)
    }
    
    func test_whenDurationGraterThanOneHour_shouldMatchComponents() {
        let duration = Duration(179)
        XCTAssertEqual(duration?.components.hours, 2)
        XCTAssertEqual(duration?.components.minutes, 59)
    }
}
