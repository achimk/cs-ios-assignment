//
//  Optional+Present.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 06/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import Foundation

extension Optional {
    
    public func ifPresent(_ action: (Wrapped) -> ()) {
        ifPresent(action, otherwise: { })
    }
    
    public func ifPresent(_ action: (Wrapped) -> (), otherwise: () -> ()) {
        switch self {
        case .none: otherwise()
        case .some(let value): action(value)
        }
    }
    
    public var isPresent: Bool {
        return map { _ in true } ?? false
    }
}

extension Optional {
    
    public func or(else value: Wrapped) -> Wrapped {
        return self == nil ? value : self!
    }
    
    public func or(else action: () -> Wrapped) -> Wrapped {
        return self == nil ? action() : self!
    }
    
    public func or(else value: Optional<Wrapped>) -> Optional<Wrapped> {
        return self == nil ? value : self
    }
    
    public func or(else action: () -> Optional<Wrapped>) -> Optional<Wrapped> {
        return self == nil ? action() : self
    }
}

