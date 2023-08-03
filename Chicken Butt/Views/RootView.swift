//
//  RootView.swift
//  Chicken Butt
//
//  Created by lemin on 8/2/23.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            ToolsView()
                .tabItem {
                    Label("Tools", systemImage: "wrench.and.screwdriver.fill")
                }
            ThemesExploreView()
                .tabItem {
                    Label("Explore", systemImage: "safari")
                }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
