//
//  StubMovieBuilder.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 06/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import Foundation

struct StubMovieBuilder {
    
    var idGenerator: (Int) -> MovieId = { index in MovieId.stub(index) }
    var titleGenerator: (Int) -> String? = { index in "title \(index)"}
    var posterURLGenerator: (Int) -> URL? = { _ in nil }
    var ratingGenerator: (Int) -> Rating? = { _ in nil }
    var durationGenerator: (Int) -> Duration? = { _ in nil }
    var releaseRateGenerator: (Int) -> Date? = { _ in Date() }
    
    init() { }
    
    init(configure: (inout StubMovieBuilder) -> ()) {
        var builder = StubMovieBuilder()
        configure(&builder)
        self = builder
    }
    
    func build(index: Int = 0) -> Movie {
        return generate(for: index)
    }
    
    func build(count: Int) -> [Movie] {
        return (0..<count).map(generate(for:))
    }
    
    private func generate(for index: Int) -> Movie {
        return StubMovie(
            id: idGenerator(index),
            title: titleGenerator(index),
            posterURL: posterURLGenerator(index),
            rating: ratingGenerator(index),
            duration: durationGenerator(index),
            releaseDate: releaseRateGenerator(index))
    }
}
