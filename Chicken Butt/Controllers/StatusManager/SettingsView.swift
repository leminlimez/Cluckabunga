//
//  SettingsView.swift
//  StatusMagic
//
//  Created by Rory Madden on 7/2/2023.
//

import SwiftUI

struct SettingsView: View {
    @State private var useAlternativeSetter = UserDefaults.standard.bool(forKey: "UseAlternativeSetter")
    
    func saveSettings() {
        UserDefaults.standard.set(useAlternativeSetter, forKey: "UseAlternativeSetter")
//        exitGracefully()
    }
    
    var body: some View {
        Form {
            List {
                Section(footer: Text("The app will quit.")) {
                    Button("Save Settings") {
                        saveSettings()
                    }
                }
                if #available(iOS 16.1, *) {
                    Section(footer: Text("Use this if carrier/time text isn't applying. I would recommend you Reset to Defaults after turning on and saving.")) {
                        Toggle(isOn: $useAlternativeSetter) {
                            Text("Use Alternative Setter")
                        }
                    }
                }
            }
        }.navigationBarTitle("Settings", displayMode: .inline)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
