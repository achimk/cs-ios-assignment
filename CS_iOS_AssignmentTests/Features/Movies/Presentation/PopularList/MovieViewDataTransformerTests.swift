//
//  MovieViewDataTransformerTests.swift
//  CS_iOS_AssignmentTests
//
//  Created by Joachim Kret on 07/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import XCTest
@testable import CS_iOS_Assignment

final class MovieViewDataTransformerTests: XCTestCase {
    
    func test_transformMovie_shouldReturnCorrectViewData() {
        
        let components = prepareComponents()
        
        let viewData = components.transformer.transform(movie: components.movie)
        
        XCTAssertEqual(viewData.id.value, 1)
        XCTAssertEqual(viewData.title, "Movie title")
        XCTAssertEqual(viewData.posterURL, URL(string: "test.jpg"))
        XCTAssertEqual(viewData.releaseDate, "January 1, 1970")
        XCTAssertEqual(viewData.duration, "2h 15m")
        XCTAssertEqual(viewData.rating, 1.0)
    }
    
    private typealias TestComponents = (
        transformer: MovieViewDataTransformer,
        movie: Movie
    )
    
    private func prepareComponents(
        movieId: Int = 1,
        releaseDate: Date? = Date(timeIntervalSince1970: 0),
        duration: Duration? = Duration(135),
        rating: Rating? = Rating.adjust(1.0, in: 0.0...1.0)) -> TestComponents {
        
        let movieBuilder = StubMovieBuilder { (builder) in
            builder.idGenerator = { _ in MovieId.stub(movieId) }
            builder.titleGenerator = { _ in "Movie title"}
            builder.posterURLGenerator = { _ in URL(string: "test.jpg") }
            builder.durationGenerator = { _ in duration }
            builder.ratingGenerator = { _ in rating }
            builder.releaseRateGenerator = { _ in releaseDate }
        }
        
        let transformer = MovieViewDataTransformer()
        let movie = movieBuilder.build()
        
        
        return (transformer, movie)
    }

}
