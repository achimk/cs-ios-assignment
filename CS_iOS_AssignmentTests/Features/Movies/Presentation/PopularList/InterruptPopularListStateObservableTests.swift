//
//  InterruptPopularListStateObservableTests.swift
//  CS_iOS_AssignmentTests
//
//  Created by Joachim Kret on 07/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
@testable import CS_iOS_Assignment

final class InterruptPopularListStateObservableTests: PopularListStateObservableTestCase {
    
    func test_loadingInitialAndNextPage_shouldUpdateStateCorrectly() {
        
        let components = prepareComponents()
        
        let scheduler = TestScheduler(initialClock: 200)
        scheduler.scheduleAt(300, action: components.stateObservable.loadInitialPage)
        scheduler.scheduleAt(400, action: components.onSuccess)
        scheduler.scheduleAt(500, action: components.stateObservable.loadNextPage)
        scheduler.scheduleAt(600, action: components.onSuccess)
        
        let pipeline = scheduler.start {
            return components.stateObservable.asObservable().map { StateResult.from($0) }
        }

        XCTAssertEqual(pipeline.events, [
            .next(200, StateResult.initial(itemsCount: 0)),
            .next(300, StateResult.loading(itemsCount: 0)),
            .next(400, StateResult.success(itemsCount: 3)),
            .next(500, StateResult.loading(itemsCount: 3)),
            .next(600, StateResult.success(itemsCount: 6)),
        ]);
    }
    
    func test_interruptLoadingNextByLoadInitialPage_shouldUpdateStateCorrectly() {
        
        let components = prepareComponents()
        
        let scheduler = TestScheduler(initialClock: 200)
        scheduler.scheduleAt(300, action: components.stateObservable.loadInitialPage)
        scheduler.scheduleAt(400, action: components.onSuccess)
        scheduler.scheduleAt(500, action: components.stateObservable.loadNextPage)
        scheduler.scheduleAt(600, action: components.stateObservable.loadInitialPage)
        scheduler.scheduleAt(700, action: components.onSuccess)
        
        let pipeline = scheduler.start {
            return components.stateObservable.asObservable().map { StateResult.from($0) }
        }

        XCTAssertEqual(pipeline.events, [
            .next(200, StateResult.initial(itemsCount: 0)),
            .next(300, StateResult.loading(itemsCount: 0)),
            .next(400, StateResult.success(itemsCount: 3)),
            .next(500, StateResult.loading(itemsCount: 3)),
            .next(600, StateResult.loading(itemsCount: 3)),
            .next(700, StateResult.success(itemsCount: 3)),
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
