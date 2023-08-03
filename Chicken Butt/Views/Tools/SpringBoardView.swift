//
//  SpringBoardView.swift
//  Chicken Butt
//
//  Created by lemin on 8/2/23.
//

import SwiftUI

struct SpringBoardView: View {
    @AppStorage("HideDock") var hideDock: Bool = false
    @AppStorage("HideHomeBar") var hideHomeBar: Bool = false
    @AppStorage("HideFolderBG") var hideFolderBG: Bool = false
    
    var body: some View {
        List {
            Toggle(isOn: $hideDock) {
                Text("Hide Dock")
            }
            Toggle(isOn: $hideHomeBar) {
                Text("Hide Home Bar")
            }
            Toggle(isOn: $hideFolderBG) {
                Text("Hide Folder BG")
            }
        }.padding(5)
    }
}

struct SpringBoardView_Previews: PreviewProvider {
    static var previews: some View {
        SpringBoardView()
    }
}
