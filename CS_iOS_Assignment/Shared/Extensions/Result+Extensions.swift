//
//  Result+Extensions.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 06/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import Foundation

extension Result {
    
    public var value: Success? { return analyze(ifSuccess: { $0 }, ifFailure: { _ in nil }) }
    
    public var error: Failure? { return analyze(ifSuccess: { _ in nil }, ifFailure: { $0 }) }
    
    public var isSuccess: Bool { return analyze(ifSuccess: { true }, ifFailure: { false }) }
    
    public var isFailure: Bool { return !isSuccess }
    
}

extension Result {
    
    public func ifSuccess(_ perform: (Success) -> ()) {
        analyze(ifSuccess: perform, ifFailure: { _ in })
    }
    
    public func ifFailure(_ perform: (Failure) -> ()) {
        analyze(ifSuccess: { _ in }, ifFailure: perform)
    }
    
    public func analyze<T>(ifSuccess: () throws -> T, ifFailure: () throws -> T) rethrows -> T {
        switch self {
        case .success: return try ifSuccess()
        case .failure: return try ifFailure()
        }
    }
    
    public func analyze<T>(ifSuccess: (Success) throws -> T, ifFailure: (Failure) throws -> T) rethrows -> T {
        switch self {
        case .success(let value): return try ifSuccess(value)
        case .failure(let error): return try ifFailure(error)
        }
    }
}
