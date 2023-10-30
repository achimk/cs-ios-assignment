//
//  MoviesHomeViewModelTests.swift
//  CS_iOS_AssignmentTests
//
//  Created by Joachim Kret on 07/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
@testable import CS_iOS_Assignment

final class MoviesHomeViewModelTests: XCTestCase {
    
    struct DummyError: Error { }
    
    func test_whenLoadIfNeededInvokedFirstTime_shouldNotBeIgnored() {
        
        let components = prepareComponents()
        let scheduler = TestScheduler(initialClock: 200)
        scheduler.scheduleAt(300, action: {
            components.viewModel.input.loadIfNeeded()
        })
        scheduler.scheduleAt(400, action: {
            components.onPopularSuccess()
        })
        
        let pipeline = scheduler.start {
            return components.viewModel.output.isLoading.asObservable()
        }
        
        XCTAssertEqual(pipeline.events, [
            .next(200, false),
            .next(300, true),
            .next(400, false),
        ]);
    }
    
    func test_whenLoadIfNeededInvokedAfterRefresh_shouldBeIgnored() {
        let components = prepareComponents()
        let scheduler = TestScheduler(initialClock: 200)
        scheduler.scheduleAt(300, action: {
            components.viewModel.input.refresh()
        })
        scheduler.scheduleAt(400, action: {
            components.onPopularSuccess()
        })
        scheduler.scheduleAt(500, action: {
            components.viewModel.input.loadIfNeeded()
        })
        
        let pipeline = scheduler.start {
            return components.viewModel.output.isLoading.asObservable()
        }
        
        XCTAssertEqual(pipeline.events, [
            .next(200, false),
            .next(300, true),
            .next(400, false),
        ]);
    }
    
    func test_whenRefreshInvoked_shouldUpdateLoading() {
        let components = prepareComponents()
        let scheduler = TestScheduler(initialClock: 200)
        scheduler.scheduleAt(300, action: {
            components.viewModel.input.refresh()
        })
        scheduler.scheduleAt(400, action: {
            components.onPopularSuccess()
        })
        
        let pipeline = scheduler.start {
            return components.viewModel.output.isLoading.asObservable()
        }
        
        XCTAssertEqual(pipeline.events, [
            .next(200, false),
            .next(300, true),
            .next(400, false),
        ]);
    }
    
    func test_loadNextPageWhenEmpty_shouldBeIgnored() {
        let components = prepareComponents()
        let scheduler = TestScheduler(initialClock: 200)
        scheduler.scheduleAt(300, action: {
            components.viewModel.input.loadNextPage()
        })
        scheduler.scheduleAt(400, action: {
            components.onPopularSuccess()
        })
        
        let pipeline = scheduler.start {
            return components.viewModel.output.isLoading.asObservable()
        }
        
        XCTAssertEqual(pipeline.events, [
            .next(200, false),
        ]);
    }
    
    func test_loadNextPageWhenNotEmpty_shouldNotInvokeLoading() {
        let components = prepareComponents()
        let scheduler = TestScheduler(initialClock: 200)
        scheduler.scheduleAt(300, action: {
            components.viewModel.input.refresh()
        })
        scheduler.scheduleAt(400, action: {
            components.onPopularSuccess()
        })
        scheduler.scheduleAt(500, action: {
            components.viewModel.input.loadNextPage()
        })
        
        let pipeline = scheduler.start {
            return components.viewModel.output.isLoading.asObservable()
        }
        
        XCTAssertEqual(pipeline.events, [
            .next(200, false),
            .next(300, true),
            .next(400, false),
        ]);
    }
    
    func test_loadNextPageWhenNotEmpty_shouldUpdateActivityInCorrectOrder() {
        let components = prepareComponents()
        let scheduler = TestScheduler(initialClock: 200)
        scheduler.scheduleAt(300, action: {
            components.viewModel.input.refresh()
        })
        scheduler.scheduleAt(400, action: {
            components.onPopularSuccess()
        })
        scheduler.scheduleAt(500, action: {
            components.viewModel.input.loadNextPage()
        })
        scheduler.scheduleAt(600, action: {
            components.onPopularSuccess()
        })
        
        let pipeline = scheduler.start {
            return components.viewModel.output.popularState.asObservable().map { $0.activity.stringValue }
        }
        
        XCTAssertEqual(pipeline.events, [
            .next(200, ActivityStateName.initial.rawValue),
            .next(300, ActivityStateName.loading.rawValue),
            .next(400, ActivityStateName.success.rawValue),
            .next(500, ActivityStateName.loading.rawValue),
            .next(600, ActivityStateName.success.rawValue),
        ]);
    }
    
