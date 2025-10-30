//
//  ContentView.swift
//  GodenPrice
//
//  Created by elon on 2025/10/29.
//

import SwiftUI
import SwiftData

/// ContentView is now a thin composition root; views and view model moved to separate files (MVVM).
struct ContentView: View {
    var body: some View {
        TabView {
            PriceTabView()
                .tabItem {
                    Label("Price", systemImage: "dollarsign.circle")
                }

            SettingsTabView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
    }
}

#Preview {
    ContentView()
}
