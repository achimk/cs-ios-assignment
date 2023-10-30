//
//  MovieDetailsStateTransformerTests.swift
//  CS_iOS_AssignmentTests
//
//  Created by Joachim Kret on 06/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import XCTest
@testable import CS_iOS_Assignment

final class MovieDetailsStateTransformerTests: XCTestCase {
    
    struct DummyError: Error { }
    
    func test_whenTransformInitialActivity_shouldOnlyUpdateActivityState() {
        let components = prepareComponents()
        let newState = components.transformer.transform(activity: .initial, oldState: components.oldState)
        XCTAssertTrue(newState.activity.isInitial)
        XCTAssertEqual(newState.title, nil)
        XCTAssertEqual(newState.overview, nil)
        XCTAssertEqual(newState.subtitle, nil)
        XCTAssertEqual(newState.posterURL, nil)
        XCTAssertEqual(newState.genres, [])
    }
    
    func test_whenTransformLoadingActivity_shouldOnlyUpdateActivityState() {
        let components = prepareComponents()
        let newState = components.transformer.transform(activity: .loading, oldState: components.oldState)
        XCTAssertTrue(newState.activity.isLoading)
        XCTAssertEqual(newState.title, nil)
        XCTAssertEqual(newState.overview, nil)
        XCTAssertEqual(newState.subtitle, nil)
        XCTAssertEqual(newState.posterURL, nil)
        XCTAssertEqual(newState.genres, [])
    }
    
    func test_whenTransformFailureActivity_shouldOnlyUpdateActivityState() {
        let components = prepareComponents()
        let newState = components.transformer.transform(activity: .failure(DummyError()), oldState: components.oldState)
        XCTAssertTrue(newState.activity.isFailure)
        XCTAssertEqual(newState.title, nil)
        XCTAssertEqual(newState.overview, nil)
        XCTAssertEqual(newState.subtitle, nil)
        XCTAssertEqual(newState.posterURL, nil)
        XCTAssertEqual(newState.genres, [])
    }
    
    func test_whenTransformSuccessActivity_shouldUpdateState() {
        let components = prepareComponents()
        let newState = components.transformer.transform(activity: .success(components.details), oldState: components.oldState)
        XCTAssertTrue(newState.activity.isSuccess)
        XCTAssertEqual(newState.title, "Movie title")
        XCTAssertEqual(newState.overview, "Movie overview")
        XCTAssertEqual(newState.subtitle, "January 1, 1970  -  2h 15m")
        XCTAssertEqual(newState.posterURL, URL(string: "test.jpg"))
        XCTAssertEqual(newState.genres, ["SF"])
    }
    
    func test_whenTransformSuccessActivityWithoutReleaseDate_shouldUpdateState() {
        let components = prepareComponents(releaseDate: nil, duration: Duration(135))
        let newState = components.transformer.transform(activity: .success(components.details), oldState: components.oldState)
        XCTAssertTrue(newState.activity.isSuccess)
        XCTAssertEqual(newState.title, "Movie title")
        XCTAssertEqual(newState.overview, "Movie overview")
        XCTAssertEqual(newState.subtitle, "2h 15m")
        XCTAssertEqual(newState.posterURL, URL(string: "test.jpg"))
        XCTAssertEqual(newState.genres, ["SF"])
    }
    
    func test_whenTransformSuccessActivityWithoutDuration_shouldUpdateState() {
        let components = prepareComponents(releaseDate: Date(timeIntervalSince1970: 0), duration: nil)
        let newState = components.transformer.transform(activity: .success(components.details), oldState: components.oldState)
        XCTAssertTrue(newState.activity.isSuccess)
        XCTAssertEqual(newState.title, "Movie title")
        XCTAssertEqual(newState.overview, "Movie overview")
        XCTAssertEqual(newState.subtitle, "January 1, 1970")
        XCTAssertEqual(newState.posterURL, URL(string: "test.jpg"))
        XCTAssertEqual(newState.genres, ["SF"])
    }
    
    private typealias TestComponents = (
        transformer: MovieDetailsStateTransformer,
        oldState: MovieDetailsState,
        details: MovieDetails
    )
    
    private func prepareComponents(
        releaseDate: Date? = Date(timeIntervalSince1970: 0),
        duration: Duration? = Duration(135)) -> TestComponents {
        
        let movieDetailsBuilder = StubMovieDetailsBuilder { (builder) in
            builder.titleGenerator = { _ in "Movie title"}
            builder.overviewGenerator = { _ in "Movie overview"}
            builder.posterURLGenerator = { _ in URL(string: "test.jpg") }
            builder.durationGenerator = { _ in duration }
            builder.releaseRateGenerator = { _ in releaseDate }
            builder.genresGenerator = { _ in ["SF"] }
        }
        
        let transformer = MovieDetailsStateTransformer(errorLocalizer: { _ in "Error" })
        let oldState = MovieDetailsState.initial
        let details = movieDetailsBuilder.build()
        
        return (transformer, oldState, details)
    }
}
