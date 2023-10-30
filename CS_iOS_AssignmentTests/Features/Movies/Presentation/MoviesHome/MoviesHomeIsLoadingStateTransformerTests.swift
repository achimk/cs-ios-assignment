//
//  MoviesHomeIsLoadingStateTransformerTests.swift
//  CS_iOS_AssignmentTests
//
//  Created by Joachim Kret on 07/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import XCTest
@testable import CS_iOS_Assignment

final class MoviesHomeIsLoadingStateTransformerTests: XCTestCase {
    
    func test_whenAnyStateIsLoading_shouldBeValid() {
        let transformer = MoviesHomeIsLoadingStateTransformer()
        
        XCTAssertTrue(transformer.transform(
                        playingListState: playingState(.initial),
                        popularListState: popularState(.loading)))
        
        XCTAssertTrue(transformer.transform(
                        playingListState: playingState(.failure),
                        popularListState: popularState(.loading)))
        
        XCTAssertTrue(transformer.transform(
                        playingListState: playingState(.success),
                        popularListState: popularState(.loading)))
        
        XCTAssertTrue(transformer.transform(
                        playingListState: playingState(.loading),
                        popularListState: popularState(.loading)))
        
        XCTAssertTrue(transformer.transform(
                        playingListState: playingState(.loading),
                        popularListState: popularState(.initial)))
        
        XCTAssertTrue(transformer.transform(
                        playingListState: playingState(.loading),
                        popularListState: popularState(.failure)))
        
        XCTAssertTrue(transformer.transform(
                        playingListState: playingState(.loading),
                        popularListState: popularState(.success)))
    }
    
    func test_whenNoLoadingState_shouldBeInvalid() {
        let transformer = MoviesHomeIsLoadingStateTransformer()
        
        XCTAssertFalse(transformer.transform(
                        playingListState: playingState(.initial),
                        popularListState: popularState(.initial)))
        
        XCTAssertFalse(transformer.transform(
                        playingListState: playingState(.initial),
                        popularListState: popularState(.failure)))
        
        XCTAssertFalse(transformer.transform(
                        playingListState: playingState(.initial),
                        popularListState: popularState(.success)))
        
        
        XCTAssertFalse(transformer.transform(
                        playingListState: playingState(.failure),
                        popularListState: popularState(.initial)))
        
        XCTAssertFalse(transformer.transform(
                        playingListState: playingState(.failure),
                        popularListState: popularState(.failure)))
        
        XCTAssertFalse(transformer.transform(
                        playingListState: playingState(.failure),
                        popularListState: popularState(.success)))
        
        
        XCTAssertFalse(transformer.transform(
                        playingListState: playingState(.success),
                        popularListState: popularState(.initial)))
        
        XCTAssertFalse(transformer.transform(
                        playingListState: playingState(.success),
                        popularListState: popularState(.failure)))
        
        XCTAssertFalse(transformer.transform(
                        playingListState: playingState(.success),
                        popularListState: popularState(.success)))
        
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
