//
//  MoviesAPI.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 06/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import RxSwift

public protocol MoviesAPI {
    
    // Commands:
    // Any commands should be placed here

    // Queries:
    func currentlyPlaying() -> Single<[Movie]>
    func mostPopular(for page: MoviePageQuery) -> Single<MoviePageResult>
    func details(for id: MovieId) -> Single<MovieDetails>
}
