//
//  PastaTimerWidgetLiveActivity.swift
//  PastaTimerWidget
//
//  Created by SungHyun Kim on 8/25/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct PastaTimerWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct PastaTimerWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PastaTimerWidgetAttributes.self) { context in
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

extension PastaTimerWidgetAttributes {
    fileprivate static var preview: PastaTimerWidgetAttributes {
        PastaTimerWidgetAttributes(name: "World")
    }
}

extension PastaTimerWidgetAttributes.ContentState {
    fileprivate static var smiley: PastaTimerWidgetAttributes.ContentState {
        PastaTimerWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: PastaTimerWidgetAttributes.ContentState {
         PastaTimerWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: PastaTimerWidgetAttributes.preview) {
   PastaTimerWidgetLiveActivity()
} contentStates: {
    PastaTimerWidgetAttributes.ContentState.smiley
    PastaTimerWidgetAttributes.ContentState.starEyes
}
