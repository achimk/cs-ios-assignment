//
//  MovieDBEndpoint.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 08/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import Foundation

enum MovieDBEndpoint {
    
    case playing
    case popular
    case movieDetails(id: Int)
    
    func toPath() -> String {
        switch self {
        case .playing: return "/3/movie/now_playing"
        case .popular: return "/3/movie/popular"
        case .movieDetails(let id): return "/3/movie/\(id)"
        }
    }
    
    func toHttpMethod() -> String {
        switch self {
        case .playing,
             .popular,
             .movieDetails:
            return "GET"
        }
    }
}
