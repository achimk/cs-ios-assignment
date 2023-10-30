//
//  PopularListViewModel.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 06/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import RxSwift
import RxCocoa

final class PopularListViewModel {
    
    struct Input {
        var loadIfNeeded: Binder<Void>
        var refresh: Binder<Void>
        var loadNext: Binder<Void>
    }
    
    struct Output {
        var state: Driver<PopularListState>
    }
    
    lazy var input: Input = makeInput()
    lazy var output: Output = makeOutput()
    
    private let stateObservable: PopularListStateObservable
    
    init(stateObservable: PopularListStateObservable) {
        self.stateObservable = stateObservable
    }
    
    private func makeInput() -> Input {
        let loadIfNeeded = Binder<Void>(stateObservable, binding: { (stateObservable, _) in
            stateObservable.loadIfNeeded()
        })
        
        let refresh = Binder<Void>(stateObservable, binding: { (stateObservable, _) in
            stateObservable.loadInitialPage()
        })
        
        let loadNext = Binder<Void>(stateObservable, binding: { (stateObservable, _) in
            stateObservable.loadNextPage()
        })
        
        return Input(
            loadIfNeeded: loadIfNeeded,
            refresh: refresh,
            loadNext: loadNext)
    }
    
    private func makeOutput() -> Output {
        let state = stateObservable
            .asObservable()
            .asDriver(onErrorDriveWith: .never())
        
        return Output(state: state)
    }
}
