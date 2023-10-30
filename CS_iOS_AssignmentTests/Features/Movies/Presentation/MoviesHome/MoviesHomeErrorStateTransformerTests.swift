//
//  MoviesHomeErrorStateTransformerTests.swift
//  CS_iOS_AssignmentTests
//
//  Created by Joachim Kret on 07/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import XCTest
@testable import CS_iOS_Assignment

final class MoviesHomeErrorStateTransformerTests: XCTestCase {
    
    func test_whenStateIsFinishWithError_shouldCreateMessage() {
        let transformer = MoviesHomeErrorStateTransformer()
        
        XCTAssertNotNil(transformer.transform(
                            playingListState: playingState(.failure),
                            popularListState: popularState(.failure)))
        
        XCTAssertNotNil(transformer.transform(
                            playingListState: playingState(.success),
                            popularListState: popularState(.failure)))
        
        XCTAssertNotNil(transformer.transform(
                            playingListState: playingState(.failure),
                            popularListState: popularState(.success)))
    }
    
    func test_whenStateIsFinishWithoutError_shouldNotCreateMessage() {
        let transformer = MoviesHomeErrorStateTransformer()
        
        XCTAssertNil(transformer.transform(
                            playingListState: playingState(.success),
                            popularListState: popularState(.success)))
    }
    
    func test_whenStateIsNotFinished_shouldNotCreateMessage() {
        let transformer = MoviesHomeErrorStateTransformer()
        
        XCTAssertNil(transformer.transform(
                            playingListState: playingState(.initial),
                            popularListState: popularState(.initial)))
        
        XCTAssertNil(transformer.transform(
                            playingListState: playingState(.loading),
                            popularListState: popularState(.loading)))
        
        XCTAssertNil(transformer.transform(
                            playingListState: playingState(.initial),
                            popularListState: popularState(.loading)))
        
        XCTAssertNil(transformer.transform(
                            playingListState: playingState(.loading),
                            popularListState: popularState(.initial)))
        
        XCTAssertNil(transformer.transform(
                            playingListState: playingState(.initial),
                            popularListState: popularState(.success)))
        
        XCTAssertNil(transformer.transform(
                            playingListState: playingState(.loading),
                            popularListState: popularState(.success)))
        
        XCTAssertNil(transformer.transform(
                            playingListState: playingState(.initial),
                            popularListState: popularState(.failure)))
        
        XCTAssertNil(transformer.transform(
                            playingListState: playingState(.loading),
                            popularListState: popularState(.failure)))
        
        XCTAssertNil(transformer.transform(
                            playingListState: playingState(.success),
                            popularListState: popularState(.initial)))
        
        XCTAssertNil(transformer.transform(
                            playingListState: playingState(.success),
                            popularListState: popularState(.loading)))
        
        XCTAssertNil(transformer.transform(
                            playingListState: playingState(.failure),
                            popularListState: popularState(.initial)))
        
        XCTAssertNil(transformer.transform(
                            playingListState: playingState(.failure),
                            popularListState: popularState(.loading)))
    }
    
    private func playingState(_ state: ActivityStateName) -> PlayingListState {
        switch state {
        case .initial:
            return PlayingListState(activity: .initial, posters: [])
        case .loading:
            return PlayingListState(activity: .loading, posters: [])
        case .failure:
            return PlayingListState(activity: .failure("Error"), posters: [])
        case .success:
            return PlayingListState(activity: .success(()), posters: [])
        }
    }
    
    private func popularState(_ state: ActivityStateName) -> PopularListState {
        switch state {
        case .initial:
            return PopularListState(activity: .initial, action: .loadInitialPage, items: [], isNextPageAvailable: false)
        case .loading:
            return PopularListState(activity: .loading, action: .loadInitialPage, items: [], isNextPageAvailable: false)
        case .failure:
            return PopularListState(activity: .failure("Error"), action: .loadInitialPage, items: [], isNextPageAvailable: false)
        case .success:
            return PopularListState(activity: .success(()), action: .loadInitialPage, items: [], isNextPageAvailable: false)
        }
    }

}
