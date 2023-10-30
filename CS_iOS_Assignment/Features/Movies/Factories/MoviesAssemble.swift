//
//  MoviesFeatureAssemble.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 07/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import Foundation

public struct MoviesAssemble {
    
    static func assemble(with container: Container) {
        container.register(MovieRepository.self, resolver: { container in
            return MovieDBBasedMovieRepository(service: container.resolve(MovieDBService.self))
        })
        container.register(MoviesAPI.self, resolver: { container in
            return MoviesApplicationService(movieRepository: container.resolve(MovieRepository.self))
        })
    }
}
