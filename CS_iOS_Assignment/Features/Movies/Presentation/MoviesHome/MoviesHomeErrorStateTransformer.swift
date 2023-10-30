//
//  MoviesHomeErrorStateTransformer.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 07/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import Foundation

struct MoviesHomeErrorStateTransformer {
    
    var errorViewDataFactory: (String) -> MoviesHomeErrorViewData = { message in
        return MoviesHomeErrorViewData(title: nil, details: message)
    }
    
    func transform(playingListState: PlayingListState, popularListState: PopularListState) -> MoviesHomeErrorViewData? {
        
        guard playingListState.activity.isFinish && popularListState.activity.isFinish else {
            return nil
        }
        
        if let error = playingListState.activity.error {
            return errorViewDataFactory(error)
        } else if let error = popularListState.activity.error {
            return errorViewDataFactory(error)
        } else {
            return nil
        }
    }
}
