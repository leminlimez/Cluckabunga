//
//  ContentView.swift
//  Chicken Butt
//
//  Created by lemin on 8/1/23.
//

import SwiftUI

struct ContentView: View {
    @State var isApplying: Bool = false
    
    // Tweaks
    @State var hideDock = false
    @State var hideHomeBar = false
    @State var hideFolderBG = false
    
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
        VStack {
            HStack {
                Text("Chicken Butt")
                    .font(.title)
                    .bold()
                Spacer()
            }
            .padding(5)
            Divider()
            Toggle(isOn: $hideDock) {
                Text("Hide Dock")
            }
            Toggle(isOn: $hideHomeBar) {
                Text("Hide Home Bar")
            }
            Toggle(isOn: $hideFolderBG) {
                Text("Hide Folder BG")
            }
            Spacer()
            Button(action: {
                if !isApplying {
                    isApplying = true
                    
                    // kopen
                    puaf_pages = puaf_pages_options[puaf_pages_index]
                                                kfd = do_kopen(UInt64(puaf_pages), UInt64(puaf_method), UInt64(kread_method), UInt64(kwrite_method))
                                                do_fun()
                    
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
                    
                    // kclose
                    do_kclose(kfd)
                    puaf_pages = 0
                    kfd = 0
                    
                    // respring
                    restartFrontboard()
                }
            }) {
                Text("Apply")
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
