//
//  MovieDBBasedMovieRepository.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 08/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import RxSwift

final class MovieDBBasedMovieRepository: MovieRepository {

    private let service: MovieDBService
    
    init(service: MovieDBService) {
        self.service = service
    }
    
    func findAll(for categoryQuery: MovieCategoryQuery) -> Single<[Movie]> {
        switch categoryQuery {
        case .currentlyPlaying:
            return findAllForCurrentlyPlaying()
        }
    }
    
    func findAll(for pageQuery: MoviePageQuery) -> Single<MoviePageResult> {
        return service
            .fetchPopular(for: pageQuery.value)
            .map(handleResponseResult(_:))
            .map(MoviePageResultMapper(page: pageQuery.value).map(_:))
    }
    
    func findDetails(for id: MovieId) -> Single<MovieDetails> {

        return service.fetchMovieDetails(for: id.value)
            .map(handleResponseResult(_:))
            .map { response -> MovieDetails in
                if let details = MovieDetailsMapper().map(response) {
                    return details
                } else {
                    throw MoviesError.unexpectedErrorOccured
                }
            }
    }
    
    private func findAllForCurrentlyPlaying() -> Single<[Movie]> {
        return service
            .fetchPlaying()
            .map(handleResponseResult(_:))
            .map(MovieMapper().map(_:))
    }
}

fileprivate func handleResponseResult<T>(_ responseResult: ResponseResult<T>) throws -> T {
    switch responseResult {
    case .valid(let value): return value
    case .invalid(let response, _):
        switch response.statusCode {
        case 404:
            throw MoviesError.notFound
        default:
            throw MoviesError.unexpectedErrorOccured
        }
    }
}
