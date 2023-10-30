//
//  MoviesApplicationService.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 06/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import RxSwift

final class MoviesApplicationService: MoviesAPI {
    
    private let movieRepository: MovieRepository
    
    init(movieRepository: MovieRepository) {
        self.movieRepository = movieRepository
    }
    
    func currentlyPlaying() -> Single<[Movie]> {
        return movieRepository.findAll(for: .currentlyPlaying)
    }
    
    func mostPopular(for page: MoviePageQuery) -> Single<MoviePageResult> {
        return movieRepository.findAll(for: page)
    }
    
    func details(for id: MovieId) -> Single<MovieDetails> {
        return movieRepository.findDetails(for: id)
    }
    
    
}
