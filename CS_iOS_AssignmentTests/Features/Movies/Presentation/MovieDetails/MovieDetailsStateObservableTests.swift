//
//  MovieDetailsStateObservableTests.swift
//  CS_iOS_AssignmentTests
//
//  Created by Joachim Kret on 06/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
@testable import CS_iOS_Assignment

final class MovieDetailsStateObservableTests: XCTestCase {
 
    func test_whenLoadInvoked_shouldReturnState() throws {
        let components = prepareComponents()
        
        let scheduler = TestScheduler(initialClock: 200)
        scheduler.scheduleAt(300, action: components.stateObservable.load)
        
        let pipeline = scheduler.start {
            return components.stateObservable.asObservable().map { $0.activity.stringValue }
        }

        XCTAssertEqual(pipeline.events, [
            .next(200, ActivityStateName.initial.rawValue),
            .next(300, ActivityStateName.loading.rawValue),
            .next(300, ActivityStateName.success.rawValue)
        ]);
    }
    
    func test_whenLoadIfNeededInvokedFirstTime_shouldNotBeIgnored() {
        let components = prepareComponents()
        
        let scheduler = TestScheduler(initialClock: 200)
        scheduler.scheduleAt(300, action: {
            components.stateObservable.loadIfNeeded()
        })
        
        let pipeline = scheduler.start {
            return components.stateObservable.asObservable().map { $0.activity.stringValue }
        }

        XCTAssertEqual(pipeline.events, [
            .next(200, ActivityStateName.initial.rawValue),
            .next(300, ActivityStateName.loading.rawValue),
            .next(300, ActivityStateName.success.rawValue)
        ]);
    }
    
    func test_whenLoadIfNeededInvokedAfterLoad_shouldBeIgnored() {
        let components = prepareComponents()
        
        let scheduler = TestScheduler(initialClock: 200)
        scheduler.scheduleAt(300, action: components.stateObservable.load)
        scheduler.scheduleAt(400, action: {
            components.stateObservable.loadIfNeeded()
        })
        
        let pipeline = scheduler.start {
            return components.stateObservable.asObservable().map { $0.activity.stringValue }
        }

        XCTAssertEqual(pipeline.events, [
            .next(200, ActivityStateName.initial.rawValue),
            .next(300, ActivityStateName.loading.rawValue),
            .next(300, ActivityStateName.success.rawValue)
        ]);
    }
    
    private typealias TestComponents = (
        activityIndicator: ActivityStateIndicator<MovieDetails>,
        stateObservable: MovieDetailsStateObservable
    )
    
    private func prepareComponents() -> TestComponents {
        
        let movieDetailsBuilder = StubMovieDetailsBuilder { (builder) in
            builder.titleGenerator = { _ in "Movie title"}
            builder.overviewGenerator = { _ in "Movie overview"}
            builder.posterURLGenerator = { _ in URL(string: "test.jpg") }
            builder.durationGenerator = { _ in Duration(135) }
            builder.releaseRateGenerator = { _ in Date(timeIntervalSince1970: 0) }
            builder.genresGenerator = { _ in ["SF"] }
        }
        
        let activityIndicator = ActivityStateIndicator<MovieDetails> { () -> Single<MovieDetails> in
            return Single.just(movieDetailsBuilder.build())
        }
        
        let stateObservable = MovieDetailsStateObservable(
            activityIndicator: activityIndicator,
            errorLocalizer: { _ in "Error" },
            async: false)
        
        return (activityIndicator, stateObservable)
    }
}
