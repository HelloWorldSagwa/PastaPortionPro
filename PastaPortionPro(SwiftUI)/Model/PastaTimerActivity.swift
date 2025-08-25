//
//  PastaTimerActivity.swift
//  PastaPortionPro
//
//  Live Activity for Dynamic Island and Lock Screen Timer
//

import ActivityKit
import WidgetKit
import SwiftUI

// MARK: - Activity Attributes
struct PastaTimerActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic state properties
        var remainingTime: Int
        var isPaused: Bool
    }
    
    // Fixed properties
    let pastaName: String
    let totalTime: Int
}

// MARK: - Live Activity Widget
struct PastaTimerLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PastaTimerActivityAttributes.self) { context in
            // Lock Screen / Banner UI
            LockScreenLiveActivityView(context: context)
                .activityBackgroundTint(Color("mainRed").opacity(0.1))
                .activitySystemActionForegroundColor(Color("mainRed"))
            
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI
                DynamicIslandExpandedRegion(.leading) {
                    HStack {
                        Image(systemName: "timer")
                            .foregroundColor(Color("mainRed"))
                        Text(context.attributes.pastaName)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(formatTime(context.state.remainingTime))
                        .font(.title2.monospacedDigit())
                        .foregroundColor(Color("mainRed"))
                }
                DynamicIslandExpandedRegion(.center) {
                    ProgressView(value: Double(context.state.remainingTime), 
                                total: Double(context.attributes.totalTime))
                        .progressViewStyle(LinearProgressViewStyle())
                        .tint(Color("mainRed"))
                }
                DynamicIslandExpandedRegion(.bottom) {
                    HStack {
                        if context.state.isPaused {
                            Label("Paused", systemImage: "pause.circle.fill")
                                .font(.caption)
                                .foregroundColor(.orange)
                        } else {
                            Label("Cooking", systemImage: "flame.fill")
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                        Spacer()
                        Text("Tap to open app")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            } compactLeading: {
                // Compact leading (Dynamic Island minimized)
                Image(systemName: "timer")
                    .foregroundColor(Color("mainRed"))
            } compactTrailing: {
                // Compact trailing (Dynamic Island minimized)
                Text(formatTime(context.state.remainingTime))
                    .font(.caption.monospacedDigit())
                    .foregroundColor(Color("mainRed"))
            } minimal: {
                // Minimal (Dynamic Island tiny)
                Image(systemName: "timer")
                    .foregroundColor(Color("mainRed"))
            }
            .widgetURL(URL(string: "pastaportionpro://timer"))
            .keylineTint(Color("mainRed"))
        }
    }
}

// MARK: - Lock Screen View
struct LockScreenLiveActivityView: View {
    let context: ActivityViewContext<PastaTimerActivityAttributes>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header
            HStack {
                Image(systemName: "timer.circle.fill")
                    .font(.title2)
                    .foregroundColor(Color("mainRed"))
                
                Text(context.attributes.pastaName)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if context.state.isPaused {
                    Text("PAUSED")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.orange.opacity(0.2))
                        .foregroundColor(.orange)
                        .cornerRadius(4)
                } else {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 8, height: 8)
                        Text("Cooking")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                }
            }
            
            // Timer Display
            HStack {
                Text(formatTime(context.state.remainingTime))
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .foregroundColor(Color("mainRed"))
                
                Spacer()
                
                // Progress Circle
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 4)
                        .frame(width: 60, height: 60)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(context.state.remainingTime) / CGFloat(context.attributes.totalTime))
                        .stroke(Color("mainRed"), lineWidth: 4)
                        .frame(width: 60, height: 60)
                        .rotationEffect(.degrees(-90))
                    
                    Text("\(Int(Double(context.state.remainingTime) / Double(context.attributes.totalTime) * 100))%")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Progress Bar
            ProgressView(value: Double(context.state.remainingTime), 
                        total: Double(context.attributes.totalTime))
                .progressViewStyle(LinearProgressViewStyle())
                .tint(Color("mainRed"))
                .scaleEffect(x: 1, y: 2, anchor: .center)
        }
        .padding()
    }
}

// MARK: - Helper Functions
private func formatTime(_ seconds: Int) -> String {
    let minutes = seconds / 60
    let remainingSeconds = seconds % 60
    return String(format: "%d:%02d", minutes, remainingSeconds)
}

// MARK: - Live Activity Manager
class PastaTimerActivityManager {
    static let shared = PastaTimerActivityManager()
    private var currentActivity: Activity<PastaTimerActivityAttributes>?
    
    private init() {}
    
    func startActivity(pastaName: String, totalSeconds: Int) {
        // Check if activities are enabled
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            print("Live Activities are not enabled")
            return
        }
        
        // Stop existing activity if any
        stopActivity()
        
        let attributes = PastaTimerActivityAttributes(
            pastaName: pastaName,
            totalTime: totalSeconds
        )
        
        let initialState = PastaTimerActivityAttributes.ContentState(
            remainingTime: totalSeconds,
            isPaused: false
        )
        
        do {
            let activity = try Activity.request(
                attributes: attributes,
                content: .init(state: initialState, staleDate: nil),
                pushType: nil
            )
            self.currentActivity = activity
            print("Started Live Activity with ID: \(activity.id)")
        } catch {
            print("Failed to start Live Activity: \(error)")
        }
    }
    
    func updateActivity(remainingSeconds: Int, isPaused: Bool = false) {
        guard let activity = currentActivity else { return }
        
        let updatedState = PastaTimerActivityAttributes.ContentState(
            remainingTime: remainingSeconds,
            isPaused: isPaused
        )
        
        Task {
            await activity.update(using: updatedState)
        }
    }
    
    func pauseActivity() {
        guard let activity = currentActivity else { return }
        
        Task {
            let state = activity.content.state
            let pausedState = PastaTimerActivityAttributes.ContentState(
                remainingTime: state.remainingTime,
                isPaused: true
            )
            await activity.update(using: pausedState)
        }
    }
    
    func resumeActivity() {
        guard let activity = currentActivity else { return }
        
        Task {
            let state = activity.content.state
            let resumedState = PastaTimerActivityAttributes.ContentState(
                remainingTime: state.remainingTime,
                isPaused: false
            )
            await activity.update(using: resumedState)
        }
    }
    
    func stopActivity() {
        guard let activity = currentActivity else { return }
        
        Task {
            await activity.end(nil, dismissalPolicy: .immediate)
            self.currentActivity = nil
        }
    }
}