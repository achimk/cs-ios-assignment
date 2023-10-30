//
//  FeaturesAssemble.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 07/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import Foundation

struct FeaturesAssemble {

    @discardableResult
    static func assemble() -> Container {
        let container = Container.shared
        
        // Infrastructure
        container.register(MovieDBService.self, resolver: { _ in
            return MovieDBService(configuration: .default)
        })
        
        // Features
        MoviesAssemble.assemble(with: container)
        
        return container
    }
}
