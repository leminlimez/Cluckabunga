//
//  HomeView.swift
//  Chicken Butt
//
//  Created by lemin on 8/2/23.
//

import SwiftUI

struct HomeView: View {
    // MARK: Variables
    @State private var versionBuildString: String?
    
    // Preferences
    @AppStorage("RespringType") var respringType: String = "Frontboard"
    @AppStorage("LockPrefs") var lockPrefs: String = LockManager.getDefaultLockType()
    @AppStorage("passcodeFaceSize") var passcodeFaceSize: Int = KeySize.big.rawValue
    private var deviceType = UIDevice().machineName
    
    @AppStorage("HideDock") var hideDock: Bool = false
    @AppStorage("HideHomeBar") var hideHomeBar: Bool = false
    @AppStorage("HideFolderBG") var hideFolderBG: Bool = false
    
    @AppStorage("ChangingDeviceSubtype") var changingDeviceSubtype: Bool = false
    @AppStorage("NewDeviceSubtype") var newDeviceSubtype: Int = 0
    
    @AppStorage("ChangingSupervision") var changingSupervision: Bool = false
    @AppStorage("IsSupervised") var isSupervised: Bool = false
    
    @AppStorage("ChangingResolution") var changingResolution: Bool = false
    @AppStorage("NewResolutionX") var newResolutionX: Int = 0
    @AppStorage("NewResolutionY") var newResolutionY: Int = 0
    
    // Exploit Stuffs
    @State private var kfd: UInt64 = 0
        
    private var puaf_pages_options = [16, 32, 64, 128, 256, 512, 1024, 2048]
    @AppStorage("PUAF_Pages_Index") private var puaf_pages_index = 7
    @AppStorage("PUAF_Pages") private var puaf_pages = 0
    
    private var puaf_method_options = ["physpuppet", "smith"]
    @AppStorage("PUAF_Method") private var puaf_method = 1
    
    private var kread_method_options = ["kqueue_workloop_ctl", "sem_open"]
    @AppStorage("KRead_Method") private var kread_method = 1
    
    private var kwrite_method_options = ["dup", "sem_open"]
    @AppStorage("KWrite_Method") private var kwrite_method = 1
    
    var body: some View {
        NavigationView {
            List {
                // MARK: App Version
                Section {
                    
                } header: {
                    Label("Version \(Bundle.main.releaseVersionNumber ?? "UNKNOWN") (\(versionBuildString ?? "Release"))", systemImage: "info")
                }
                
                // MARK: Tweak Options
                Section {
                    VStack {
                        // apply all tweaks button
                        HStack {
                            Button("Apply tweaks") {
                                applyTweaks()
                            }
                            .buttonStyle(TintedButton(color: .blue, fullwidth: true))
                            Button {
                                UIApplication.shared.alert(title: NSLocalizedString("Info", comment: "fix tweaks info header"), body: NSLocalizedString("Applies all tweaks which were applied before.", comment: "fix tweaks info"))
                            } label: {
                                Image(systemName: "info")
                            }
                            .buttonStyle(TintedButton(material: .systemMaterial, fullwidth: false))
                        }
                        
                        HStack {
                            Button("Respring") {
                                UsefulFunctions.respring()
                            }
                            .buttonStyle(TintedButton(color: .red, fullwidth: true))
                            Button {
                                UIApplication.shared.alert(title: NSLocalizedString("Info", comment: "respring info header"), body: NSLocalizedString("Respring is an action that allows restarting your Home Screen without rebooting your device.", comment: "respring info"))
                            } label: {
                                Image(systemName: "info")
                            }
                            .buttonStyle(TintedButton(material: .systemMaterial, fullwidth: false))
                        }
                    }
                }
                
                Section {
                    // app preferences
                    // MARK: Respring Type
                    HStack {
                        Text("Respring Type")
                            .minimumScaleFactor(0.5)
                        
                        Spacer()
                        
                        Button(respringType ?? "Frontboard", action: {
                            // create and configure alert controller
                            let alert = UIAlertController(title: NSLocalizedString("Choose a respring type", comment: "Title for respring type"), message: NSLocalizedString("Try out each respring type and determine which works best for your needs.", comment: "Description for respring type"), preferredStyle: .actionSheet)
                            
                            // create the actions
                            let frontboardAction = UIAlertAction(title: "Frontboard", style: .default) { (action) in
                                // apply the type
                                respringType = "Frontboard"
                            }
                            let backboardAction = UIAlertAction(title: "Backboard", style: .default) { (action) in
                                // apply the type
                                respringType = "Backboard"
                            }
                            
                            if respringType == "Backboard" {
                                backboardAction.setValue(true, forKey: "checked")
                            } else {
                                frontboardAction.setValue(true, forKey: "checked")
                            }
                            alert.addAction(frontboardAction)
                            alert.addAction(backboardAction)
                            
                            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel) { (action) in
                                // cancels the action
                            }
                            
                            // add the actions
                            alert.addAction(cancelAction)
                            
                            let view: UIView = UIApplication.shared.windows.first!.rootViewController!.view
                            // present popover for iPads
                            alert.popoverPresentationController?.sourceView = view // prevents crashing on iPads
                            alert.popoverPresentationController?.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.maxY, width: 0, height: 0) // show up at center bottom on iPads
                            
                            // present the alert
                            UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
                        })
                        .foregroundColor(.blue)
                        .padding(.leading, 10)
                    }
                    
                    // MARK: Passcode Face Size
                    HStack {
                        Text("Passcode Face Size")
                            .minimumScaleFactor(0.5)
                        
                        Spacer()
                        
                        Button("\(passcodeFaceSize == KeySize.big.rawValue ? "Big" : "Small") (\(passcodeFaceSize))", action: {
                            // create and configure alert controller
                            let alert = UIAlertController(title: NSLocalizedString("Choose a face size", comment: "Title for face size"), message: "", preferredStyle: .actionSheet)
                            
                            // create the actions
                            let smallAction = UIAlertAction(title: "Small (\(KeySize.small.rawValue))", style: .default) { (action) in
                                // apply the type
                                passcodeFaceSize = KeySize.small.rawValue
                            }
                            let bigAction = UIAlertAction(title: "Big (\(KeySize.big.rawValue))", style: .default) { (action) in
                                // apply the type
                                passcodeFaceSize = KeySize.big.rawValue
                            }
                            
                            if passcodeFaceSize == KeySize.small.rawValue {
                                smallAction.setValue(true, forKey: "checked")
                            } else {
                                bigAction.setValue(true, forKey: "checked")
                            }
                            alert.addAction(smallAction)
                            alert.addAction(bigAction)
                            
                            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel) { (action) in
                                // cancels the action
                            }
                            
                            // add the actions
                            alert.addAction(cancelAction)
                            
                            let view: UIView = UIApplication.shared.windows.first!.rootViewController!.view
                            // present popover for iPads
                            alert.popoverPresentationController?.sourceView = view // prevents crashing on iPads
                            alert.popoverPresentationController?.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.maxY, width: 0, height: 0) // show up at center bottom on iPads
                            
                            // present the alert
                            UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
                        })
                        .foregroundColor(.blue)
                        .padding(.leading, 10)
                    }
                    
