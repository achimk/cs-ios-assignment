//
//  MovieDetailsMapper.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 08/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import Foundation

struct MovieDetailsMapper {
    
    func map(_ response: MovieDetailsResponse) -> MovieDetails? {
        
        guard let id = MovieId(response.id) else {
            return nil
        }
        
        let posterURL = PosterURLBuilder.build(for: response.posterPath)
        let duration = Duration(response.runtime)
        let releaseDate = ReleaseDateBuilder.build(for: response.releaseDate)
        let genres = (response.genres ?? []).compactMap { $0.name }
        
        return MovieDetails(
            id: id,
            title: response.title,
            overview: response.overview,
            posterURL: posterURL,
            duration: duration,
            releaseDate: releaseDate,
            genres: genres)
    }
}
