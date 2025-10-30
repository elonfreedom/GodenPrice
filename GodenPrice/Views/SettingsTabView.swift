//
//  SettingsTabView.swift
//  GodenPrice
//
//  Created by assistant on 2025/10/30.
//

import SwiftUI
import WidgetKit

// Ensure this matches the App Group you enable in the project capabilities.
private let appGroupID = "group.com.elon.GodenPrice"

struct SettingsTabView: View {
    @AppStorage("goldUnit") private var storedUnit: String = GoldUnit.usdPerOunce.rawValue

    var body: some View {
        Form {
            Section(header: Text("Display unit")) {
                Picker("Unit", selection: $storedUnit) {
                    Text("$/oz").tag(GoldUnit.usdPerOunce.rawValue)
                    Text("¥/g").tag(GoldUnit.cnyPerGram.rawValue)
                }
                .pickerStyle(.segmented)
            }
            Section(header: Text("Notes")) {
                Text("Gold prices come from data-asg.goldprice.org. When you choose ¥/g the app/widget will use the CNY per-ounce endpoint and convert to grams.")
                    .font(.caption)
            }
        }
        .onChange(of: storedUnit) { newValue in
            // write into shared App Group UserDefaults so widget can read the same selection
            if let ud = UserDefaults(suiteName: appGroupID) {
                ud.set(newValue, forKey: "goldUnit")
                ud.synchronize()
            }
            // also ensure WidgetKit reloads timelines to reflect the new unit immediately
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}

struct SettingsTabView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsTabView()
    }
}
