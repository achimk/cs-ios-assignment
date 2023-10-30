//
//  MovieDBConfiguration.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 08/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import Foundation

public struct MovieDBConfiguration {
    public let apiKey: String
    public let language: String
    public let host: String
    
    public static let `default` = MovieDBConfiguration(
        apiKey: "55957fcf3ba81b137f8fc01ac5a31fb5",
        host: "https://api.themoviedb.org",
        language: "en-US")
    
    public init(apiKey: String, host: String, language: String) {
        self.apiKey = apiKey
        self.host = host
        self.language = language
    }
}
