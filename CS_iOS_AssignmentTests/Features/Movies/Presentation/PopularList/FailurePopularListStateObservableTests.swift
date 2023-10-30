//
//  FailurePopularListStateObservableTests.swift
//  CS_iOS_AssignmentTests
//
//  Created by Joachim Kret on 07/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
@testable import CS_iOS_Assignment

final class FailurePopularListStateObservableTests: PopularListStateObservableTestCase {
 
    struct DummyError: Error { }
    
    func test_whenLoadInitialPageFailure_shouldUpdateStateCorrectly() {
     
        let components = prepareComponents()
        
        let scheduler = TestScheduler(initialClock: 200)
        scheduler.scheduleAt(300, action: components.stateObservable.loadInitialPage)
        scheduler.scheduleAt(400, action: { components.onFailure(DummyError()) })
        
        let pipeline = scheduler.start {
            return components.stateObservable.asObservable().map { StateResult.from($0) }
        }

        XCTAssertEqual(pipeline.events, [
            .next(200, StateResult.initial(itemsCount: 0)),
            .next(300, StateResult.loading(itemsCount: 0)),
            .next(400, StateResult.failure(itemsCount: 0)),
        ]);
    }
    
    func test_whenLoadNextPageFailure_shouldUpdateStateCorrectly() {
        
        let components = prepareComponents()
        
        let scheduler = TestScheduler(initialClock: 200)
        scheduler.scheduleAt(300, action: components.stateObservable.loadInitialPage)
        scheduler.scheduleAt(400, action: components.onSuccess)
        scheduler.scheduleAt(500, action: components.stateObservable.loadNextPage)
        scheduler.scheduleAt(600, action: { components.onFailure(DummyError()) })
        
        let pipeline = scheduler.start {
            return components.stateObservable.asObservable().map { StateResult.from($0) }
        }

        XCTAssertEqual(pipeline.events, [
            .next(200, StateResult.initial(itemsCount: 0)),
            .next(300, StateResult.loading(itemsCount: 0)),
            .next(400, StateResult.success(itemsCount: 3)),
            .next(500, StateResult.loading(itemsCount: 3)),
            .next(600, StateResult.failure(itemsCount: 3)),
        ]);
    }
    
    typealias TestComponents = (
        actionIndicator: ActionStateIndicator<PopularListAction, MoviePageResult>,
        stateObservable: PopularListStateObservable,
        onSuccess: () -> (),
        onFailure: (Error) -> ()
    )
    
    func prepareComponents() -> TestComponents {
        
        let components = MockPopularListActionStateIndicatorFactory.makeInterruptable()
        
        let stateObservable = PopularListStateObservable(
            actionIndicator: components.actionIndicator,
            errorLocalizer: { _ in "Error" },
            async: false)
        
        return (components.actionIndicator, stateObservable, components.onSuccess, components.onFailure)
    }

}
