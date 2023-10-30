//
//  MoviePageResult.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 06/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import Foundation

public struct MoviePageResult {
    public let movies: [Movie]
    public let page: Int
    public let isLastPage: Bool
    
    public init(movies: [Movie], page: Int, isLastPage: Bool) {
        self.movies = movies
        self.page = page
        self.isLastPage = isLastPage
    }
    
    public func nextPageQuery() -> MoviePageQuery? {
        return isLastPage ? nil : MoviePageQuery(page: page)?.nextPage()
    }
}
