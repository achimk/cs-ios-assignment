//
//  PlayingListViewModel.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 06/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import RxSwift
import RxCocoa

final class PlayingListViewModel {
    
    struct Input {
        var loadIfNeeded: Binder<Void>
        var refresh: Binder<Void>
    }
    
    struct Output {
        var state: Driver<PlayingListState>
    }
    
    lazy var input: Input = makeInput()
    lazy var output: Output = makeOutput()
    
    private let stateObservable: PlayingListStateObservable
    
    init(stateObservable: PlayingListStateObservable) {
        self.stateObservable = stateObservable
    }
    
    private func makeInput() -> Input {
        let loadIfNeeded = Binder<Void>(stateObservable, binding: { (stateObservable, _) in
            stateObservable.loadIfNeeded()
        })
        
        let refresh = Binder<Void>(stateObservable, binding: { (stateObservable, _) in
            stateObservable.load()
        })
        
        return Input(
            loadIfNeeded: loadIfNeeded,
            refresh: refresh)
    }
    
    private func makeOutput() -> Output {
        let state = stateObservable
            .asObservable()
            .asDriver(onErrorDriveWith: .never())
        
        return Output(state: state)
    }
}
