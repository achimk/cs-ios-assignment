//
//  MovieIdTests.swift
//  CS_iOS_AssignmentTests
//
//  Created by Joachim Kret on 06/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import XCTest
@testable import CS_iOS_Assignment

final class MovieIdTests: XCTestCase {
    
    func test_initWithEmptyValue_shouldReturnEmpty() {
        let movieId = MovieId(nil)
        XCTAssertNil(movieId)
    }
    
    func test_initWithSomeValue_shouldReturnMovieId() {
        let movieId = MovieId(1)
        XCTAssertNotNil(movieId)
    }
    
    func test_initWithSomeValue_shouldMatchValue() {
        let movieId = MovieId(1)
        XCTAssertEqual(movieId?.value, 1)
    }
    
    func test_whenEqualTheSameMovieIds_shouldMatch() {
        let lhs = MovieId(1)
        let rhs = MovieId(1)
        XCTAssertEqual(lhs, rhs)
    }
    
    func test_whenEqualTheDifferentMovieIds_shouldNotMatch() {
        let lhs = MovieId(1)
        let rhs = MovieId(2)
        XCTAssertNotEqual(lhs, rhs)
    }
}

