//
//  MockPopularListActionStateIndicatorFactory.swift
//  CS_iOS_AssignmentTests
//
//  Created by Joachim Kret on 07/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import RxSwift
import RxCocoa
@testable import CS_iOS_Assignment

struct MockPopularListActionStateIndicatorFactory {
    
    typealias ActionIndicator = ActionStateIndicator<PopularListAction, MoviePageResult>
    
    struct InterruptableComponents {
        let actionIndicator: ActionIndicator
        let onSuccess: () -> ()
        let onFailure: (Error) -> ()
    }
    
    static let maxPage: Int = 3
    static let movieCountPerPage: Int = 3
    
    static func make() -> ActionIndicator {
        return PopularListActionStateIndicatorFactory.make(pageResultProvider: makePageResultProvider())
    }
    
    static func makeInterruptable() -> InterruptableComponents {
        
        let publisher = PublishSubject<Void>()
        let onSuccess = { publisher.onNext(()) }
        let onFailure = publisher.onError
        
        let provider = makeInterruptableProvider(publisher: publisher)
        let actionIndicator = PopularListActionStateIndicatorFactory.make(pageResultProvider: provider)
        
        return InterruptableComponents(actionIndicator: actionIndicator, onSuccess: onSuccess, onFailure: onFailure)
    }
    
    private static func makePageResultProvider() -> (MoviePageQuery) -> Single<MoviePageResult> {
        
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

    private static func makeInterruptableProvider(publisher: PublishSubject<Void>) -> (MoviePageQuery) -> Single<MoviePageResult> {
        
        let movieBuilder = StubMovieBuilder {
            $0.posterURLGenerator = { index in URL(string: "test\(index).jpg") }
        }

        let producer: (MoviePageResult) -> Single<MoviePageResult> = { result in
            return Single.create { (observer) -> Disposable in
                return publisher.subscribe(
                    onNext: { observer(.success(result)) },
                    onError: { observer(.error($0)) })
            }
        }

        return { query in
            
            if query.value > maxPage {
                let result = MoviePageResult(
                    movies: [],
                    page: query.value,
                    isLastPage: true)
                return producer(result)
            }
            
            let result = MoviePageResult(
                movies: movieBuilder.build(count: movieCountPerPage),
                page: query.value,
                isLastPage: query.value == maxPage)
            return producer(result)
        }
    }

}
