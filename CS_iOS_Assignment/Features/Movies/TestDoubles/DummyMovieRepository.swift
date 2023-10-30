//
//  StubMovieRepository.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 06/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import RxSwift

final class DummyMovieRepository: MovieRepository {
    
    struct DummyError: Error {}
    
    func findAll(for categoryQuery: MovieCategoryQuery) -> Single<[Movie]> {
        return Single.error(DummyError())
    }
    
    func findAll(for pageQuery: MoviePageQuery) -> Single<MoviePageResult> {
        return Single.error(DummyError())
    }
    
    func findDetails(for id: MovieId) -> Single<MovieDetails> {
        return Single.error(DummyError())
    }
    
    
}
