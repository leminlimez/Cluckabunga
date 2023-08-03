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
    @AppStorage("HideDock") var hideDock: Bool = false
    @AppStorage("HideHomeBar") var hideHomeBar: Bool = false
    @AppStorage("HideFolderBG") var hideFolderBG: Bool = false
    
    // Exploit Stuffs
    @State private var kfd: UInt64 = 0
        
    private var puaf_pages_options = [16, 32, 64, 128, 256, 512, 1024, 2048]
    @State private var puaf_pages_index = 7
    @State private var puaf_pages = 0
    
    private var puaf_method_options = ["physpuppet", "smith"]
    @State private var puaf_method = 1
    
    private var kread_method_options = ["kqueue_workloop_ctl", "sem_open"]
    @State private var kread_method = 1
    
    private var kwrite_method_options = ["dup", "sem_open"]
    @State private var kwrite_method = 1
    
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
                    }
                }
            }
        }
        .onAppear {
            if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String, build != "0" {
                versionBuildString = "Beta \(build)"
            }
        }
        .navigationTitle("Chicken Butt")
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
//        do {
//            try SettingsCustomizerManager.apply()
//        } catch {
//            print(error.localizedDescription)
//        }
        
        // Apply Locks
        if UserDefaults.standard.string(forKey: "CurrentLock") ?? "Default" != "Default" {
            let lockName: String = UserDefaults.standard.string(forKey: "CurrentLock")!
            print("applying lock")
            let _ = LockManager.applyLock(lockName: lockName)
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
            restartFrontboard()
        }
    }
    
    func applySpringboardTweaks() {
        // override
        if hideDock {
            overwriteWithFileImpl(replacementURL: URL(fileReferenceLiteralResourceName: "corrupted"), pathToTargetFile: "/System/Library/PrivateFrameworks/CoreMaterial.framework/dockLight.materialrecipe")
            overwriteWithFileImpl(replacementURL: URL(fileReferenceLiteralResourceName: "corrupted"), pathToTargetFile: "/System/Library/PrivateFrameworks/CoreMaterial.framework/dockDark.materialrecipe")
        }
        
        if hideHomeBar {
            overwriteWithFileImpl(replacementURL: URL(fileReferenceLiteralResourceName: "corrupted"), pathToTargetFile: "/System/Library/PrivateFrameworks/MaterialKit.framework/Assets.car")
        }
        
        if hideFolderBG {
            overwriteWithFileImpl(replacementURL: URL(fileReferenceLiteralResourceName: "corrupted"), pathToTargetFile: "/System/Library/PrivateFrameworks/SpringBoardHome.framework/folderLight.materialrecipe")
            overwriteWithFileImpl(replacementURL: URL(fileReferenceLiteralResourceName: "corrupted"), pathToTargetFile: "/System/Library/PrivateFrameworks/SpringBoardHome.framework/folderDark.materialrecipe")
            overwriteWithFileImpl(replacementURL: URL(fileReferenceLiteralResourceName: "corrupted"), pathToTargetFile: "/System/Library/PrivateFrameworks/SpringBoardHome.framework/folderDarkSimplified.materialrecipe")
        }
    }
}
