//
//  ImageCache.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 07/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import Foundation
import Kingfisher

struct ImageCacheConfiguration {
    
    static func setup() {
        let cache = Kingfisher.ImageCache.default
        // Memory image expires after 10 minutes.
        cache.memoryStorage.config.expiration = .seconds(600)
        // Limit memory cache size to 300 MB.
        cache.memoryStorage.config.totalCostLimit = 300 * 1024 * 1024
        // Limit disk cache size to 1 GB.
        cache.diskStorage.config.sizeLimit = 1000 * 1024 * 1024
        // Disk image never expires.
        cache.diskStorage.config.expiration = .never
    }
}
