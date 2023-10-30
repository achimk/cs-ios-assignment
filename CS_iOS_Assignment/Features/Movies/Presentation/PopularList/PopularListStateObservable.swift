//
//  PopularListStateObservable.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 06/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import RxSwift
import RxCocoa

typealias PopularListActionState = (
    action: PopularListAction?,
    activity: ActivityState<MoviePageResult, Error>
)

final class PopularListStateObservable: ObservableConvertibleType {

    private let actionIndicator: ActionStateIndicator<PopularListAction, MoviePageResult>
    private let state = BehaviorRelay(value: PopularListState.initial)
    private let bag = DisposeBag()
    
    var currentState: PopularListState { return state.value }
    
    init(actionIndicator: ActionStateIndicator<PopularListAction, MoviePageResult>,
         errorLocalizer: @escaping (Error) -> String,
         async: Bool = true) {
        
        self.actionIndicator = actionIndicator
        let itemTransformer = MovieViewDataTransformer()
        let listTransformer = PopularListStateTransformer(
            errorLocalizer: errorLocalizer,
            movieTransformer: itemTransformer.transform(movie:))
        
        actionIndicator
            .asObservable()
            .withLatestFrom(state) { ($0, $1) }
            .flatMap({ (actionState, oldState) in
                return Single<PopularListState>.asyncOrCurrent(async, concurrent: true) {
                    return listTransformer.transform(actionState: (actionState.action, actionState.state), oldState: oldState)
                }
            })
            .bind(to: state)
            .disposed(by: bag)
    }
    
    func loadIfNeeded(otherwise: (() -> ())? = nil) {
        if actionIndicator.currentState.state.isInitial {
            loadInitialPage()
        } else {
            otherwise?()
        }
    }
    
    func loadInitialPage() {
        let indicator = actionIndicator.currentState
        
        if indicator.state.isLoading {
            let isAlreadyLoading = indicator.action.map { PopularListAction.loadInitialPage == $0 } ?? false
            if isAlreadyLoading {
                return
            }
        }
        
        actionIndicator.dispatch(.loadInitialPage, force: true)
    }
    
    func loadNextPage() {
        let indicator = actionIndicator.currentState
        
        if indicator.state.isLoading || indicator.state.isInitial {
            return
        }
        
        actionIndicator.dispatch(.loadNextPage)
    }
 
    func asObservable() -> Observable<PopularListState> {
        return state.asObservable()
    }
}
