//
//  MoviePageQuery.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 06/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import Foundation

public struct MoviePageQuery: Equatable {
    let value: Int
    
    public static let initial: MoviePageQuery = {
        return MoviePageQuery(1)
    }()
    
    private init(_ value: Int) {
        assert(value > 0)
        self.value = value
    }
    
    public init?(page: Int) {
        guard page > 0 else { return nil }
        self.value = page
    }
    
    public func nextPage() -> MoviePageQuery {
        return MoviePageQuery(value.advanced(by: 1))
    }
}


