//
//  MoviePageQueryTests.swift
//  CS_iOS_AssignmentTests
//
//  Created by Joachim Kret on 06/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import XCTest
@testable import CS_iOS_Assignment

final class MoviePageQueryTests: XCTestCase {
    
    func test_initWithValidValue_shouldReturnPageQuery() {
        let query = MoviePageQuery(page: 1)
        XCTAssertNotNil(query)
    }
    
    func test_initWithInvalidValue_shouldReturnPageQuery() {
        let query = MoviePageQuery(page: 0)
        XCTAssertNil(query)
    }
    
    func test_initWithValidValue_shouldMatchValue() {
        let query = MoviePageQuery(page: 1)
        XCTAssertEqual(query?.value, 1)
    }
    
    func test_whenEqualTheSameQeryPages_shouldMatch() {
        let lhs = MoviePageQuery(page: 1)
        let rhs = MoviePageQuery(page: 1)
        XCTAssertEqual(lhs, rhs)
    }
    
    func test_whenEqualTheDifferentQueryPages_shouldNotMatch() {
        let lhs = MoviePageQuery(page: 1)
        let rhs = MoviePageQuery(page: 2)
        XCTAssertNotEqual(lhs, rhs)
    }
    
    func test_whenCreateInitial_shouldStartFromValidPage() {
        let query = MoviePageQuery.initial
        XCTAssertEqual(query.value, 1)
    }
    
    func test_whenCreateNextPage_shouldIncrementWithValidPage() {
        let query = MoviePageQuery.initial.nextPage()
        XCTAssertEqual(query.value, 2)
    }
}
