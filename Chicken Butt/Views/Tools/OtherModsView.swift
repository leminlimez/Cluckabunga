//
//  OtherModsView.swift
//  Chicken Butt
//
//  Created by lemin on 8/3/23.
//

import SwiftUI

struct OtherModsView: View {
    struct DeviceSubType: Identifiable {
        var id = UUID()
        var key: Int
        var title: String
    }
    
    // list of options
    @State var deviceSubTypes: [DeviceSubType] = [
        .init(key: 0, title: NSLocalizedString("Default", comment: "default device subtype")),
        .init(key: 2436, title: NSLocalizedString("iPhone X Gestures", comment: "x gestures")),
        .init(key: 2556, title: NSLocalizedString("Dynamic Island", comment: "iPhone 14 Pro SubType")),
        .init(key: 2796, title: NSLocalizedString("Dynamic Island Pro Max", comment: "iPhone 14 Pro Max SubType"))
    ]
    
    @AppStorage("ChangingDeviceSubtype") var changingDeviceSubtype: Bool = false
    @AppStorage("NewDeviceSubtype") var newDeviceSubtype: Int = 0
    
    @AppStorage("ChangingSupervision") var changingSupervision: Bool = false
    @AppStorage("IsSupervised") var isSupervised: Bool = false
    
    @AppStorage("ChangingResolution") var changingResolution: Bool = false
    @AppStorage("NewResolutionX") var newResolutionX: Int = 0
    @AppStorage("NewResolutionY") var newResolutionY: Int = 0
    
    var body: some View {
        List {
            Section {
                // device supervision
//                HStack {
//                    Image(systemName: "iphone")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 24, height: 24)
//                        .foregroundColor(.blue)
//
//                    Text("Supervised")
//                        .minimumScaleFactor(0.5)
//
//                    Spacer()
//
//                    Toggle(isOn: $isSupervised) {
//
//                    }.onChange(of: isSupervised) { new in
//                        changingSupervision = true
//                    }
//                    .padding(.leading, 10)
//                }
                
                // device resolution
                HStack {
                    Image(systemName: "iphone")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .foregroundColor(.blue)
                    
                    Text("Resolution")
                        .minimumScaleFactor(0.5)
                    
                    Spacer()
                    
                    Button(action: {
                        if changingResolution {
                            changingResolution = false
                        } else {
                            // ask the user for a custom size
                            let sizeAlert = UIAlertController(title: NSLocalizedString("Enter New Resolution", comment: "res changer"), message: "", preferredStyle: .alert)
                            // bring up the text prompts
                            sizeAlert.addTextField { (textField) in
                                // text field for width
                                textField.placeholder = NSLocalizedString("Width", comment: "Width of passcode keys")
                            }
                            sizeAlert.addTextField { (textField) in
                                // text field for height
                                textField.placeholder = NSLocalizedString("Height", comment: "Height of passcode keys")
                            }
                            sizeAlert.addAction(UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .default) { (action) in
                                // set the sizes
                                // check if they entered something and if it is in bounds
                                let width: Int = Int(sizeAlert.textFields?[0].text! ?? "-1") ?? -1
                                let height: Int = Int(sizeAlert.textFields?[1].text! ?? "-1") ?? -1
                                newResolutionX = width
                                newResolutionY = height
                                changingResolution = true
                            })
                            sizeAlert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { (action) in
                                // cancel the process
                            })
                            UIApplication.shared.windows.first?.rootViewController?.present(sizeAlert, animated: true, completion: nil)
                        }
                    }) {
                        Text(changingResolution ? "(\(newResolutionX)x\(newResolutionY)) Remove" : "Set")
                            .foregroundColor(changingResolution ? .red : .blue)
                    }
                    .padding(.leading, 10)
                }
            }
            Section {
                // device subtype
                if UIDevice.current.userInterfaceIdiom == .phone {
                    HStack {
                        Image(systemName: "ipodtouch")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                            .foregroundColor(.blue)
                        
                        
                        Text("Gestures / Dynamic Island")
                            .minimumScaleFactor(0.5)
                        
                        Spacer()
                        
                        Button(newDeviceSubtype == 0 ? "Default" : String(newDeviceSubtype), action: {
                            showSubTypeChangerPopup()
                        })
                        .foregroundColor(.blue)
                        .padding(.leading, 10)
                    }
                }
            } header: {
                Label("Use at your own risk", systemImage: "exclamationmark.triangle")
            }
        }
        .navigationTitle("Miscellaneous")
        .navigationViewStyle(.stack)
    }
    
    func showSubTypeChangerPopup() {
        // create and configure alert controller
        let alert = UIAlertController(title: NSLocalizedString("Choose a device subtype", comment: ""), message: NSLocalizedString("Respring to see changes", comment: ""), preferredStyle: .actionSheet)
        
        var iOS16 = false
        if #available(iOS 16, *) {
            iOS16 = true
        }
        
        // create the actions
        
        for type in deviceSubTypes {
            let newAction = UIAlertAction(title: type.title + " (" + String(type.key) + ")", style: .default) { (action) in
                changingDeviceSubtype = true
                newDeviceSubtype = type.key
            }
            if newDeviceSubtype == type.key {
                // add a check mark
                newAction.setValue(true, forKey: "checked")
            }
            alert.addAction(newAction)
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { (action) in
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
    }
}

struct OtherModsView_Previews: PreviewProvider {
    static var previews: some View {
        OtherModsView()
    }
}
