//
//  PlayingListStateTransformer.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 06/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import Foundation

struct PlayingListStateTransformer {
    
    let errorLocalizer: (Error) -> String
    
    func transform(activity: ActivityState<[Movie], Error>, oldState: PlayingListState) -> PlayingListState {
        let postersActivity = activity.map { _ in () }.mapError(errorLocalizer)
        let postersState = activity.map { movies -> [PosterViewData] in
            return movies.compactMap { movie -> PosterViewData? in
                guard let url = movie.posterURL else { return nil }
                return PosterViewData(url: url)
            }
        }
        let posters = postersState.value ?? oldState.posters
        
        return PlayingListState(activity: postersActivity, posters: posters)
    }
}
