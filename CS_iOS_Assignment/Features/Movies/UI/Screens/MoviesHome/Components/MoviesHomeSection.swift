//
//  MoviesHomeSection.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 07/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import Foundation

enum MoviesHomeSection: Int, CaseIterable {
    case playing
    case popular
    
    static let playingHeaderId = "playingHeaderId"
    static let popularHeaderId = "popularHeaderId"
    
    var headerId: String {
        switch self {
        case .playing: return MoviesHomeSection.playingHeaderId
        case .popular: return MoviesHomeSection.popularHeaderId
        }
        
    }
}
