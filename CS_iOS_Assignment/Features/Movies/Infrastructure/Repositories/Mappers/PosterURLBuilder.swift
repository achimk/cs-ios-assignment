//
//  PosterURLBuilder.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 08/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import Foundation

struct PosterURLBuilder {
    
    enum ImageSize {
        case original
        case w500
        
        func toPath() -> String {
            switch self {
            case .original:
                return "https://image.tmdb.org/t/p/original/"
            case .w500:
                return "https://image.tmdb.org/t/p/w500/"
            }
        }
    }
    
    static func build(for fragment: String?, imageSize: ImageSize = .w500) -> URL? {
        guard let fragment = fragment else { return nil }
        let path = imageSize.toPath() + fragment
        return URL(string: path)
    }
}
