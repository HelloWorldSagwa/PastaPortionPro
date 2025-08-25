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
        var endTime: Date  // Changed to use Date for automatic countdown
        var isPaused: Bool
        var remainingTime: Int  // Keep for display purposes
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
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 4) {
                            Image(systemName: "timer")
                                .font(.caption)
                                .foregroundColor(Color("mainRed"))
                            Text(context.attributes.pastaName)
                                .font(.caption)
                                .foregroundColor(.primary)
                        }
                        // Use timer countdown for real-time updates
                        Text(timerInterval: Date.now...context.state.endTime, countsDown: true)
                            .font(.title3.monospacedDigit().bold())
                            .foregroundColor(Color("mainRed"))
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    // Circular Progress (like in the app)
                    ZStack {
                        Circle()
                            .stroke(Color.gray.opacity(0.2), lineWidth: 3)
                            .frame(width: 50, height: 50)
                        
                        Circle()
                            .trim(from: 0, to: 1.0 - (CGFloat(context.state.remainingTime) / CGFloat(context.attributes.totalTime)))
                            .stroke(Color("mainRed"), lineWidth: 3)
                            .frame(width: 50, height: 50)
                            .rotationEffect(.degrees(-90))
                        
                        Text("\(Int((1.0 - Double(context.state.remainingTime) / Double(context.attributes.totalTime)) * 100))%")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
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
                Text(timerInterval: Date.now...context.state.endTime, countsDown: true)
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
                VStack(alignment: .leading, spacing: 4) {
                    // Use timer countdown for real-time updates
                    Text(timerInterval: Date.now...context.state.endTime, countsDown: true)
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .monospacedDigit()
                        .foregroundColor(Color("mainRed"))
                    
                    Text("\(Int((1.0 - Double(context.state.remainingTime) / Double(context.attributes.totalTime)) * 100))% complete")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            // Progress Bar (shows progress, not remaining)
            ProgressView(value: Double(context.attributes.totalTime - context.state.remainingTime), 
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
            print("❌ Live Activities are not enabled")
            return
        }
        
        // Stop existing activity if any
        stopActivity()
        
        let attributes = PastaTimerActivityAttributes(
            pastaName: pastaName,
            totalTime: totalSeconds
        )
        
        let endTime = Date().addingTimeInterval(TimeInterval(totalSeconds))
        let initialState = PastaTimerActivityAttributes.ContentState(
            endTime: endTime,
            isPaused: false,
            remainingTime: totalSeconds
        )
        
        do {
            let activity = try Activity.request(
                attributes: attributes,
                content: .init(state: initialState, staleDate: endTime),
                pushType: nil
            )
            self.currentActivity = activity
            print("✅ Started Live Activity")
            print("   - ID: \(activity.id)")
            print("   - Pasta: \(pastaName)")
            print("   - Duration: \(totalSeconds) seconds")
            print("   - End Time: \(endTime)")
        } catch {
            print("❌ Failed to start Live Activity: \(error)")
        }
    }
    
    func updateActivity(remainingSeconds: Int, isPaused: Bool = false) {
        guard let activity = currentActivity else { 
            print("⚠️ No active Live Activity to update")
            return 
        }
        
        let endTime = isPaused ? Date().addingTimeInterval(TimeInterval(remainingSeconds)) : activity.content.state.endTime
        let updatedState = PastaTimerActivityAttributes.ContentState(
            endTime: endTime,
            isPaused: isPaused,
            remainingTime: remainingSeconds
        )
        
        Task {
            await activity.update(using: updatedState)
            print("📱 Updated Live Activity: \(remainingSeconds)s remaining, isPaused: \(isPaused)")
        }
    }
    
    func pauseActivity() {
        guard let activity = currentActivity else { 
            print("⚠️ No active Live Activity to pause")
            return 
        }
        
        Task {
            let state = activity.content.state
            // Calculate remaining time from endTime
            let remaining = max(0, Int(state.endTime.timeIntervalSinceNow))
            let pausedState = PastaTimerActivityAttributes.ContentState(
                endTime: Date().addingTimeInterval(TimeInterval(remaining)),
                isPaused: true,
                remainingTime: remaining
            )
            await activity.update(using: pausedState)
            print("⏸️ Paused Live Activity with \(remaining)s remaining")
        }
    }
    
    func resumeActivity() {
        guard let activity = currentActivity else { 
            print("⚠️ No active Live Activity to resume")
            return 
        }
        
        Task {
            let state = activity.content.state
            let newEndTime = Date().addingTimeInterval(TimeInterval(state.remainingTime))
            let resumedState = PastaTimerActivityAttributes.ContentState(
                endTime: newEndTime,
                isPaused: false,
                remainingTime: state.remainingTime
            )
            await activity.update(using: resumedState)
            print("▶️ Resumed Live Activity with new end time: \(newEndTime)")
        }
    }
    
    func stopActivity() {
        guard let activity = currentActivity else { 
            print("⚠️ No active Live Activity to stop")
            return 
        }
        
        Task {
            await activity.end(nil, dismissalPolicy: .immediate)
            print("🛑 Stopped Live Activity: \(activity.id)")
            await MainActor.run {
                self.currentActivity = nil
            }
        }
    }
}