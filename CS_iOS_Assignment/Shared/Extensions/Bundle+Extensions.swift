//
//  Bundle+Extensions.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 07/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import Foundation

extension Bundle {
    public static func currentBundle() -> Bundle {
        return Bundle.init(for: BundleLoader.self)
    }
}

fileprivate final class BundleLoader { }
