//
//  ActivityStateIndicatorTests.swift
//  CS_iOS_AssignmentTests
//
//  Created by Joachim Kret on 06/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import RxSwift
import RxCocoa
import XCTest
@testable import CS_iOS_Assignment

final class ActivityStateIndicatorTests: XCTestCase {
    
    struct TestError: Error, Equatable { }
    
    private let internalQueue = DispatchQueue(label: "internal", qos: .background)
    private lazy var internalSchedule: SchedulerType = {
        SerialDispatchQueueScheduler(queue: internalQueue, internalSerialQueueName: "internal")
    }()
    
    func test_initial_state() {
        let state = prepareTestActivityStateIndicator()
        XCTAssertTrue(state.currentState.isInitial)
    }
    
    func test_loading_state() {
        let state = prepareTestActivityStateIndicator(shouldLoading: { true })
        state.dispatch()
        XCTAssertTrue(state.currentState.isLoading)
    }
    
    func test_success_state() {
        let state = prepareTestActivityStateIndicator()
        state.dispatch()
        XCTAssertTrue(state.currentState.isSuccess)
        state.currentState.ifSuccess { (value) in
            XCTAssertTrue(value == 1)
        }
    }
    
    func test_failure_state() {
        let state = prepareTestActivityStateIndicator(shouldFailure: { true })
        state.dispatch()
        XCTAssertTrue(state.currentState.isFailure)
        state.currentState.ifFailure { (error) in
            XCTAssertTrue(error as? TestError != nil)
        }
    }
    
    func test_multiple_states() {
        var shouldLoading = true
        var shouldFailure = false
        
        let state = prepareTestActivityStateIndicator(
            shouldLoading: { shouldLoading },
            shouldFailure: { shouldFailure })
        
        state.dispatch()
        XCTAssertTrue(state.currentState.isLoading)
        
        shouldLoading = false
        shouldFailure = true
        
        state.dispatch(force: true)
        XCTAssertTrue(state.currentState.isFailure)
        
        shouldLoading = false
        shouldFailure = false
        
        state.dispatch()
        XCTAssertTrue(state.currentState.isSuccess)
    }
    
    func test_multipleDispatch_shouldDispatchSequenceInOrder() {
        
        let bag = DisposeBag()
        var states: [String] = []
        var shouldLoading = true
        var shouldFailure = false
        
        let state = prepareTestActivityStateIndicator(
            shouldLoading: { shouldLoading },
            shouldFailure: { shouldFailure })
        state.asObservable().subscribe(onNext: {
            states.append($0.stringValue)
        }).disposed(by: bag)
            
        state.dispatch()
        XCTAssertTrue(states == [
            "initial",
            "loading"
        ])
        
        states = []
        shouldLoading = false
        shouldFailure = true
        
        state.dispatch(force: true)
        XCTAssertTrue(states == [
            "failure"
        ])
        
        states = []
        shouldLoading = false
        shouldFailure = false
        
        state.dispatch()
        XCTAssertTrue(states == [
            "loading",
            "success"
        ])
    }
    
    func test_multipleDispatchWithoutSkipRepeats_shouldDispatchSequenceInOrder() {
        
        let bag = DisposeBag()
        var states: [String] = []
        var shouldLoading = true
        var shouldFailure = false
        
        let state = prepareTestActivityStateIndicator(
            automaticallySkipsRepeats: false,
            shouldLoading: { shouldLoading },
            shouldFailure: { shouldFailure })
        state.asObservable().subscribe(onNext: {
            states.append($0.stringValue)
        }).disposed(by: bag)
            
        state.dispatch()
        XCTAssertTrue(states == [
            "initial",
            "loading"
        ])
        
        states = []
        shouldLoading = false
        shouldFailure = true
        
        state.dispatch(force: true)
        XCTAssertTrue(states == [
            "loading",
            "failure"
        ])
        
        states = []
        shouldLoading = false
        shouldFailure = false
        
        state.dispatch()
        XCTAssertTrue(states == [
            "loading",
            "success"
        ])
    }
    
    func test_dispatchDuringLoading_shouldIgnoreDispatch() {
        var calls = 0
        let state = prepareTestActivityStateIndicator(shouldLoading: { calls += 1; return true })
        state.dispatch()
        state.dispatch()
        XCTAssertTrue(state.currentState.isLoading)
        XCTAssertTrue(calls == 1)
    }
    
    func test_dispatchDuringLoading_shouldDispatchSequenceInOrder() {
        
        let bag = DisposeBag()
        var isLoading = true
        var states: [String] = []
        
        let indicator = prepareTestActivityStateIndicator(shouldLoading: { isLoading })
        indicator.asObservable().subscribe(onNext: {
            states.append($0.stringValue)
        }).disposed(by: bag)
        
        indicator.dispatch()
        isLoading = false
        indicator.dispatch()
        
        XCTAssertTrue(states == [
            "initial",
            "loading"
        ])
    }
    
    func test_forceDispatchDuringLoading_shouldDispatch() {
        var calls = 0
        let state = prepareTestActivityStateIndicator(shouldLoading: { calls += 1; return true })
        state.dispatch()
        state.dispatch(force: true)
        XCTAssertTrue(state.currentState.isLoading)
        XCTAssertTrue(calls == 2)
    }
    
    func test_forceDispatchDuringLoading_shouldDispatchSequenceInOrder() {
        
        let bag = DisposeBag()
        var isLoading = true
        var states: [String] = []
        
        let indicator = prepareTestActivityStateIndicator(shouldLoading: { isLoading })
        indicator.asObservable().subscribe(onNext: {
            states.append($0.stringValue)
        }).disposed(by: bag)
        
        indicator.dispatch()
        isLoading = false
        indicator.dispatch(force: true)
        
        XCTAssertTrue(states == [
            "initial",
            "loading",
            "success"
        ])
    }
    
    func test_forceDispatchDuringLoadingWithoutSkipRepeats_shouldDispatchSequenceInOrder() {
        
        let bag = DisposeBag()
        var isLoading = true
        var states: [String] = []
        
        let indicator = prepareTestActivityStateIndicator(
            automaticallySkipsRepeats: false,
            shouldLoading: { isLoading })
        indicator.asObservable().subscribe(onNext: {
            states.append($0.stringValue)
        }).disposed(by: bag)
        
        indicator.dispatch()
        isLoading = false
        indicator.dispatch(force: true)
        
        XCTAssertTrue(states == [
            "initial",
            "loading",
            "loading",
            "success"
        ])
    }
    
    private func prepareTestActivityStateIndicator(
        automaticallySkipsRepeats skipsRepeats: Bool = true,
        shouldLoading loadingOnAction: @escaping () -> Bool = { false },
        shouldFailure failureOnAction: @escaping () -> Bool = { false },
        reduce: @escaping () -> Single<Int> = { .just(1) }) -> ActivityStateIndicator<Int> {
        
        return ActivityStateIndicator(
            automaticallySkipsRepeats: skipsRepeats,
            sideEffect: { () -> Single<Int> in
                if loadingOnAction() {
                    return .never()
                }
                if failureOnAction() {
                    return .error(TestError())
                }
                return reduce()
            })
    }
}
