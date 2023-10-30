//
//  Duration.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 06/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import Foundation

public struct Duration: Equatable {
    
    public struct Components: Equatable {
        public let hours: Int
        public let minutes: Int
        
        fileprivate init(_ minutes: Int) {
            self.hours = Int(minutes / 60)
            self.minutes = minutes % 60
        }
    }
    
    public let minutes: Int
    public let components: Components
    
    public init?(_ minutes: Int?) {
        guard let minutes = minutes, minutes > 0 else { return nil }
        self.minutes = minutes
        self.components = Components(minutes)
    }
}
