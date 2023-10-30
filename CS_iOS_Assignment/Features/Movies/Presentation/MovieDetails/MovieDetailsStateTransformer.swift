//
//  MovieDetailsStateTransformer.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 06/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import Foundation

struct MovieDetailsStateTransformer {
    
    static let dateFormatter: DateFormatter = {
        // FIXME: Make shared date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        return dateFormatter
    }()
    
    static let durationFormatter: (Duration) -> String = { duration in
        return "\(duration.components.hours)h \(duration.components.minutes)m"
    }
    
    let errorLocalizer: (Error) -> String
    
    func transform(activity: ActivityState<MovieDetails, Error>, oldState: MovieDetailsState) -> MovieDetailsState {
        let detailsActivity = activity.map { _ in () }.mapError(errorLocalizer)
        let contentLoaded = activity.isSuccess ? true : oldState.contentLoaded
        let posterURL = activity.isSuccess ? activity.value?.posterURL : oldState.posterURL
        let title = activity.isSuccess ? activity.value?.title : oldState.title
        let subtitle = activity.isSuccess ? makeSubtitle(for: activity.value) : oldState.subtitle
        let overview = activity.isSuccess ? activity.value?.overview : oldState.overview
        let genres = activity.isSuccess ? (activity.value?.genres ?? []) : oldState.genres
        let formattedGenres = genres.map { $0.uppercased() }
        
        return MovieDetailsState(
            activity: detailsActivity,
            contentLoaded: contentLoaded,
            posterURL: posterURL,
            title: title,
            subtitle: subtitle,
            overview: overview,
            genres: formattedGenres)
    }
    
    private func makeSubtitle(for details: MovieDetails?) -> String? {
        guard let details = details else { return nil }
        let dateFormatter = MovieDetailsStateTransformer.dateFormatter
        let durationFormatter = MovieDetailsStateTransformer.durationFormatter
        
        let components = [
            details.releaseDate.flatMap(dateFormatter.string(from:)),
            details.duration.map(durationFormatter)
        ].compactMap { $0 }
        
        return components.joined(separator: "  -  ")
    }
}
