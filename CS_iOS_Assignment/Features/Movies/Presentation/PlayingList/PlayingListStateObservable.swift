//
//  PlayingListStateObservable.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 06/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import RxSwift
import RxCocoa

final class PlayingListStateObservable: ObservableConvertibleType {
    
    private let activityIndicator: ActivityStateIndicator<[Movie]>
    private let state = BehaviorRelay(value: PlayingListState.initial)
    private let bag = DisposeBag()
    
    var currentState: PlayingListState { return state.value }

    init(activityIndicator: ActivityStateIndicator<[Movie]>,
         errorLocalizer: @escaping (Error) -> String,
         async: Bool = true) {
        
        self.activityIndicator = activityIndicator
        let transformer = PlayingListStateTransformer(errorLocalizer: errorLocalizer)
        activityIndicator
            .asObservable()
            .withLatestFrom(state) { ($0, $1) }
            .flatMap({ (activity: ActivityState<[Movie], Error>, state: PlayingListState) in
                return Single<PlayingListState>.asyncOrCurrent(async, concurrent: true) {
                    return transformer.transform(activity: activity, oldState: state)
                }
            })
            .bind(to: state)
            .disposed(by: bag)
    }
    
    func loadIfNeeded(otherwise: (() -> ())? = nil) {
        if activityIndicator.currentState.isInitial {
            load()
        } else {
            otherwise?()
        }
    }
    
    func load() {
        activityIndicator.dispatch()
    }
    
    func asObservable() -> Observable<PlayingListState> {
        return state.asObservable()
    }
}

