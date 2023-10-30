//
//  MovieDetails.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 06/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import Foundation

public struct MovieDetails {
    public let id: MovieId
    public let title: String?
    public let overview: String?
    public let posterURL: URL?
    public let duration: Duration?
    public let releaseDate: Date?
    public let genres: [String]
}
