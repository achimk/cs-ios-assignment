//
//  MovieId.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 06/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import Foundation

public struct MovieId: Equatable, Hashable {
    public let value: Int
    public init?(_ value: Int?) {
        guard let value = value else { return nil }
        self.value = value
    }
}
