//
//  MovieDetailsModuleFactory.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 07/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import UIKit

struct MovieDetailsModuleFactory {
    
    static func make(movieId: MovieId, container: Container = .shared, onClosePressed: (() -> ())? = nil) -> MovieDetailsViewController {
        
        let api = container.resolve(MoviesAPI.self)
        let errorLocalizer: (Error) -> String = MoviesErrorLocalizer().localize(error:)
        
        let activityIndicator = ActivityStateIndicator(sideEffect: {
            return api.details(for: movieId)
        })
        let stateObservable = MovieDetailsStateObservable(activityIndicator: activityIndicator, errorLocalizer: errorLocalizer)
        
        let viewModel = MovieDetailsViewModel(stateObservable: stateObservable)
        
        return MovieDetailsViewController(viewModel: viewModel, onClosePressed: onClosePressed)
    }
}
