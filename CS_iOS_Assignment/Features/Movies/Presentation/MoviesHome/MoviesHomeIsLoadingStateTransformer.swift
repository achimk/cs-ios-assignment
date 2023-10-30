//
//  MoviesHomeIsLoadingStateTransformer.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 07/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import Foundation

struct MoviesHomeIsLoadingStateTransformer {
    
    func transform(playingListState: PlayingListState, popularListState: PopularListState) -> Bool {
        return playingListState.activity.isLoading || popularListState.activity.isLoading
    }
}
