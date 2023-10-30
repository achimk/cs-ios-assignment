//
//  ReleaseDateBuilder.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 08/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import Foundation

struct ReleaseDateBuilder {
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
    
    static func build(for dateString: String?) -> Date? {
        guard let dateString = dateString else { return nil }
        return dateFormatter.date(from: dateString)
    }
}
