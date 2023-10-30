//
//  PopularListStateTransformerTests.swift
//  CS_iOS_AssignmentTests
//
//  Created by Joachim Kret on 07/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import XCTest
@testable import CS_iOS_Assignment

final class PopularListStateTransformerTests: XCTestCase {
    
    struct DummyError: Error { }
    
    struct StateResult: Equatable {
        let name: String
        let action: PopularListAction
        let itemsCount: Int
        let isNextPageAvailable: Bool
        
        static func loading(action: PopularListAction, itemsCount: Int, isNextPageAvailable: Bool) -> StateResult {
            return StateResult(
                name: ActivityStateName.loading.rawValue,
                action: action,
                itemsCount: itemsCount,
                isNextPageAvailable: isNextPageAvailable)
        }
        
        static func failure(action: PopularListAction, itemsCount: Int, isNextPageAvailable: Bool) -> StateResult {
            return StateResult(
                name: ActivityStateName.failure.rawValue,
                action: action,
                itemsCount: itemsCount,
                isNextPageAvailable: isNextPageAvailable)
        }
        
        static func success(action: PopularListAction, itemsCount: Int, isNextPageAvailable: Bool) -> StateResult {
            return StateResult(
                name: ActivityStateName.success.rawValue,
                action: action,
                itemsCount: itemsCount,
                isNextPageAvailable: isNextPageAvailable)
        }
        
        static func from(_ state: PopularListState) -> StateResult {
            return StateResult(
                name: state.activity.stringValue,
                action: state.action,
                itemsCount: state.items.count,
                isNextPageAvailable: state.isNextPageAvailable)
        }
    }
    
    let dummyMoviePageResult = MoviePageResult(movies: [], page: 0, isLastPage: false)

    func test_whenNoAction_shouldReturnOldState() {
        
        let components = prepareComponents()
        
        let initial = components.transformer.transform(actionState: (action: nil, activity: .initial), oldState: components.initialState)
        let loading = components.transformer.transform(actionState: (action: nil, activity: .loading), oldState: components.initialState)
        let failure = components.transformer.transform(actionState: (action: nil, activity: .failure(DummyError())), oldState: components.initialState)
        let success = components.transformer.transform(actionState: (action: nil, activity: .success(dummyMoviePageResult)), oldState: components.initialState)
        
        let oldState = StateResult.from(components.initialState)
        XCTAssertEqual(oldState, StateResult.from(initial))
        XCTAssertEqual(oldState, StateResult.from(loading))
        XCTAssertEqual(oldState, StateResult.from(failure))
        XCTAssertEqual(oldState, StateResult.from(success))
    }
    
    func test_whenInitialState_shouldReturnOldState() {
        
        let components = prepareComponents()
        
        let noAction = components.transformer.transform(actionState: (action: nil, activity: .initial), oldState: components.initialState)
        let loadInitialPageAction = components.transformer.transform(actionState: (action: .loadInitialPage, activity: .initial), oldState: components.initialState)
        let loadNextPageAction = components.transformer.transform(actionState: (action: .loadNextPage, activity: .initial), oldState: components.initialState)
        
        let oldState = StateResult.from(components.initialState)
        XCTAssertEqual(oldState, StateResult.from(noAction))
        XCTAssertEqual(oldState, StateResult.from(loadInitialPageAction))
        XCTAssertEqual(oldState, StateResult.from(loadNextPageAction))
    }
    
    func test_loadInitialPageActionWhenLoadingState_shouldUpdateStateCorrectly() {
        
        let components = prepareComponents()
        let state = StateResult.loading(
            action: .loadInitialPage,
            itemsCount: components.initialState.items.count,
            isNextPageAvailable: components.initialState.isNextPageAvailable)
        
        let newState = components.transformer.transform(actionState: (action: .loadInitialPage, activity: .loading), oldState: components.initialState)

        XCTAssertEqual(state, StateResult.from(newState))
    }
    
    func test_loadInitialPageActionWhenFailureState_shouldUpdateStateCorrectly() {
        
        let components = prepareComponents()
        let state = StateResult.failure(
            action: .loadInitialPage,
            itemsCount: components.initialState.items.count,
            isNextPageAvailable: components.initialState.isNextPageAvailable)
        
        let newState = components.transformer.transform(actionState: (action: .loadInitialPage, activity: .failure(DummyError())), oldState: components.initialState)

        XCTAssertEqual(state, StateResult.from(newState))
    }
    
    func test_loadInitialPageActionWhenSuccessState_shouldUpdateStateCorrectly() {
        
        let components = prepareComponents()
        let state = StateResult.success(
            action: .loadInitialPage,
            itemsCount: 3,
            isNextPageAvailable: true)
        let pageResult = MoviePageResult(movies: components.movieBuilder.build(count: 3), page: 1, isLastPage: false)
        
        let newState = components.transformer.transform(actionState: (action: .loadInitialPage, activity: .success(pageResult)), oldState: components.loadedInitialState)

        XCTAssertEqual(state, StateResult.from(newState))
    }
    
    func test_loadNextPageActionWhenLoadingState_shouldUpdateStateCorrectly() {
        
        let components = prepareComponents()
        let state = StateResult.loading(
            action: .loadNextPage,
            itemsCount: components.initialState.items.count,
            isNextPageAvailable: components.initialState.isNextPageAvailable)
        
        let newState = components.transformer.transform(actionState: (action: .loadNextPage, activity: .loading), oldState: components.initialState)

        XCTAssertEqual(state, StateResult.from(newState))
    }
    
    func test_loadNextPageActionWhenFailureState_shouldUpdateStateCorrectly() {
        
        let components = prepareComponents()
        let state = StateResult.failure(
            action: .loadNextPage,
            itemsCount: components.initialState.items.count,
            isNextPageAvailable: components.initialState.isNextPageAvailable)
        
        let newState = components.transformer.transform(actionState: (action: .loadNextPage, activity: .failure(DummyError())), oldState: components.initialState)

        XCTAssertEqual(state, StateResult.from(newState))
    }
    
    func test_loadNextPageActionWhenSuccessState_shouldUpdateStateCorrectly() {
        
        let components = prepareComponents()
        let state = StateResult.success(
            action: .loadNextPage,
            itemsCount: 6,
            isNextPageAvailable: true)
        let pageResult = MoviePageResult(movies: components.movieBuilder.build(count: 3), page: 1, isLastPage: false)
        
        let newState = components.transformer.transform(actionState: (action: .loadNextPage, activity: .success(pageResult)), oldState: components.loadedInitialState)

        XCTAssertEqual(state, StateResult.from(newState))
    }
    
    private typealias TestComponents = (
        transformer: PopularListStateTransformer,
        movieBuilder: StubMovieBuilder,
        initialState: PopularListState,
        loadedInitialState: PopularListState
    )
    
    private func prepareComponents() -> TestComponents {
        
        let movieBuilder = StubMovieBuilder()
        
        let movieTransformer = MovieViewDataTransformer().transform(movie:)
        
        let transformer = PopularListStateTransformer(
            errorLocalizer: { _ in "Error" },
            movieTransformer: movieTransformer)
        
        let initialState = PopularListState.initial
        let loadedInitialState = PopularListState(
            activity: .success(()),
            action: .loadInitialPage,
            items: movieBuilder.build(count: 3).map(movieTransformer),
            isNextPageAvailable: true)
        
        return (transformer, movieBuilder, initialState, loadedInitialState)
    }

}
