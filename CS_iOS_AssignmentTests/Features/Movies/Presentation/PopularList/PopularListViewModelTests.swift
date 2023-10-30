//
//  PopularListViewModelTests.swift
//  CS_iOS_AssignmentTests
//
//  Created by Joachim Kret on 07/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
@testable import CS_iOS_Assignment

final class PopularListViewModelTests: XCTestCase {
    
    func test_whenLoadIfNeededInvoked_shouldProduceOutput() {
        let components = prepareComponents()
        let scheduler = TestScheduler(initialClock: 200)
        scheduler.scheduleAt(300, action: {
            components.viewModel.input.loadIfNeeded.onNext(())
        })
        
        let pipeline = scheduler.start {
            return components.viewModel.output.state.asObservable().map { $0.activity.stringValue }
        }
        
        XCTAssertEqual(pipeline.events, [
            .next(200, ActivityStateName.initial.rawValue),
            .next(300, ActivityStateName.loading.rawValue),
            .next(300, ActivityStateName.success.rawValue)
        ]);
    }
    
    func test_whenRefreshInvoked_shouldProduceOutput() {
        let components = prepareComponents()
        let scheduler = TestScheduler(initialClock: 200)
        scheduler.scheduleAt(300, action: {
            components.viewModel.input.refresh.onNext(())
        })
        
        let pipeline = scheduler.start {
            return components.viewModel.output.state.asObservable().map { $0.activity.stringValue }
        }
        
        XCTAssertEqual(pipeline.events, [
            .next(200, ActivityStateName.initial.rawValue),
            .next(300, ActivityStateName.loading.rawValue),
            .next(300, ActivityStateName.success.rawValue)
        ]);
    }
    
    func test_whenLoadNextInvoked_shouldProduceOutput() {
        let components = prepareComponents()
        let scheduler = TestScheduler(initialClock: 200)
        scheduler.scheduleAt(300, action: {
            components.viewModel.input.loadIfNeeded.onNext(())
        })
        scheduler.scheduleAt(400, action: {
            components.viewModel.input.loadNext.onNext(())
        })
        
        let pipeline = scheduler.start {
            return components.viewModel.output.state.asObservable().map { $0.activity.stringValue }
        }
        
        XCTAssertEqual(pipeline.events, [
            .next(200, ActivityStateName.initial.rawValue),
            .next(300, ActivityStateName.loading.rawValue),
            .next(300, ActivityStateName.success.rawValue),
            .next(400, ActivityStateName.loading.rawValue),
            .next(400, ActivityStateName.success.rawValue)
        ]);
    }
    
    private typealias TestComponents = (
        actionIndicator: ActionStateIndicator<PopularListAction, MoviePageResult>,
        stateObservable: PopularListStateObservable,
        viewModel: PopularListViewModel
    )
    
    private func prepareComponents() -> TestComponents {
        
        let actionIndicator = MockPopularListActionStateIndicatorFactory.make()
        
        let stateObservable = PopularListStateObservable(
            actionIndicator: actionIndicator,
            errorLocalizer: { _ in "Error" },
            async: false)
     
        let viewModel = PopularListViewModel(stateObservable: stateObservable)
        
        return (actionIndicator, stateObservable, viewModel)
    }
}
