//
//  MovieDetailsState.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 06/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import Foundation

struct MovieDetailsState {
    let activity: ActivityState<Void, String>
    let contentLoaded: Bool
    let posterURL: URL?
    let title: String?
    let subtitle: String?
    let overview: String?
    let genres: [String]
    
    static let initial = MovieDetailsState(
        activity: .initial,
        contentLoaded: false,
        posterURL: nil,
        title: nil,
        subtitle: nil,
        overview: nil,
        genres: [])
}
