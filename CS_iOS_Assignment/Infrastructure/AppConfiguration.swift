//
//  AppConfiguration.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 07/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import Foundation

final class AppConfiguration {
    
    private static var isReady = false
    
    static func setup() {
        if isReady { return }
        isReady = false
        
        ImageCacheConfiguration.setup()
        FeaturesAssemble.assemble()
    }
}
