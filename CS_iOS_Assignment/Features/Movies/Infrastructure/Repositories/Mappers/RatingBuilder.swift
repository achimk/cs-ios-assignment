//
//  RatingBuilder.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 08/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import Foundation

struct RatingBuilder {
    
    static func build(for value: Double?) -> Rating? {
        guard let value = value else { return nil }
        return Rating.adjust(value, in: 0.0...10.0)
    }
}
