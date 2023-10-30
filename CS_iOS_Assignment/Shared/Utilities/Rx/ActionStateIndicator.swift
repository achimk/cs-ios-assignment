//
//  ActionStateIndicator.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 06/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import RxSwift
import RxCocoa

public final class ActionStateIndicator<Action, Value>: ObservableConvertibleType {
    
    public typealias State = ActivityState<Value, Error>
    public typealias ActionState = (action: Action?, state: State)
    public var currentState: ActionState { return state.value }
    
    private let automaticallySkipRepeats: Bool
    private let state = BehaviorRelay<ActionState>(value: (nil, .initial))
    private let dispatcher = PublishRelay<(Action, Bool)>()
    private let bag = DisposeBag()
    
    public init(automaticallySkipRepeats: Bool = true,
                sideEffect: @escaping (Action) -> Single<Value>) {
        
        self.automaticallySkipRepeats = automaticallySkipRepeats
        dispatcher
            .withLatestFrom(state) { ($0.1, $0.0, $1.state) }
            .filter { (force, _, state) in force || !state.isLoading }
            .flatMapLatest { (_, action, state) -> Observable<ActionState> in
                let loading = Observable
                    .just((action: Optional(action), state: State.loading))
                let completion = sideEffect(action)
                    .map { (action: Optional(action), state: State.success($0)) }
                    .catchError { .just((action: Optional(action), state: State.failure($0))) }
                    .asObservable()
                return Observable
                    .concat(loading, completion)
            }
            .bind(to: state)
            .disposed(by: bag)
    }
    
    public func dispatch(_ action: Action) {
        dispatcher.accept((action, false))
    }
    
    public func dispatch(_ action: Action, force: Bool) {
        dispatcher.accept((action, force))
    }
    
    public func asObservable() -> Observable<ActionState> {
        return automaticallySkipRepeats
            ? state.asObservable().distinctUntilChanged { (lhs, rhs) in lhs.state.stringValue == rhs.state.stringValue }
            : state.asObservable()
    }
}
