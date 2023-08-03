//
//  OtherModsManager.swift
//  Chicken Butt
//
//  Created by lemin on 8/3/23.
//

import Foundation

class OtherModsManager {
    public static func changeDictValue(_ dict: [String: Any], _ key: String, _ value: Int) -> [String: Any] {
        var newDict = dict
        for (k, v) in dict {
            if k == key {
                newDict[k] = value
            } else if let subDict = v as? [String: Any] {
                newDict[k] = changeDictValue(subDict, key, value)
            }
        }
        return newDict
    }
    
    public static func applyDynamicIsland() throws {
        if !FileManager.default.fileExists(atPath: URL.documents.appendingPathComponent("com.apple.MobileGestalt-BACKUP.plist").path) {
            let plistData = try Data(contentsOf: URL(filePath: "/var/containers/Shared/SystemGroup/systemgroup.com.apple.mobilegestaltcache/Library/Caches/com.apple.MobileGestalt.plist"))
            try plistData.write(to: URL.documents.appendingPathComponent("com.apple.MobileGestalt-BACKUP.plist"))
        }
        
        // create the temp file
        let plistData = try Data(contentsOf: URL.documents.appendingPathComponent("com.apple.MobileGestalt-BACKUP.plist"))
        let plist = try PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as! [String: Any]
        
        let newPlist = changeDictValue(plist, "ArtworkDeviceSubType", 2556)
        let newData = try PropertyListSerialization.data(fromPropertyList: newPlist, format: .binary, options: 0)
        
        if newData.count == plistData.count {
            print("Same Size!")
            try overwriteFile(at: "/var/containers/Shared/SystemGroup/systemgroup.com.apple.mobilegestaltcache/Library/Caches/com.apple.MobileGestalt.plist", with: newData)
        } else {
            print("OLD DATA: \(plistData.count)")
            print("NEW DATA: \(newData.count)")
        }
    }
}
