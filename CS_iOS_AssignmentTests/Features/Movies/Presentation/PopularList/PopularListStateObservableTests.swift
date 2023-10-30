//
//  PopularListStateObservableTests.swift
//  CS_iOS_AssignmentTests
//
//  Created by Joachim Kret on 06/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
@testable import CS_iOS_Assignment

final class PopularListStateObservableTests: PopularListStateObservableTestCase {

    func test_loadIfNeededWhenEmpty_shouldUpdateStateCorrectly() {
        
        let components = prepareComponents()
        
        let scheduler = TestScheduler(initialClock: 200)
        scheduler.scheduleAt(300, action: { components.stateObservable.loadIfNeeded() })
        
        let pipeline = scheduler.start {
            return components.stateObservable.asObservable().map { StateResult.from($0) }
        }

        XCTAssertEqual(pipeline.events, [
            .next(200, StateResult.initial(itemsCount: 0)),
            .next(300, StateResult.loading(itemsCount: 0)),
            .next(300, StateResult.success(itemsCount: 3))
        ]);
    }
    
    func test_ignoreLoadIfNeededWhenNotEmpty_ShouldUpdateStateCorrectly() {
        
        let components = prepareComponents()
        
        let scheduler = TestScheduler(initialClock: 200)
        scheduler.scheduleAt(300, action: components.stateObservable.loadInitialPage)
        scheduler.scheduleAt(400, action: { components.stateObservable.loadIfNeeded() })
        
        let pipeline = scheduler.start {
            return components.stateObservable.asObservable().map { StateResult.from($0) }
        }

        XCTAssertEqual(pipeline.events, [
            .next(200, StateResult.initial(itemsCount: 0)),
            .next(300, StateResult.loading(itemsCount: 0)),
            .next(300, StateResult.success(itemsCount: 3))
        ]);
    }
    
    func test_loadInitialPageWhenEmpty_shouldUpdateStateCorrectly() {
        
        let components = prepareComponents()
        
        let scheduler = TestScheduler(initialClock: 200)
        scheduler.scheduleAt(300, action: components.stateObservable.loadInitialPage)
        
        let pipeline = scheduler.start {
            return components.stateObservable.asObservable().map { StateResult.from($0) }
        }

        XCTAssertEqual(pipeline.events, [
            .next(200, StateResult.initial(itemsCount: 0)),
            .next(300, StateResult.loading(itemsCount: 0)),
            .next(300, StateResult.success(itemsCount: 3))
        ]);
    }
    
    func test_loadNextPageWhenEmpty_shouldIgnoreUpdateState() {
        
        let components = prepareComponents()
        
        let scheduler = TestScheduler(initialClock: 200)
        scheduler.scheduleAt(300, action: components.stateObservable.loadNextPage)
        
        let pipeline = scheduler.start {
            return components.stateObservable.asObservable().map { StateResult.from($0) }
        }

        XCTAssertEqual(pipeline.events, [
            .next(200, StateResult.initial(itemsCount: 0)),
        ]);
    }
    
    func test_loadInitialAndNextPagesAfter_shouldUpdateStateCorrectly() {
        
        let components = prepareComponents()
        
        let scheduler = TestScheduler(initialClock: 200)
        scheduler.scheduleAt(300, action: components.stateObservable.loadInitialPage)
        scheduler.scheduleAt(400, action: components.stateObservable.loadNextPage)
        scheduler.scheduleAt(500, action: components.stateObservable.loadNextPage)
        
        let pipeline = scheduler.start {
            return components.stateObservable.asObservable().map { StateResult.from($0) }
        }

        XCTAssertEqual(pipeline.events, [
            .next(200, StateResult.initial(itemsCount: 0)),
            .next(300, StateResult.loading(itemsCount: 0)),
            .next(300, StateResult.success(itemsCount: 3)),
            .next(400, StateResult.loading(itemsCount: 3)),
            .next(400, StateResult.success(itemsCount: 6)),
            .next(500, StateResult.loading(itemsCount: 6)),
            .next(500, StateResult.success(itemsCount: 9)),
        ]);
    }
    
    func test_loadInitialAfterLoadedPages_shouldUpdateStateCorrectly() {
        
        let components = prepareComponents()
        
        let scheduler = TestScheduler(initialClock: 200)
        scheduler.scheduleAt(300, action: components.stateObservable.loadInitialPage)
        scheduler.scheduleAt(400, action: components.stateObservable.loadNextPage)
        scheduler.scheduleAt(500, action: components.stateObservable.loadNextPage)
        scheduler.scheduleAt(600, action: components.stateObservable.loadInitialPage)
        
        let pipeline = scheduler.start {
            return components.stateObservable.asObservable().map { StateResult.from($0) }
        }

        XCTAssertEqual(pipeline.events, [
            .next(200, StateResult.initial(itemsCount: 0)),
            .next(300, StateResult.loading(itemsCount: 0)),
            .next(300, StateResult.success(itemsCount: 3)),
            .next(400, StateResult.loading(itemsCount: 3)),
            .next(400, StateResult.success(itemsCount: 6)),
            .next(500, StateResult.loading(itemsCount: 6)),
            .next(500, StateResult.success(itemsCount: 9)),
            .next(600, StateResult.loading(itemsCount: 9)),
            .next(600, StateResult.success(itemsCount: 3)),
        ]);
    }
    
    typealias TestComponents = (
        actionIndicator: ActionStateIndicator<PopularListAction, MoviePageResult>,
        stateObservable: PopularListStateObservable
    )
    
    func prepareComponents() -> TestComponents {
        
        let actionIndicator = MockPopularListActionStateIndicatorFactory.make()
        
        let stateObservable = PopularListStateObservable(
            actionIndicator: actionIndicator,
            errorLocalizer: { _ in "Error" },
            async: false)
        
        return (actionIndicator, stateObservable)
    }
}
