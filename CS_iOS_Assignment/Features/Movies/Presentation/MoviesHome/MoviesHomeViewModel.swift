//
//  MoviesHomeViewModel.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 07/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import RxSwift
import RxCocoa

class MoviesHomeViewModel {
    
    struct Input {
        var loadIfNeeded: () -> ()
        var refresh: () -> ()
        var loadNextPage: () -> ()
    }
    
    struct Output {
        var isLoading: Driver<Bool>
        var error: Signal<MoviesHomeErrorViewData>
        var playingState: Driver<PlayingListState>
        var popularState: Driver<PopularListState>
    }
    
    lazy var input: Input = makeInput()
    lazy var output: Output = makeOutput()
    
    private let isLoading = BehaviorRelay(value: false)
    private let errorPublisher = PublishRelay<MoviesHomeErrorViewData>()
    private let playingListStateObservable: PlayingListStateObservable
    private let popularListStateObservable: PopularListStateObservable
    private let bag = DisposeBag()
    
    private var isInitial: Bool {
        return playingListStateObservable.currentState.activity.isInitial
            && popularListStateObservable.currentState.activity.isInitial
    }
    
    init(playingListStateObservable: PlayingListStateObservable,
         popularListStateObservable: PopularListStateObservable) {
        self.playingListStateObservable = playingListStateObservable
        self.popularListStateObservable = popularListStateObservable
        makeBinding()
    }
    
    private func makeInput() -> Input {
        
        let loadIfNeeded: () -> () = { [weak self] in
            self?.loadIfNeeded()
        }
        
        let refresh: () -> () = { [weak self] in
            self?.refresh()
        }
        
        let loadNextPage: () -> () = { [weak self] in
            self?.loadNextPage()
        }
        
        return Input(
            loadIfNeeded: loadIfNeeded,
            refresh: refresh,
            loadNextPage: loadNextPage)
    }
    
    private func makeOutput() -> Output {
        let isLoading = self.isLoading.asDriver()
        let error = errorPublisher.asSignal()
        let playingState = playingListStateObservable.asDriver(onErrorDriveWith: .never())
        let popularState = popularListStateObservable.asDriver(onErrorDriveWith: .never())
        
        return Output(
            isLoading: isLoading,
            error: error,
            playingState: playingState,
            popularState: popularState)
    }
    
    private func makeBinding() {
        let states = Observable.combineLatest(
            playingListStateObservable.asObservable(),
            popularListStateObservable.asObservable())
        
        // handle load
        isLoading
            .filter { $0 }
            .subscribe(onNext: { [playingListStateObservable, popularListStateObservable] _ in
                playingListStateObservable.load()
                popularListStateObservable.loadInitialPage()
            }).disposed(by: bag)
        
        // Handle error signal updates
        isLoading
            .filter { $0 }
            .flatMapLatest { _ in states }
            .compactMap(MoviesHomeErrorStateTransformer().transform(playingListState:popularListState:))
            .bind(to: errorPublisher)
            .disposed(by: bag)
        
        // Handle isLoading updates
        isLoading
            .filter { $0 }
            .flatMapLatest { _ in states }
            .map(MoviesHomeIsLoadingStateTransformer().transform(playingListState:popularListState:))
            .filter { !$0 }
            .bind(to: isLoading)
            .disposed(by: bag)
    }
    
    private func loadIfNeeded() {
        if isInitial && isLoading.value == false {
            isLoading.accept(true)
        }
    }
    
    private func refresh() {
        if isLoading.value == false {
            isLoading.accept(true)
        }
    }
    
    private func loadNextPage() {
        popularListStateObservable.loadNextPage()
    }
}
