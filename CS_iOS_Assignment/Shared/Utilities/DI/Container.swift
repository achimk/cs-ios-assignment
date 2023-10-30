//
//  Container.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 06/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import Foundation

final class Container {
    
    typealias Resolver = (Container) -> Any
    
    private var resolversByTypes: [String: Resolver] = [:]
    
    static let shared = Container()
    
    init() { }
    
    func register<T>(_ type: T.Type, resolver: @escaping (Container) -> T) {
        let key = String(describing: T.self)
        resolversByTypes[key] = resolver
    }
    
    func resolve<T>(_ type: T.Type, otherwise: (() -> T)? = nil) -> T {
        let key = String(describing: T.self)
        
        guard let resolver = resolversByTypes[key] else {
            return otherwise?() ?? identity("Unregistered resolver for \(key) type!")
        }
        
        return resolver(self) as! T
    }
}
