//
//  PopularListState.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 07/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import Foundation

struct PopularListState {
    let activity: ActivityState<Void, String>
    let action: PopularListAction
    let items: [MovieViewData]
    let isNextPageAvailable: Bool
    
    static let initial = PopularListState(
        activity: .initial,
        action: .loadInitialPage,
        items: [],
        isNextPageAvailable: false)
}
