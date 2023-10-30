//
//  PopularListActionStateIndicatorFactoryTests.swift
//  CS_iOS_AssignmentTests
//
//  Created by Joachim Kret on 07/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
@testable import CS_iOS_Assignment

final class PopularListActionStateIndicatorFactoryTests: XCTestCase {
 
    struct StateResult: Equatable {
        let page: Int?
        let isLastPage: Bool?
        let itemsCount: Int?
        let name: String
        
        static func initial(page: Int? = nil, isLastPage: Bool? = nil, itemsCount: Int? = nil) -> StateResult {
            return StateResult(
                page: page,
                isLastPage: isLastPage,
                itemsCount: itemsCount,
                name: ActivityStateName.initial.rawValue)
        }
        
        static func loading(page: Int? = nil, isLastPage: Bool? = nil, itemsCount: Int? = nil) -> StateResult {
            return StateResult(
                page: page,
                isLastPage: isLastPage,
                itemsCount: itemsCount,
                name: ActivityStateName.loading.rawValue)
        }
        
        static func failure(page: Int? = nil, isLastPage: Bool? = nil, itemsCount: Int? = nil) -> StateResult {
            return StateResult(
                page: page,
                isLastPage: isLastPage,
                itemsCount: itemsCount,
                name: ActivityStateName.failure.rawValue)
        }
        
        static func success(page: Int? = nil, isLastPage: Bool? = nil, itemsCount: Int? = nil) -> StateResult {
            return StateResult(
                page: page,
                isLastPage: isLastPage,
                itemsCount: itemsCount,
                name: ActivityStateName.success.rawValue)
        }
        
        
        static func from(_ activity: ActivityState<MoviePageResult, Error>) -> StateResult {
            return StateResult(
                page: activity.value?.page,
                isLastPage: activity.value?.isLastPage,
                itemsCount: activity.value?.movies.count,
                name: activity.stringValue)
        }
    }
    
    func test_whenGeneratingPageResults_shouldIterateInCorrectOrder() {
        let actionIndicator = makeActionIndicator()
        
        let scheduler = TestScheduler(initialClock: 200)
        scheduler.scheduleAt(300, action: { actionIndicator.dispatch(.loadInitialPage) })
        scheduler.scheduleAt(400, action: { actionIndicator.dispatch(.loadNextPage) })
        scheduler.scheduleAt(500, action: { actionIndicator.dispatch(.loadNextPage) })
        scheduler.scheduleAt(600, action: { actionIndicator.dispatch(.loadNextPage) })
        
        let pipeline = scheduler.start {
            return actionIndicator.asObservable().map { StateResult.from($0.state) }
        }

        XCTAssertEqual(pipeline.events, [
            .next(200, StateResult.initial()),
            .next(300, StateResult.loading()),
            .next(300, StateResult.success(page: 1, isLastPage: false, itemsCount: 3)),
            .next(400, StateResult.loading()),
            .next(400, StateResult.success(page: 2, isLastPage: false, itemsCount: 3)),
            .next(500, StateResult.loading()),
            .next(500, StateResult.success(page: 3, isLastPage: true, itemsCount: 3)),
            .next(600, StateResult.loading()),
            .next(600, StateResult.success(page: 4, isLastPage: true, itemsCount: 0))
        ]);
    }
    

    private func makeActionIndicator() -> ActionStateIndicator<PopularListAction, MoviePageResult> {
        let pageResultProvider = makeProvider()
        return PopularListActionStateIndicatorFactory.make(pageResultProvider: pageResultProvider)
    }
    
    private func makeProvider(maxPage: Int = 3, movieCountPerPage: Int = 3) -> (MoviePageQuery) -> Single<MoviePageResult> {
        
        let movieBuilder = StubMovieBuilder {
            $0.posterURLGenerator = { index in URL(string: "test\(index).jpg") }
        }
        
        return { query in
            
            if query.value > maxPage {
                let result = MoviePageResult(
                    movies: [],
                    page: query.value,
                    isLastPage: true)
                return Single.just(result)
            }
            
            let result = MoviePageResult(
                movies: movieBuilder.build(count: movieCountPerPage),
                page: query.value,
                isLastPage: query.value == maxPage)
            return Single.just(result)
        }
    }
}
