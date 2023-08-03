//
//  UsefulFunctions.swift
//  Chicken Butt
//
//  Created by lemin on 8/2/23.
//

import Foundation

class UsefulFunctions {
    static func addEmptyData(matchingSize: Int, to plist: [String: Any]) throws -> Data {
        var newPlist = plist
        // create the new data
        guard var newData = try? PropertyListSerialization.data(fromPropertyList: newPlist, format: .binary, options: 0) else { throw "Unable to get data" }
        // add data if too small
        // while loop to make data match because recursive function didn't work
        // very slow, will hopefully improve
        if newData.count == matchingSize {
            return newData
        }
        var newDataSize = newData.count
        var added = matchingSize - newDataSize
        if added < 0 {
            added = 1
        }
        var count = 0
        while newDataSize != matchingSize && count < 200 {
            count += 1
            if added < 0 {
                print("LESS THAN 0")
                break
            }
            newPlist.updateValue(String(repeating: "#", count: added), forKey: "MdC")
            do {
                newData = try PropertyListSerialization.data(fromPropertyList: newPlist, format: .binary, options: 0)
            } catch {
                newDataSize = -1
                print("ERROR SERIALIZING DATA")
                break
            }
            newDataSize = newData.count
            if count < 5 {
                // max out this method at 5 if it isn't working
                added += matchingSize - newDataSize
            } else {
                if newDataSize > matchingSize {
                    added -= 1
                } else if newDataSize < matchingSize {
                    added += 1
                }
            }
        }

        return newData
    }
}
