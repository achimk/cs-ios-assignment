//
//  MoviePageResultTests.swift
//  CS_iOS_AssignmentTests
//
//  Created by Joachim Kret on 06/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import XCTest
@testable import CS_iOS_Assignment

final class MoviePageResultTests: XCTestCase {
    
    func test_whenNotReachedLastPage_shouldCreateNextPageQuery() {
        let result = MoviePageResult(movies: [], page: 1, isLastPage: false)
        let query = result.nextPageQuery()
        XCTAssertNotNil(query)
        XCTAssertEqual(query?.value, 2)
    }
    
    func test_whenReachedLastPage_shouldNotCreateNextPageQuery() {
        let result = MoviePageResult(movies: [], page: 1, isLastPage: true)
        let query = result.nextPageQuery()
        XCTAssertNil(query)
    }
}
