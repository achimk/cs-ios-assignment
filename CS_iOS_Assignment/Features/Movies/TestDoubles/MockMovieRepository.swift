//
//  MockMovieRepository.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 06/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import RxSwift

final class MockMovieRepository: MovieRepository {
    
    struct DummyError: Error { }
    
    var findAllCategoryHandler: (MovieCategoryQuery) -> Single<[Movie]> = { _ in
        return Single.error(DummyError())
    }

    var findAllPageHandler: (MoviePageQuery) -> Single<MoviePageResult> = { _ in
        return Single.error(DummyError())
    }
    
    var findDetailsHandler: (MovieId) -> Single<MovieDetails> = { _ in
        return Single.error(DummyError())
    }
    
    func findAll(for categoryQuery: MovieCategoryQuery) -> Single<[Movie]> {
        return findAllCategoryHandler(categoryQuery)
    }
    
    func findAll(for pageQuery: MoviePageQuery) -> Single<MoviePageResult> {
        return findAllPageHandler(pageQuery)
    }
    
    func findDetails(for id: MovieId) -> Single<MovieDetails> {
        return findDetailsHandler(id)
    }
    
    
}
