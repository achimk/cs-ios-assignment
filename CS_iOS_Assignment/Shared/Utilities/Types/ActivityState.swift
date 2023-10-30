//
//  ActivityState.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 06/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import Foundation

public enum ActivityStateName: String {
    case initial = "initial"
    case loading = "loading"
    case success = "success"
    case failure = "failure"
}

public enum ActivityState<Success, Failure> {
    case initial
    case loading
    case success(Success)
    case failure(Failure)
}

extension ActivityState {
    
    public var isInitial: Bool {
        if case .initial = self { return true }
        else { return false }
    }
    
    public var isLoading: Bool {
        if case .loading = self { return true }
        else { return false }
    }
    
    public var isSuccess: Bool {
        if case .success = self { return true }
        else { return false }
    }
    
    public var isFailure: Bool {
        if case .failure = self { return true }
        else { return false }
    }
    
    public var isFinish: Bool {
        return isSuccess || isFailure
    }
    
    public func ifInitial(_ action: () -> ()) {
        if case .initial = self { action() }
    }
    
    public func ifLoading(_ action: () -> ()) {
        if case .loading = self { action() }
    }
    
    public func ifSuccess(_ action: (Success) -> ()) {
        if case .success(let value) = self { action(value) }
    }
    
    public func ifFailure(_ action: (Failure) -> ()) {
        if case .failure(let error) = self { action(error) }
    }
    
    public func ifFinish(_ action: () -> ()) {
        if isFinish{ action() }
    }
}

extension ActivityState {
    
    public func map<U>(_ f: (Success) -> U) -> ActivityState<U, Failure> {
        switch self {
        case .initial: return .initial
        case .loading: return .loading
        case .success(let value): return .success(f(value))
        case .failure(let error): return .failure(error)
        }
    }
    
    public func mapError<U>(_ f: (Failure) -> U) -> ActivityState<Success, U> {
        switch self {
        case .initial: return .initial
        case .loading: return .loading
        case .success(let value): return .success(value)
        case .failure(let error): return .failure(f(error))
        }
    }
}

extension ActivityState {
    
    public var stringValue: String {
        switch self {
        case .initial: return ActivityStateName.initial.rawValue
        case .loading: return ActivityStateName.loading.rawValue
        case .success: return ActivityStateName.success.rawValue
        case .failure: return ActivityStateName.failure.rawValue
        }
    }
    
    public var value: Success? {
        switch self {
        case .initial: return nil
        case .loading: return nil
        case .success(let value): return value
        case .failure: return nil
        }
    }
    
    public var error: Failure? {
        switch self {
        case .initial: return nil
        case .loading: return nil
        case .success: return nil
        case .failure(let error): return error
        }
    }
}

extension ActivityState where Failure: Swift.Error {
    
    public var result: Result<Success, Failure>? {
        switch self {
        case .initial: return nil
        case .loading: return nil
        case .success(let value): return .success(value)
        case .failure(let error): return .failure(error)
        }
    }
}

extension ActivityState: Equatable where Success: Equatable, Failure: Equatable {
    
    public static func ==(lhs: ActivityState<Success, Failure>, rhs: ActivityState<Success, Failure>) -> Bool {
        switch (lhs, rhs) {
        case (.initial, .initial): return true
        case (.loading, .loading): return true
        case let (.success(l), .success(r)): return l == r
        case let (.failure(l), .failure(r)): return l == r
        default: return false
        }
    }
}