                    // MARK: Lock Type Prefs
                    if LockManager.deviceLockPath[deviceType] != nil {
                        HStack {
                            Text("Lock Type")
                                .minimumScaleFactor(0.5)
                            
                            Spacer()
                            
                            Button(lockPrefs, action: {
                                // create and configure alert controller
                                let alert = UIAlertController(title: NSLocalizedString("Choose a lock preference", comment: "Title for lock preference"), message: NSLocalizedString("If the custom lock does not apply for you, try another option.", comment: "Description for lock preference"), preferredStyle: .actionSheet)
                                let devModel = UIDevice().machineName
                                
                                // create the actions
                                for (_, title) in LockManager.globalLockPaths.enumerated() {
                                    var rec: String = ""
                                    if LockManager.deviceLockPath[devModel] != nil && LockManager.deviceLockPath[devModel]! == title {
                                        rec = " " + NSLocalizedString("(Recommended)", comment: "Recommended lock type")
                                    }
                                    
                                    let newAction = UIAlertAction(title: title+rec, style: .default) { (action) in
                                        // apply the type
                                        lockPrefs = title
                                    }
                                    if lockPrefs == title {
                                        // add a check mark if selected
                                        newAction.setValue(true, forKey: "checked")
                                    }
                                    alert.addAction(newAction)
                                }
                                
                                let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel) { (action) in
                                    // cancels the action
                                }
                                
                                // add the actions
                                alert.addAction(cancelAction)
                                
                                let view: UIView = UIApplication.shared.windows.first!.rootViewController!.view
                                // present popover for iPads
                                alert.popoverPresentationController?.sourceView = view // prevents crashing on iPads
                                alert.popoverPresentationController?.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.maxY, width: 0, height: 0) // show up at center bottom on iPads
                                
                                // present the alert
                                UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
                            })
                            .foregroundColor(.blue)
                            .padding(.leading, 10)
                        }
                    }
                } header: {
                    Label("App Preferences", systemImage: "gearshape")
                }
                
                Section {
                    Section {
                        Picker(selection: $puaf_pages_index, label: Text("puaf pages:")) {
                            ForEach(0 ..< puaf_pages_options.count, id: \.self) {
                                Text(String(self.puaf_pages_options[$0]))
                            }
                        }.disabled(kfd != 0)
                    }
                    Section {
                        Picker(selection: $puaf_method, label: Text("puaf method:")) {
                            ForEach(0 ..< puaf_method_options.count, id: \.self) {
                                Text(self.puaf_method_options[$0])
                            }
                        }.disabled(kfd != 0)
                    }
                    Section {
                        Picker(selection: $kread_method, label: Text("kread method:")) {
                            ForEach(0 ..< kread_method_options.count, id: \.self) {
                                Text(self.kread_method_options[$0])
                            }
                        }.disabled(kfd != 0)
                    }
                    Section {
                        Picker(selection: $kwrite_method, label: Text("kwrite method:")) {
                            ForEach(0 ..< kwrite_method_options.count, id: \.self) {
                                Text(self.kwrite_method_options[$0])
                            }
                        }.disabled(kfd != 0)
                    }
                } header: {
                    Label("Exploit Preferences", systemImage: "ladybug")
                }
            }
            .navigationTitle("Cluckabunga")
        }
        .onAppear {
            if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String, build != "0" {
                versionBuildString = "Beta \(build)"
            }
        }
    }
    
    func applyTweaks() {
        UIApplication.shared.alert(title: "Opening kernel...", body: "Please wait", animated: false, withButton: false)
        // kopen
        puaf_pages = puaf_pages_options[puaf_pages_index]
        kfd = do_kopen(UInt64(puaf_pages), UInt64(puaf_method), UInt64(kread_method), UInt64(kwrite_method))
        do_fun()
        
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        UIApplication.shared.change(title: "Applying springboard tweaks...", body: "Please wait")
        // apply the springboard tweaks first
        applySpringboardTweaks()
        
        // apply the settings tweak
        do {
            try SettingsCustomizerManager.apply()
        } catch {
            print(error.localizedDescription)
        }
        
        // apply font
        do {
            try FontManager.applyCurrentFont()
        } catch {
            print(error.localizedDescription)
        }
        
        // Apply Locks
        if UserDefaults.standard.string(forKey: "CurrentLock") ?? "Default" != "Default" {
            let lockName: String = UserDefaults.standard.string(forKey: "CurrentLock")!
            print("applying lock")
            let _ = LockManager.applyLock(lockName: lockName)
        }
        
        // Apply Dynamic Island
        do {
            if changingDeviceSubtype == true {
                try OtherModsManager.applyDeviceSubtype(newSubType: newDeviceSubtype)
                changingDeviceSubtype = false
            }
        } catch {
            print(error.localizedDescription)
        }
        
        // Apply Supervision
//        if changingSupervision {
//            setSuperviseMode(isSupervised)
//            changingSupervision = false
//        }
        
        // Apply resolution
        if changingResolution {
            ResSet16(newResolutionX, newResolutionY)
        }
        
        // kclose
        do_kclose(kfd)
        puaf_pages = 0
        kfd = 0
        
        // auto respring on apply
        UIApplication.shared.change(title: "Respringing...", body: "Please wait")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            UIApplication.shared.dismissAlert(animated: false)
            // respring
            UsefulFunctions.respring()
        }
    }
    
    struct GeneralOption: Identifiable {
        var id = UUID()
        var key: String
        var fileType: OverwritingFileTypes
        var sbType: SpringboardColorManager.SpringboardType?
    }
    
    func applySpringboardTweaks() {
        // Crappy code below!
        let tweakOptions: [GeneralOption] = [
            .init(key: "Dock", fileType: OverwritingFileTypes.springboard, sbType: .dock),
            .init(key: "HomeBar", fileType: OverwritingFileTypes.springboard),
            .init(key: "FolderBG", fileType: OverwritingFileTypes.springboard, sbType: .folder),
            .init(key: "FolderBlur", fileType: OverwritingFileTypes.springboard, sbType: .folderBG),
            .init(key: "Switcher", fileType: OverwritingFileTypes.springboard, sbType: .switcher),
            .init(key: "CCBG", fileType: .springboard, sbType: .moduleBG),
            .init(key: "CCModuleBG", fileType: OverwritingFileTypes.cc, sbType: .module),
            .init(key: "PodBG", fileType: OverwritingFileTypes.springboard, sbType: .libraryFolder),
            .init(key: "NotifBG", fileType: OverwritingFileTypes.springboard, sbType: .notif),
            .init(key: "NotifShadow", fileType: .springboard, sbType: .notifShadow)
        ]
        enum SpringBoardOptions: String, CaseIterable {
            case DockHidden = "DockHidden"
            case HomeBarHidden = "HomeBar"
            case FolderBGHidden = "FolderBGHidden"
            case FolderBlurDisabled = "FolderBlurDisabled"
            case SwitcherBlurDisabled = "SwitcherBlurDisabled"
            case CCModuleBackgroundDisabled = "CCModuleBackgroundDisabled"
            case PodBackgroundDisabled = "PodBackgroundDisabled"
            case NotifBackgroundDisabled = "NotifBackgroundDisabled"
            case ShortcutBanner = "ShortcutBanner"
        }
        let replacementPaths: [String: [String]] = [
            SpringBoardOptions.DockHidden.rawValue: ["CoreMaterial.framework/dockDark.materialrecipe", "CoreMaterial.framework/dockLight.materialrecipe"],
            SpringBoardOptions.HomeBarHidden.rawValue: ["MaterialKit.framework/Assets.car"],
            SpringBoardOptions.FolderBGHidden.rawValue: ["SpringBoardHome.framework/folderLight.materialrecipe", "SpringBoardHome.framework/folderDark.materialrecipe", "SpringBoardHome.framework/folderDarkSimplified.materialrecipe"],
            SpringBoardOptions.FolderBlurDisabled.rawValue: ["SpringBoardHome.framework/folderExpandedBackgroundHome.materialrecipe", "SpringBoardHome.framework/folderExpandedBackgroundHomeSimplified.materialrecipe"],
            SpringBoardOptions.SwitcherBlurDisabled.rawValue: ["SpringBoard.framework/homeScreenBackdrop-application.materialrecipe", "SpringBoard.framework/homeScreenBackdrop-switcher.materialrecipe"],
            SpringBoardOptions.CCModuleBackgroundDisabled.rawValue: ["CoreMaterial.framework/modules.materialrecipe"],
            SpringBoardOptions.PodBackgroundDisabled.rawValue: ["SpringBoardHome.framework/podBackgroundViewLight.visualstyleset", "SpringBoardHome.framework/podBackgroundViewDark.visualstyleset"],
            SpringBoardOptions.NotifBackgroundDisabled.rawValue: ["CoreMaterial.framework/plattersDark.materialrecipe", "CoreMaterial.framework/platters.materialrecipe"],
            SpringBoardOptions.ShortcutBanner.rawValue: ["SpringBoard.framework/BannersAuthorizedBundleIDs.plist"]
        ]
        // override
//        if hideDock {
//            overwriteWithFileImpl(replacementURL: URL(fileReferenceLiteralResourceName: "corrupted"), pathToTargetFile: "/System/Library/PrivateFrameworks/CoreMaterial.framework/dockLight.materialrecipe")
//            overwriteWithFileImpl(replacementURL: URL(fileReferenceLiteralResourceName: "corrupted"), pathToTargetFile: "/System/Library/PrivateFrameworks/CoreMaterial.framework/dockDark.materialrecipe")
//        }
//
//        if hideHomeBar {
//            overwriteWithFileImpl(replacementURL: URL(fileReferenceLiteralResourceName: "corrupted"), pathToTargetFile: "/System/Library/PrivateFrameworks/MaterialKit.framework/Assets.car")
//        }
//
//        if hideFolderBG {
//            overwriteWithFileImpl(replacementURL: URL(fileReferenceLiteralResourceName: "corrupted"), pathToTargetFile: "/System/Library/PrivateFrameworks/SpringBoardHome.framework/folderLight.materialrecipe")
//            overwriteWithFileImpl(replacementURL: URL(fileReferenceLiteralResourceName: "corrupted"), pathToTargetFile: "/System/Library/PrivateFrameworks/SpringBoardHome.framework/folderDark.materialrecipe")
//            overwriteWithFileImpl(replacementURL: URL(fileReferenceLiteralResourceName: "corrupted"), pathToTargetFile: "/System/Library/PrivateFrameworks/SpringBoardHome.framework/folderDarkSimplified.materialrecipe")
//        }
        for option in tweakOptions {
            // get the user defaults
            let value: String = UserDefaults.standard.string(forKey: option.key) ?? "Visible"
            if value == "Color" || value == "Blur" || value == "Disabled" {
                print("Applying tweak \"" + option.key + "\"")
                var succeeded = false
                print(value)
                if option.sbType != nil {
                    SpringboardColorManager.applyColor(forType: option.sbType!)
                    succeeded = true
                } else {
//                    succeeded = overwriteFile(typeOfFile: option.fileType, fileIdentifier: option.key)
                    // springboard tweak being applied
                    if replacementPaths[option.key] != nil {
                        var succeeded = true
                        for path in replacementPaths[option.key]! {
                            try? overwriteWithFileImpl(replacementURL: URL(fileReferenceLiteralResourceName: "corrupted"), pathToTargetFile: "/System/Library/PrivateFrameworks/" + path)
                        }
                    }
                }
                if succeeded {
                    print("Successfully applied tweak \"" + option.key + "\"")
                } else {
                    print("Failed to apply tweak \"" + option.key + "\"!!!")
                }
            }
        }
    }
}
