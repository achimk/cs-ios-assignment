//
//  PlayingListStateObservableTests.swift
//  CS_iOS_AssignmentTests
//
//  Created by Joachim Kret on 06/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
@testable import CS_iOS_Assignment

final class PlayingListStateObservableTests: XCTestCase {
    
    func test_whenLoadInvoked_shouldReturnState() throws {
        let components = prepareComponents(moviesCount: 3)
        
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
        let components = prepareComponents(moviesCount: 3)
        
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
        let components = prepareComponents(moviesCount: 3)
        
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
        activityIndicator: ActivityStateIndicator<[Movie]>,
        stateObservable: PlayingListStateObservable
    )
    
    private func prepareComponents(moviesCount: Int) -> TestComponents {
        
        let urlGenerator: (Int) -> URL = { index in URL(string: "test\(index).jpg")! }
        let movieBuilder = StubMovieBuilder {
            $0.posterURLGenerator = urlGenerator
        }
        
        let activityIndicator = ActivityStateIndicator<[Movie]> { () -> Single<[Movie]> in
            return Single.just(movieBuilder.build(count: moviesCount))
        }
        
        let stateObservable = PlayingListStateObservable(
            activityIndicator: activityIndicator,
            errorLocalizer: { _ in "Error" },
            async: false)
        
        return (activityIndicator, stateObservable)
    }
}
