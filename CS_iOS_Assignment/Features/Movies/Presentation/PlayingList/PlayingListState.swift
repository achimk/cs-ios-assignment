//
//  PlaingListState.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 06/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import Foundation

struct PlayingListState {
    let activity: ActivityState<Void, String>
    let posters: [PosterViewData]
    
    static let initial: PlayingListState = PlayingListState(activity: .initial, posters: [])
}
