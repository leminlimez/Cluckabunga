//
//  URLCache+imageCache.swift
//  Chicken Butt
//
//  Created by lemin on 8/2/23.
//

import CachedAsyncImage

extension URLCache {
    
    static let imageCache = URLCache(memoryCapacity: 512*1000*1000, diskCapacity: 10*1000*1000*1000)
}
