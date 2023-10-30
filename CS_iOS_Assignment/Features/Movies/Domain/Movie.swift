//
//  Movie.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 06/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import Foundation

public struct Movie {
    public let id: MovieId
    public let title: String?
    public let posterURL: URL?
    public let rating: Rating?
    public let duration: Duration?
    public let releaseDate: Date?
}
