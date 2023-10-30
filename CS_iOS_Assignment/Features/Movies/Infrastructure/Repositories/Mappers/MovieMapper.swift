//
//  MovieMapper.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 08/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import Foundation

struct MovieMapper {
    
    func map(_ response: PlayingResponse) -> [Movie] {
        let results = response.results ?? []
        return results.compactMap(toMovie(_:))
    }
    
    private func toMovie(_ response: PlayingResponse.Result) -> Movie? {
        
        guard let id = MovieId(response.id) else {
            return nil
        }
        
        let posterURL = PosterURLBuilder.build(for: response.posterPath)
        let rating = RatingBuilder.build(for: response.voteAverage)
        let releaseDate = ReleaseDateBuilder.build(for: response.releaseDate)
        
        return Movie(
            id: id,
            title: response.title,
            posterURL: posterURL,
            rating: rating,
            duration: nil, // Unable to find: https://developers.themoviedb.org/3/movies/get-now-playing
            releaseDate: releaseDate)
    }
}
