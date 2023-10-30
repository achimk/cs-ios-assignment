//
//  MovieViewDataTransformer.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 07/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import Foundation

struct MovieViewDataTransformer {
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        return dateFormatter
    }()
    
    static let durationFormatter: (Duration) -> String = { duration in
        return "\(duration.components.hours)h \(duration.components.minutes)m"
    }
    
    func transform(movie: Movie) -> MovieViewData {
        
        let dateFormatter = MovieViewDataTransformer.dateFormatter
        let durationFormatter = MovieViewDataTransformer.durationFormatter
        
        return MovieViewData(
            id: movie.id,
            title: movie.title,
            posterURL: movie.posterURL,
            releaseDate: movie.releaseDate.flatMap(dateFormatter.string(from:)),
            duration: movie.duration.map(durationFormatter),
            rating: movie.rating?.value)
    }
}
