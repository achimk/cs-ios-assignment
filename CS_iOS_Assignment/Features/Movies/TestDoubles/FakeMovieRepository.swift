//
//  FakeMovieRepository.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 07/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import RxSwift

final class FakeMovieRepository: MovieRepository {
    
    private static let maxPage: Int = 3
    private static let numberOfMoviesPerPage: Int = 20
    private static let delayTimeInterval: RxTimeInterval = .seconds(1)
    private static let posterPath = "https://image.tmdb.org/t/p/w500/8UlWHLMpgZm9bx6QYh0NFoq67TZ.jpg"
    
    private let movieBuilder: StubMovieBuilder = {
        return StubMovieBuilder { builder in
            builder.idGenerator = { _ in MovieId.stub(464052) }
            builder.titleGenerator = { _ in "Wonder Woman 1984"}
            builder.posterURLGenerator = { _ in URL(string: FakeMovieRepository.posterPath) }
            builder.durationGenerator = { _ in Duration(151) }
            builder.releaseRateGenerator = { _ in Date(timeIntervalSince1970: 0) }
            builder.ratingGenerator = { _ in Rating.adjust(0.7, in: 0.0...1.0) }
        }
    }()
    
    private let movieDetailsBuilder: StubMovieDetailsBuilder = {
        return StubMovieDetailsBuilder { builder in
            builder.idGenerator = { _ in MovieId.stub(464052) }
            builder.titleGenerator = { _ in "Wonder Woman 1984"}
            builder.overviewGenerator = { _ in "Wonder Woman comes into conflict with the Soviet Union during the Cold War in the 1980s and finds a formidable foe by the name of the Cheetah." }
            builder.posterURLGenerator = { _ in URL(string: FakeMovieRepository.posterPath) }
            builder.durationGenerator = { _ in Duration(151) }
            builder.releaseRateGenerator = { _ in Date(timeIntervalSince1970: 0) }
            builder.genresGenerator = { _ in ["Fantasy", "Action", "Adventure"] }
        }
    }()
    
    func findAll(for categoryQuery: MovieCategoryQuery) -> Single<[Movie]> {
        let movies = movieBuilder.build(count: FakeMovieRepository.numberOfMoviesPerPage)
        return makeDelayed(Single.just(movies))
    }
    
    func findAll(for pageQuery: MoviePageQuery) -> Single<MoviePageResult> {
        if pageQuery.value > FakeMovieRepository.maxPage {
            let results = MoviePageResult(movies: [], page: pageQuery.value, isLastPage: true)
            return makeDelayed(Single.just(results))
        }
        
        let movies = movieBuilder.build(count: FakeMovieRepository.numberOfMoviesPerPage)
        let results = MoviePageResult(movies: movies, page: pageQuery.value, isLastPage: pageQuery.value == FakeMovieRepository.maxPage)
        return makeDelayed(Single.just(results))
    }
    
    func findDetails(for id: MovieId) -> Single<MovieDetails> {
        let details = movieDetailsBuilder.build()
        return makeDelayed(Single.just(details))
    }
    
    private func makeDelayed<T>(_ single: Single<T>) -> Single<T> {
        return single.delay(FakeMovieRepository.delayTimeInterval, scheduler: MainScheduler.asyncInstance)
    }

}
