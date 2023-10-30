//
//  MoviePageResultMapper.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 08/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import Foundation

struct MoviePageResultMapper {
    
    let page: Int
    
    func map(_ response: PopularResponse) -> MoviePageResult {
        let movies = (response.results ?? []).compactMap(toMovie(_:))
        let isLastPage = response.totalPages == page
        return MoviePageResult(
            movies: movies,
            page: page,
            isLastPage: isLastPage)
    }
    
    private func toMovie(_ response: PopularResponse.PopularResult) -> Movie? {
        
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
            duration: nil, // Unable to find: https://developers.themoviedb.org/3/movies/get-popular-movies
            releaseDate: releaseDate)
    }
}
