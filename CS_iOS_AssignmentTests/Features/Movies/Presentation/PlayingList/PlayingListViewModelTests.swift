//
//  PlayingListViewModelTests.swift
//  CS_iOS_AssignmentTests
//
//  Created by Joachim Kret on 06/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
@testable import CS_iOS_Assignment

final class PlayingListViewModelTests: XCTestCase {
    
    func test_whenLoadIfNeededInvoked_shouldProduceOutput() {
        let components = prepareComponents(moviesCount: 3)
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
        let components = prepareComponents(moviesCount: 3)
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
    
    private typealias TestComponents = (
        activityIndicator: ActivityStateIndicator<[Movie]>,
        stateObservable: PlayingListStateObservable,
        viewModel: PlayingListViewModel
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
        
        let viewModel = PlayingListViewModel(stateObservable: stateObservable)
        
        return (activityIndicator, stateObservable, viewModel)
    }
}
