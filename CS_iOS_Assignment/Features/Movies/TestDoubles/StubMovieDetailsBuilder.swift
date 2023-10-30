//
//  StubMovieDetailsBuilder.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 06/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import Foundation

struct StubMovieDetailsBuilder {
    
    var idGenerator: (Int) -> MovieId = { index in MovieId.stub(index) }
    var titleGenerator: (Int) -> String? = { index in "title \(index)" }
    var overviewGenerator: (Int) -> String? = { index in "overview \(index)" }
    var posterURLGenerator: (Int) -> URL? = { _ in nil }
    var durationGenerator: (Int) -> Duration? = { _ in nil }
    var releaseRateGenerator: (Int) -> Date? = { _ in Date() }
    var genresGenerator: (Int) -> [String] = { _ in [] }
    
    init() { }
    
    init(configure: (inout StubMovieDetailsBuilder) -> ()) {
        var builder = StubMovieDetailsBuilder()
        configure(&builder)
        self = builder
    }
    
    func build(index: Int = 0) -> MovieDetails {
        return generate(for: index)
    }
    
    func build(count: Int) -> [MovieDetails] {
        return (0..<count).map(generate(for:))
    }
    
    private func generate(for index: Int) -> MovieDetails {
        return StubMovieDetails(
            id: idGenerator(index),
            title: titleGenerator(index),
            overview: overviewGenerator(index),
            posterURL: posterURLGenerator(index),
            duration: durationGenerator(index),
            releaseDate: releaseRateGenerator(index),
            genres: genresGenerator(index))
    }

}
