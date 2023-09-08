//
//  ContentView.swift
//  ID Changer
//
//  Created by lemin on 8/29/23.
//

import SwiftUI
import ACarousel

struct MainCardView: View {
    @State var cardPaths: [Card] = []
    @State var fullPath = "/var/mobile/Library/Passes/Cards"
    
    // Card Variables
    @State private var changedSomething: Bool = false
    
    // KFD Exploit Stuffs
    @State private var vnodeOrig: UInt64 = 0
        
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
        VStack {
            HStack {
                Text("Cardinal")
                    .font(.largeTitle)
                    .bold()
                Spacer()
            }
            .padding(.bottom, 10)
            
            HStack {
                Spacer()
                Text("Tap on an image to change it.")
                    .font(.headline)
                Spacer()
            }
            .padding(.vertical, 5)
            
            Spacer()
            
            // Cards View
            if !cardPaths.isEmpty {
                ACarousel($cardPaths) { i in
                    CardView(
                        vnodeOrig: vnodeOrig,
                        fullPath: fullPath, card: i,
                        changedSomething: $changedSomething
                    )
                }
            } else {
                Text("Error! No cards found!")
                    .foregroundColor(.red)
            }
            
            Spacer()
            
            HStack {
                // Apply Button
                Button(action: {
                    print("Applying Card...")
                    MainCardController.setChanges(PasscodeKeyFaceManager.kfd, vnodeOrig: vnodeOrig, cards: cardPaths, fullPath: fullPath)
                }) {
                    Text("Apply")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .padding(.vertical, 16)
                        .opacity((changedSomething) ? 1 : 0)
                }
                .disabled(!changedSomething)
            }
            
            if #available(iOS 16.2, *) {
                Button(action: {
                    UnRedirectAndRemoveFolder(vnodeOrig, fullPath + "/Cards/")
                    do_kclose(PasscodeKeyFaceManager.kfd)

                    respring()
                }) {
                    Text("kclose")
                }
            }
        }
        .padding()
        .onAppear {
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" {
                if #available(iOS 16.5.1, *), !ProcessInfo.processInfo.operatingSystemVersionString.contains("20G5026e") {
                    UIApplication.shared.alert(title: "Device Not Supported", body: "Your device is not supported by the KFD exploit, the app will not function, sorry.")
                } else if #available(iOS 16.2, *) {
                    if !MainCardController.kopened {
                        // kfd stuff
                        UIApplication.shared.confirmAlert(title: "kopen needed", body: "The kernel needs to be opened in order for the app to work. Would you like to do that?\n\nNote: Your device may panic (auto reboot) after applying, this will only happen once and is not permanent.", onOK: {
                            // kopen
                            UIApplication.shared.alert(title: "Opening Kernel...", body: "Please wait...", withButton: false)
                            
                            if !PasscodeKeyFaceManager.kopened {
                                puaf_pages = puaf_pages_options[puaf_pages_index]
                                PasscodeKeyFaceManager.kfd = do_kopen(UInt64(puaf_pages), UInt64(puaf_method), UInt64(kread_method), UInt64(kwrite_method))
                                
                                // clear previous
                                MainCardController.rmMountedDir()
                            }
                            
                            if !FileManager.default.fileExists(atPath: NSHomeDirectory() + "/Documents/mounted") {
                                do {
                                    try FileManager.default.createDirectory(atPath: NSHomeDirectory() + "/Documents/mounted", withIntermediateDirectories: false)
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                            
                            if !FileManager.default.fileExists(atPath: NSHomeDirectory() + "/Documents/mounted/Cards") {
                                do {
                                    try FileManager.default.createDirectory(atPath: NSHomeDirectory() + "/Documents/mounted/Cards", withIntermediateDirectories: false)
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                            
                            // init fun offsets
                            _offsets_init()
                            
                            // redirect
                            fullPath = NSHomeDirectory() + "/Documents/mounted"
                            
                            vnodeOrig = redirectCardsFolder()
                            
                            MainCardController.kopened = true
                            
                            getCards()
                            
                            UIApplication.shared.dismissAlert(animated: true)
                        }, noCancel: false)
                    } else {
                        fullPath = NSHomeDirectory() + "/Documents/mounted"
                        getCards()
                    }
                }
            }
        }
    }
    
    func getCards() {
        // get the cards
        cardPaths = MainCardController.getPasses(fullPath: fullPath)
    }
}

struct MainCardView_Previews: PreviewProvider {
    static var previews: some View {
        MainCardView()
    }
}
