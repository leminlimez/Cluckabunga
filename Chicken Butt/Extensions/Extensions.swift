//
//  Extensions.swift
//  Chicken Butt
//
//  Created by lemin on 8/2/23.
//

import Foundation

extension URL {
    static var documents: URL {
        return FileManager
            .default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}


extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}
