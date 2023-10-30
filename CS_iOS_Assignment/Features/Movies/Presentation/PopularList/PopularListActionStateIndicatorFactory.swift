//
//  PopularListActionStateIndicatorFactory.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 07/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import RxSwift

struct PopularListActionStateIndicatorFactory {
    
    static func make(pageResultProvider: @escaping (MoviePageQuery) -> Single<MoviePageResult>) -> ActionStateIndicator<PopularListAction, MoviePageResult> {
        return ActionStateIndicator(automaticallySkipRepeats: false, sideEffect: makeSideEffect(from: pageResultProvider))
    }
    
    private static func makeSideEffect(from pageResultProvider: @escaping (MoviePageQuery) -> Single<MoviePageResult>) -> (PopularListAction) -> Single<MoviePageResult> {
        
        let initialPage = MoviePageQuery.initial
        var currentPage = initialPage
        return { action in
            switch action {
            case .loadInitialPage:
                return pageResultProvider(initialPage)
                    .do(onSuccess: { _ in currentPage = initialPage.nextPage() })
            case .loadNextPage:
                return pageResultProvider(currentPage)
                    .do(onSuccess: { _ in currentPage = currentPage.nextPage() })
            }
        }
    }
}
