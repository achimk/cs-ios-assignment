//
//  RatingTests.swift
//  CS_iOS_AssignmentTests
//
//  Created by Joachim Kret on 06/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import XCTest
@testable import CS_iOS_Assignment

final class RatingTests: XCTestCase {
    
    func test_initWithEmptyValue_shouldReturnEmpty() {
        let rating = Rating.adjust(nil, in: 0.0...1.0)
        XCTAssertNil(rating)
    }
    
    func test_initWithNonEmptyValue_shouldReturnRating() {
        let rating = Rating.adjust(1.0, in: 0.0...1.0)
        XCTAssertNotNil(rating)
    }
    
    func test_whenEqualTheSameValues_shouldMatch() {
        let lhs = Rating.adjust(1.0, in: 0.0...1.0)
        let rhs = Rating.adjust(1.0, in: 0.0...1.0)
        XCTAssertEqual(lhs, rhs)
    }
    
    func test_whenEqualDifferentValues_shouldNotMatch() {
        let lhs = Rating.adjust(0.0, in: 0.0...1.0)
        let rhs = Rating.adjust(1.0, in: 0.0...1.0)
        XCTAssertNotEqual(lhs, rhs)
    }
    
    func test_initWithSomeValue_shouldMatchValue() {
        let rating = Rating.adjust(1.0, in: 0.0...1.0)
        XCTAssertEqual(rating?.value, 1.0)
    }
    
    func test_compareValue_shouldMatchResults() {
        let lhs = Rating.adjust(0.0, in: 0.0...1.0)!
        let rhs = Rating.adjust(1.0, in: 0.0...1.0)!
        XCTAssertTrue(lhs == lhs)
        XCTAssertTrue(rhs == rhs)
        XCTAssertTrue(lhs != rhs)
        XCTAssertTrue(lhs < rhs)
        XCTAssertFalse(lhs > rhs)
    }

    func test_adjustWhenContainsInRange_shouldReturnCorrectRating() {
        let rating = Rating.adjust(7, in: 0.0...10.0)
        XCTAssertEqual(rating?.value, 0.7)
    }
    
    func test_adjustWhenGreaterThanUpperRange_shouldReturnCorrectRating() {
        let rating = Rating.adjust(11.0, in: 0.0...10.0)
        XCTAssertEqual(rating?.value, 1.0)
    }
    
    func test_adjustWhenLessThanLowerRange_shouldReturnCorrectRating() {
        let rating = Rating.adjust(-1.0, in: 0.0...10.0)
        XCTAssertEqual(rating?.value, 0.0)
    }
    
    func test_adjustForDifferentUpperBoundRanges_shouldReturnCorrectRating() {
        var rating = Rating.adjust(0.7, in: 0.0...1.0)
        XCTAssertEqual(rating?.value, 0.7)
        
        rating = Rating.adjust(7, in: 0.0...10.0)
        XCTAssertEqual(rating?.value, 0.7)
        
        rating = Rating.adjust(70, in: 0.0...100.0)
        XCTAssertEqual(rating?.value, 0.7)
    }
    
    func test_adjustForDifferenctLowerBoundRanges_shouldReturnCorrectRating() {
        var rating = Rating.adjust(0.7, in: 0.5...1.0)
        XCTAssertEqual(rating?.value, 0.4)
        
        rating = Rating.adjust(7, in: 5.0...10.0)
        XCTAssertEqual(rating?.value, 0.4)
        
        rating = Rating.adjust(70, in: 50.0...100.0)
        XCTAssertEqual(rating?.value, 0.4)
    }
}