    func test_whenLoadFailure_shouldReturnError() {
        let components = prepareComponents()
        let scheduler = TestScheduler(initialClock: 200)
        scheduler.scheduleAt(300, action: {
            components.viewModel.input.refresh()
        })
        scheduler.scheduleAt(400, action: {
            components.onPopularFailure(DummyError())
        })
        
        let pipeline = scheduler.start {
            return components.viewModel.output.error.asObservable().map { $0.details }
        }
        
        XCTAssertEqual(pipeline.events, [
            .next(400, "PopularError"),
        ]);
    }
    
    func test_whenLoadFailure_shouldUpdateLoading() {
        let components = prepareComponents()
        let scheduler = TestScheduler(initialClock: 200)
        scheduler.scheduleAt(300, action: {
            components.viewModel.input.refresh()
        })
        scheduler.scheduleAt(400, action: {
            components.onPopularFailure(DummyError())
        })
        
        let pipeline = scheduler.start {
            return components.viewModel.output.isLoading.asObservable()
        }
        
        XCTAssertEqual(pipeline.events, [
            .next(200, false),
            .next(300, true),
            .next(400, false),
        ]);
    }
    
    func test_whenLoadSuccess_shouldNotReturnError() {
        let components = prepareComponents()
        let scheduler = TestScheduler(initialClock: 200)
        scheduler.scheduleAt(300, action: {
            components.viewModel.input.refresh()
        })
        scheduler.scheduleAt(400, action: {
            components.onPopularSuccess()
        })
        
        let pipeline = scheduler.start {
            return components.viewModel.output.error.asObservable().map { $0.details }
        }
        
        XCTAssertEqual(pipeline.events, [
        ]);
    }
    
    func test_whenLoadSuccess_shouldUpdateLoading() {
        let components = prepareComponents()
        let scheduler = TestScheduler(initialClock: 200)
        scheduler.scheduleAt(300, action: {
            components.viewModel.input.refresh()
        })
        scheduler.scheduleAt(400, action: {
            components.onPopularSuccess()
        })
        
        let pipeline = scheduler.start {
            return components.viewModel.output.isLoading.asObservable()
        }
        
        XCTAssertEqual(pipeline.events, [
            .next(200, false),
            .next(300, true),
            .next(400, false),
        ]);
    }
    
    private typealias TestComponents = (
        playingStateObservable: PlayingListStateObservable,
        popularStateObservable: PopularListStateObservable,
        viewModel: MoviesHomeViewModel,
        onPopularSuccess: () -> (),
        onPopularFailure: (Error) -> ()
    )
    
    private func prepareComponents() -> TestComponents {
        let playingStateObservable = makePlayingListStateObservable()
        let popularComponents = makePopularComponents()
        let viewModel = MoviesHomeViewModel(
            playingListStateObservable: playingStateObservable,
            popularListStateObservable: popularComponents.stateObservable)
        
        return (playingStateObservable, popularComponents.stateObservable, viewModel, popularComponents.onSuccess, popularComponents.onFailure)
    }
    
    private func makePopularComponents() -> (stateObservable: PopularListStateObservable, onSuccess: () -> (), onFailure: (Error) -> ()) {
        let components = MockPopularListActionStateIndicatorFactory.makeInterruptable()
        let stateObservable = PopularListStateObservable(
            actionIndicator: components.actionIndicator,
            errorLocalizer: { _ in "PopularError" },
            async: false)
        
        return (stateObservable, components.onSuccess, components.onFailure)
    }

    
    private func makePlayingListStateObservable(moviesCount: Int = 3) -> PlayingListStateObservable {
        let urlGenerator: (Int) -> URL = { index in URL(string: "test\(index).jpg")! }
        let movieBuilder = StubMovieBuilder {
            $0.posterURLGenerator = urlGenerator
        }
        
        let activityIndicator = ActivityStateIndicator<[Movie]> { () -> Single<[Movie]> in
            return Single.just(movieBuilder.build(count: moviesCount))
        }
        
        let stateObservable = PlayingListStateObservable(
            activityIndicator: activityIndicator,
            errorLocalizer: { _ in "PlayingError" },
            async: false)
        
        return stateObservable
    }

}
