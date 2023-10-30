//
//  MovieId+Stub.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 06/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import Foundation

extension MovieId {
    static func stub(_ value: Int = 1) -> MovieId {
        return MovieId(value)!
    }
}
