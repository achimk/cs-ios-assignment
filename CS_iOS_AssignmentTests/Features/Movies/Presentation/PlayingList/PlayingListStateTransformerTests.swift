//
//  PlayingListStateTransformerTests.swift
//  CS_iOS_AssignmentTests
//
//  Created by Joachim Kret on 06/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import XCTest
@testable import CS_iOS_Assignment

final class PlayingListStateTransformerTests: XCTestCase {
    
    struct DummyError: Error { }
    
    func test_whenTransformInitialActivity_shouldOnlyUpdateActivityState() {
        let components = prepareComponents()
        let newState = components.transformer.transform(activity: .initial, oldState: components.oldState)
        XCTAssertEqual(newState.activity.isInitial, true)
        XCTAssertEqual(newState.posters.count, 0)
    }
    
    func test_whenTransformLoadingActivity_shouldOnlyUpdateActivityState() {
        let components = prepareComponents()
        let newState = components.transformer.transform(activity: .loading, oldState: components.oldState)
        XCTAssertEqual(newState.activity.isLoading, true)
        XCTAssertEqual(newState.posters.count, 0)
    }
    
    func test_whenTransformFailureActivity_shouldOnlyUpdateActivityState() {
        let components = prepareComponents()
        let newState = components.transformer.transform(activity: .failure(DummyError()), oldState: components.oldState)
        XCTAssertEqual(newState.activity.isFailure, true)
        XCTAssertEqual(newState.posters.count, 0)
    }
    
    func test_whenTransformSuccessActivity_shouldUpdatePosters() {
        let components = prepareComponents(postersCount: 2, moviesCount: 3)
        let newState = components.transformer.transform(activity: .success(components.movies), oldState: components.oldState)
        XCTAssertEqual(newState.activity.isSuccess, true)
        XCTAssertEqual(newState.posters.count, 3)
    }
    
    private typealias TestComponents = (
        transformer: PlayingListStateTransformer,
        oldState: PlayingListState,
        movies: [Movie]
    )
    
    private func prepareComponents(postersCount: Int = 0, moviesCount: Int = 3) -> TestComponents {
        
        let urlGenerator: (Int) -> URL = { index in URL(string: "test\(index).jpg")! }
        let posters = (0..<postersCount).map { index in PosterViewData(url:urlGenerator(index)) }
        let movieBuilder = StubMovieBuilder {
            $0.posterURLGenerator = urlGenerator
        }
        
        let transformer = makeTransformer()
        let oldState = PlayingListState(activity: .initial, posters: posters)
        let movies = movieBuilder.build(count: moviesCount)
        
        return (transformer, oldState, movies)
    }
    
    private func makeTransformer() -> PlayingListStateTransformer {
        return PlayingListStateTransformer(errorLocalizer: { _ in "Error" })
    }
}
