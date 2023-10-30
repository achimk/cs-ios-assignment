//
//  MoviesHomeFactory.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 07/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import UIKit

struct MoviesHomeModuleFactory {
    
    static func make(with container: Container = .shared) -> MoviesHomeViewController {
        
        let api = container.resolve(MoviesAPI.self)
        let errorLocalizer: (Error) -> String = MoviesErrorLocalizer().localize(error:)
        
        let playingActivityIndicator = ActivityStateIndicator(sideEffect: api.currentlyPlaying)
        let playingStateObservable = PlayingListStateObservable(activityIndicator: playingActivityIndicator, errorLocalizer: errorLocalizer)
        
        let popularActionIndicator = PopularListActionStateIndicatorFactory.make(pageResultProvider: api.mostPopular(for:))
        let popularStateObservable = PopularListStateObservable(actionIndicator: popularActionIndicator, errorLocalizer: errorLocalizer)
        
        let viewModel = MoviesHomeViewModel(
            playingListStateObservable: playingStateObservable,
            popularListStateObservable: popularStateObservable)
        
        return MoviesHomeViewController(viewModel: viewModel)
    }
}
