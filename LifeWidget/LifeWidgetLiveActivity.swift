//
//  LifeWidgetLiveActivity.swift
//  LifeWidget
//
//  Created by Art3mis on 28/01/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct LifeWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct LifeWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LifeWidgetAttributes.self) { context in
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

extension LifeWidgetAttributes {
    fileprivate static var preview: LifeWidgetAttributes {
        LifeWidgetAttributes(name: "World")
    }
}

extension LifeWidgetAttributes.ContentState {
    fileprivate static var smiley: LifeWidgetAttributes.ContentState {
        LifeWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: LifeWidgetAttributes.ContentState {
         LifeWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: LifeWidgetAttributes.preview) {
   LifeWidgetLiveActivity()
} contentStates: {
    LifeWidgetAttributes.ContentState.smiley
    LifeWidgetAttributes.ContentState.starEyes
}
