//
//  CurrentPriceLiveActivity.swift
//  CurrentPrice
//
//  Created by elon on 2025/10/29.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct CurrentPriceAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct CurrentPriceLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: CurrentPriceAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension CurrentPriceAttributes {
    fileprivate static var preview: CurrentPriceAttributes {
        CurrentPriceAttributes(name: "World")
    }
}

extension CurrentPriceAttributes.ContentState {
    fileprivate static var smiley: CurrentPriceAttributes.ContentState {
        CurrentPriceAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: CurrentPriceAttributes.ContentState {
         CurrentPriceAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: CurrentPriceAttributes.preview) {
   CurrentPriceLiveActivity()
} contentStates: {
    CurrentPriceAttributes.ContentState.smiley
    CurrentPriceAttributes.ContentState.starEyes
}
