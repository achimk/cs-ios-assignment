//
//  Rating.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 06/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import Foundation

public struct Rating: Equatable {
    public static let range: ClosedRange = (0.0...1.0)
    public let value: Double
    
    fileprivate init?(_ value: Double?) {
        guard let value = value else { return nil }
        self.value = min(Rating.range.upperBound, max(Rating.range.lowerBound, value))
    }
}

extension Rating {
    public static func adjust(_ value: Double?, in range: ClosedRange<Double>) -> Rating? {
        guard var value = value else { return nil }
        value = min(range.upperBound, max(range.lowerBound, value))
        let rounded = ((value - range.lowerBound) / (range.upperBound - range.lowerBound)).round(to: 4)
        return Rating(rounded)
    }
}

extension Rating: Comparable {
    public static func < (lhs: Rating, rhs: Rating) -> Bool {
        return lhs.value < rhs.value
    }
}

extension Double {
    fileprivate func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
