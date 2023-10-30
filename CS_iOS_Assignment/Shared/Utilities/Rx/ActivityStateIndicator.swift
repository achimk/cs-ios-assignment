//
//  ActivityStateIndicator.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 06/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import RxSwift
import RxCocoa

public final class ActivityStateIndicator<Value>: ObservableConvertibleType {
    
    public typealias State = ActivityState<Value, Error>
    public var currentState: State { return state.value }
    
    private let automaticallySkipsRepeats: Bool
    private let state = BehaviorRelay<State>(value: .initial)
    private let dispatcher = PublishRelay<Bool>()
    private let bag = DisposeBag()
    
    public init(automaticallySkipsRepeats: Bool = true,
                sideEffect: @escaping () -> Single<Value>) {
        
        self.automaticallySkipsRepeats = automaticallySkipsRepeats
        dispatcher
            .withLatestFrom(state) { ($0, $1) }
            .filter { (force, state) in force || !state.isLoading }
            .flatMapLatest { (force, state) -> Observable<State> in
                let loading = Observable
                    .just(State.loading)
                let completion = sideEffect()
                    .map(State.success)
                    .catchError { .just(State.failure($0)) }
                    .asObservable()
                return Observable.concat(loading, completion)
            }
            .bind(to: state)
            .disposed(by: bag)
    }
    
    public func dispatch() {
        dispatcher.accept(false)
    }
    
    public func dispatch(force: Bool) {
        dispatcher.accept(force)
    }
    
    public func asObservable() -> Observable<State> {
        return automaticallySkipsRepeats
            ? state.asObservable().distinctUntilChanged { (lhs, rhs) in lhs.stringValue == rhs.stringValue }
            : state.asObservable()
    }
}
