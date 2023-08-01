//
//  OverrideImplementation.swift
//  Chicken Butt
//
//  Created by lemin on 8/1/23.
//

import Foundation

// credit to hrtowii
func overwriteWithFileImpl(
    replacementURL: URL,
    pathToTargetFile: String
) {
//    var replacementData: Data = try! Data(contentsOf: replacementURL)
    
    let cPathtoTargetFile = pathToTargetFile.withCString { ptr in
            return strdup(ptr)
        }
    let mutablecPathtoTargetFile = UnsafeMutablePointer<Int8>(mutating: cPathtoTargetFile)
    
    let cFileURL = replacementURL.path.withCString { ptr in
            return strdup(ptr)
        }
    let mutablecFileURL = UnsafeMutablePointer<Int8>(mutating: cFileURL)
    
    funVnodeOverwrite2(cPathtoTargetFile, mutablecFileURL) // the magic is here
}
