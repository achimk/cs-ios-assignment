//
//  PopularListStateTransformer.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 07/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import Foundation

struct PopularListStateTransformer {
    
    let errorLocalizer: (Error) -> String
    let movieTransformer: (Movie) -> MovieViewData
    
    func transform(actionState: PopularListActionState, oldState: PopularListState) -> PopularListState {
        
        guard let action = actionState.action else {
            return oldState
        }
        
        switch action {
        case .loadInitialPage:
            return transformInitialPage(activity: actionState.activity, oldState: oldState)
        case .loadNextPage:
            return transformNextPage(activity: actionState.activity, oldState: oldState)
        }
    }
    
    func transformInitialPage(activity: ActivityState<MoviePageResult, Error>, oldState: PopularListState) -> PopularListState {
        
        switch activity {
        case .initial:
            return oldState
        case .loading:
            return PopularListState(
                activity: .loading,
                action: .loadInitialPage,
                items: oldState.items,
                isNextPageAvailable: oldState.isNextPageAvailable)
        case .failure(let error):
            return PopularListState(
                activity: .failure(errorLocalizer(error)),
                action: .loadInitialPage,
                items: oldState.items,
                isNextPageAvailable: oldState.isNextPageAvailable)
        case .success(let result):
            return PopularListState(
                activity: .success(()),
                action: .loadInitialPage,
                items: result.movies.map(movieTransformer),
                isNextPageAvailable: !result.isLastPage)
        }
    }
    
    func transformNextPage(activity: ActivityState<MoviePageResult, Error>, oldState: PopularListState) -> PopularListState {
        
        switch activity {
        case .initial:
            return oldState
        case .loading:
            return PopularListState(
                activity: .loading,
                action: .loadNextPage,
                items: oldState.items,
                isNextPageAvailable: oldState.isNextPageAvailable)
        case .failure(let error):
            return PopularListState(
                activity: .failure(errorLocalizer(error)),
                action: .loadNextPage,
                items: oldState.items,
                isNextPageAvailable: oldState.isNextPageAvailable)
        case .success(let result):
            return PopularListState(
                activity: .success(()),
                action: .loadNextPage,
                items: oldState.items + result.movies.map(movieTransformer),
                isNextPageAvailable: !result.isLastPage)
        }
    }
}
