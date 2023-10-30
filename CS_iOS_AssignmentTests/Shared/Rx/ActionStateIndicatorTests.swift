//
//  ActionStateIndicatorTests.swift
//  CS_iOS_AssignmentTests
//
//  Created by Joachim Kret on 06/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import RxSwift
import RxCocoa
import XCTest
@testable import CS_iOS_Assignment

final class ActionStateIndicatorTests: XCTestCase {
    
    struct TestError: Error, Equatable { }
    
    enum Action: Equatable {
        case get
        case update
        case delete
    }
    
    struct ActionState: Equatable {
        let action: Action?
        let state: String
        init(_ action: Action?, _ state: String) {
            self.action = action
            self.state = state
        }
    }
    
    private let internalQueue = DispatchQueue(label: "internal", qos: .background)
    private lazy var internalSchedule: SchedulerType = {
        SerialDispatchQueueScheduler(queue: internalQueue, internalSerialQueueName: "internal")
    }()
    
    func test_initial_state() {
        let indicator = prepareTestActionStateIndicator()
        XCTAssertFalse(indicator.currentState.action.isPresent)
        XCTAssertTrue(indicator.currentState.state.isInitial)
    }
    
    func test_loading_state() {
        let indicator = prepareTestActionStateIndicator(shouldLoading: { _ in true })
        indicator.dispatch(.get)
        XCTAssertTrue(indicator.currentState.action == .get)
        XCTAssertTrue(indicator.currentState.state.isLoading)
    }
    
    func test_success_state() {
        let indicator = prepareTestActionStateIndicator()
        indicator.dispatch(.get)
        XCTAssertTrue(indicator.currentState.action == .get)
        XCTAssertTrue(indicator.currentState.state.isSuccess)
        indicator.currentState.state.ifSuccess { (value) in
            XCTAssertTrue(value == 1)
        }
    }
    
    func test_failure_state() {
        let indicator = prepareTestActionStateIndicator(shouldFailure: { _ in true })
        indicator.dispatch(.get)
        XCTAssertTrue(indicator.currentState.action == .get)
        XCTAssertTrue(indicator.currentState.state.isFailure)
        indicator.currentState.state.ifFailure { (error) in
            XCTAssertTrue(error as? TestError != nil)
        }
    }
    
    func test_multiple_states() {
        var shouldLoading = true
        var shouldFailure = false
        
        let indicator = prepareTestActionStateIndicator(
            shouldLoading: { _ in shouldLoading },
            shouldFailure: { _ in shouldFailure })
        
        indicator.dispatch(.get)
        XCTAssertTrue(indicator.currentState.action == .get)
        XCTAssertTrue(indicator.currentState.state.isLoading)
        
        shouldLoading = false
        shouldFailure = true
        
        indicator.dispatch(.update, force: true)
        XCTAssertTrue(indicator.currentState.action == .update)
        XCTAssertTrue(indicator.currentState.state.isFailure)
        
        shouldLoading = false
        shouldFailure = false
        
        indicator.dispatch(.delete)
        XCTAssertTrue(indicator.currentState.action == .delete)
        XCTAssertTrue(indicator.currentState.state.isSuccess)
    }
    
    func test_dispatchDuringLoading_shouldIgnoreDispatch() {
        let indicator = prepareTestActionStateIndicator(shouldLoading: { $0 == .get })
        indicator.dispatch(.get)
        indicator.dispatch(.update)
        XCTAssertTrue(indicator.currentState.action == .get)
        XCTAssertTrue(indicator.currentState.state.isLoading)
    }
    
    func test_dispatchDuringLoading_shouldDispatchSequenceInOrder() {
        
        let bag = DisposeBag()
        var actionStates: [ActionState] = []
        
        let indicator = prepareTestActionStateIndicator(shouldLoading: { $0 == .get })
        indicator.asObservable().subscribe(onNext: {
            actionStates.append(ActionState($0.action, $0.state.stringValue))
        }).disposed(by: bag)
        
        indicator.dispatch(.get)
        indicator.dispatch(.update)
        
        XCTAssertTrue(actionStates == [
            .init(nil, "initial"),
            .init(.get, "loading")
        ])
    }
    
    func test_forceDispatchDuringLoading_shouldDispatch() {
        let indicator = prepareTestActionStateIndicator(shouldLoading: { $0 == .get })
        indicator.dispatch(.get)
        indicator.dispatch(.update, force: true)
        XCTAssertTrue(indicator.currentState.action == .update)
        XCTAssertTrue(indicator.currentState.state.isSuccess)
        indicator.currentState.state.ifSuccess { (value) in
            XCTAssertTrue(value == 2)
        }
    }
    
    func test_forceDispatchDuringLoading_shouldDispatchSequenceInOrder() {
        
        let bag = DisposeBag()
        var actionStates: [ActionState] = []
        
        let indicator = prepareTestActionStateIndicator(shouldLoading: { $0 == .get })
        indicator.asObservable().subscribe(onNext: {
            actionStates.append(ActionState($0.action, $0.state.stringValue))
        }).disposed(by: bag)
        
        indicator.dispatch(.get)
        indicator.dispatch(.update, force: true)
        
        XCTAssertTrue(actionStates == [
            .init(nil, "initial"),
            .init(.get, "loading"),
            .init(.update, "success")
        ])
    }
    
    func test_forceDispatchDuringLoadingWithoutSkipRepeats_shouldDispatchSequenceInOrder() {
        
        let bag = DisposeBag()
        var actionStates: [ActionState] = []
        
        let indicator = prepareTestActionStateIndicator(
            automaticallySkipRepeats: false,
            shouldLoading: { $0 == .get })
        indicator.asObservable().subscribe(onNext: {
            actionStates.append(ActionState($0.action, $0.state.stringValue))
        }).disposed(by: bag)
        
        indicator.dispatch(.get)
        indicator.dispatch(.update, force: true)
        
        XCTAssertTrue(actionStates == [
            .init(nil, "initial"),
            .init(.get, "loading"),
            .init(.update, "loading"),
            .init(.update, "success")
        ])
    }
    
    private func prepareTestActionStateIndicator(
        automaticallySkipRepeats: Bool = true,
        shouldLoading loadingOnAction: @escaping (Action) -> Bool = { _ in false },
        shouldFailure failureOnAction: @escaping (Action) -> Bool = { _ in false },
        reduce: ((Action) -> Single<Int>)? = nil) -> ActionStateIndicator<Action, Int> {

        let reduce = reduce.or { (action) -> Single<Int> in
            switch action {
            case .get: return .just(1)
            case .update: return .just(2)
            case .delete: return .just(3)
            }
        }
        
        return ActionStateIndicator<Action, Int>(
            automaticallySkipRepeats: automaticallySkipRepeats,
            sideEffect: { (action) -> Single<Int> in
                if loadingOnAction(action) {
                    return .never()
                }
                if failureOnAction(action) {
                    return .error(TestError())
                }
                return reduce(action)
            })
    }
}
