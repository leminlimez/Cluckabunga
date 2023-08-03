//
//  MachineName.swift
//  Chicken Butt
//
//  Created by lemin on 8/2/23.
//

import UIKit

extension UIDevice {
    var machineName: String {
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
            return simulatorModelIdentifier
        }

        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        let deviceModel = String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)?.trimmingCharacters(in: .controlCharacters)

        return deviceModel ?? ""
    }
}
