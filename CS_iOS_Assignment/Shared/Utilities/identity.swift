//
//  identity.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 06/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import Foundation

public func identity<T>(_ message: String? = nil) -> T {
    fatalError(message ?? "Parameter \(T.self) not exists!")
}
