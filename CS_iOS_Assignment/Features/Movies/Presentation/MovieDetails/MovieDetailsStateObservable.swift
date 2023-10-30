//
//  MovieDetailsStateObservable.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 06/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import RxSwift
import RxCocoa

final class MovieDetailsStateObservable: ObservableConvertibleType {
    
    private let activityIndicator: ActivityStateIndicator<MovieDetails>
    private let state = BehaviorRelay(value: MovieDetailsState.initial)
    private let bag = DisposeBag()
    
    var currentState: MovieDetailsState { return state.value }
    
    init(activityIndicator: ActivityStateIndicator<MovieDetails>,
         errorLocalizer: @escaping (Error) -> String,
         async: Bool = true) {
        
        self.activityIndicator = activityIndicator
        let transformer = MovieDetailsStateTransformer(errorLocalizer: errorLocalizer)
        activityIndicator
            .asObservable()
            .withLatestFrom(state) { ($0, $1) }
            .flatMap({ (activity: ActivityState<MovieDetails, Error>, state: MovieDetailsState) in
                return Single<MovieDetailsState>.asyncOrCurrent(async, concurrent: true) {
                    return transformer.transform(activity: activity, oldState: state)
                }
            })
            .bind(to: state)
            .disposed(by: bag)
    }
    
    func loadIfNeeded() {
        if activityIndicator.currentState.isInitial {
            load()
        }
    }
    
    func load() {
        activityIndicator.dispatch()
    }
    
    func asObservable() -> Observable<MovieDetailsState> {
        return state.asObservable()
    }
}
