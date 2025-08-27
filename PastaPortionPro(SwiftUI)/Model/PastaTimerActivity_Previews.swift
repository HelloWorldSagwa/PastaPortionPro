//
//  PastaTimerActivity_Previews.swift
//  PastaPortionPro
//
//  SwiftUI Previews for Live Activity
//

import SwiftUI
import ActivityKit
import WidgetKit

// MARK: - SwiftUI Previews
#if DEBUG
import WidgetKit

// Preview for the actual Live Activity Widget
struct LiveActivityPreview: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PastaTimerActivityAttributes.self) { context in
            // Lock Screen Preview
            LockScreenLiveActivityView(context: context)
                .activityBackgroundTint(Color.red.opacity(0.1))
                .activitySystemActionForegroundColor(Color.red)
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded View - 최소한의 콘텐츠만 표시
                DynamicIslandExpandedRegion(.center) {
                    // Show countdown when running, static when paused
                    if context.state.isPaused {
                        Text(formatTime(context.state.remainingTime))
                            .font(.system(size: 16, weight: .semibold, design: .monospaced))
                            .foregroundColor(.white)
                    } else {
                        Text(formatTime(context.state.remainingTime))
                            .font(.system(size: 16, weight: .semibold, design: .monospaced))
                            .foregroundColor(.white)
                    }
                }
            } compactLeading: {
                // Compact leading - Tiny progress ring
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                        .frame(width: 10, height: 10)
                    Circle()
                        .trim(from: 0, to: CGFloat(context.attributes.totalTime - context.state.remainingTime) / CGFloat(context.attributes.totalTime))
                        .stroke(Color.white, lineWidth: 2)
                        .rotationEffect(.degrees(-90))
                        .frame(width: 10, height: 10)
                }
            } compactTrailing: {
                // Compact trailing - Show time
                Text(formatTime(context.state.remainingTime))
                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                    .foregroundColor(.white)
            } minimal: {
                // Minimal - Progress dot
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        .frame(width: 4, height: 4)
                    Circle()
                        .trim(from: 0, to: CGFloat(context.attributes.totalTime - context.state.remainingTime) / CGFloat(context.attributes.totalTime))
                        .stroke(Color.white, lineWidth: 1)
                        .rotationEffect(.degrees(-90))
                        .frame(width: 4, height: 4)
                }
            }
            .widgetURL(URL(string: "pastaportionpro://timer"))
            .keylineTint(Color.white.opacity(0.3))
        }
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }
}

// Mock ActivityViewContext for previews
struct MockActivityViewContext<Attributes: ActivityAttributes> {
    let attributes: Attributes
    let state: Attributes.ContentState
}

extension LockScreenLiveActivityView {
    init(mockContext: MockActivityViewContext<PastaTimerActivityAttributes>) {
        // Create a mock context for preview
        self.init(context: unsafeBitCast(mockContext, to: ActivityViewContext<PastaTimerActivityAttributes>.self))
    }
}

struct PastaTimerActivity_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Lock Screen View - Running
            VStack(alignment: .leading, spacing: 8) {
                // Header
                HStack {
                    Image(systemName: "timer.circle.fill")
                        .font(.title2)
                        .foregroundColor(.red)
                    
                    Text("Spaghetti")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 8, height: 8)
                        Text("Cooking")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                }
                
                // Timer Display
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("5:00")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .monospacedDigit()
                            .foregroundColor(.red)
                        
                        Text("37% complete")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
                
                // Prominent Linear Progress Bar
                ProgressView(value: 0.37)
                    .progressViewStyle(LinearProgressViewStyle())
                    .tint(.red)
                    .scaleEffect(x: 1, y: 3, anchor: .center)
                    .frame(maxWidth: .infinity)
            }
            .padding()
            .background(Color.red.opacity(0.1))
            .previewDisplayName("Lock Screen - Running")
            .previewLayout(.fixed(width: 350, height: 200))
            
            // Lock Screen View - Paused
            VStack(alignment: .leading, spacing: 8) {
                // Header
                HStack {
                    Image(systemName: "timer.circle.fill")
                        .font(.title2)
                        .foregroundColor(.red)
                    
                    Text("Penne")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text("PAUSED")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.orange.opacity(0.2))
                        .foregroundColor(.orange)
                        .cornerRadius(4)
                }
                
                // Timer Display
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("7:00")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .monospacedDigit()
//                            .foregroundColor(.red)
                        
                        Text("30% complete")
                            .font(.caption)
//                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
                
                // Prominent Linear Progress Bar  
                ProgressView(value: 0.3)
                    .progressViewStyle(LinearProgressViewStyle())
                    .tint(.red)
                    .scaleEffect(x: 1, y: 3, anchor: .center)
                    .frame(maxWidth: .infinity)
            }
            .padding()
            .background(Color.red.opacity(0.1))
            .previewDisplayName("Lock Screen - Paused")
            .previewLayout(.fixed(width: 350, height: 200))
        }
    }
}

// Preview for Dynamic Island compact view - Running
struct DynamicIslandCompactRunning_Preview: View {
    var body: some View {
        HStack {
            // Compact leading with tiny progress ring (30% complete)
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.3), lineWidth: 2)
                    .frame(width: 10, height: 10)
                Circle()
                    .trim(from: 0, to: 0.3)
                    .stroke(Color.white, lineWidth: 2)
                    .rotationEffect(.degrees(-90))
                    .frame(width: 10, height: 10)
            }
            
            Spacer()
            
            // Compact trailing - Running timer
            Text("7:30")
                .font(.system(size: 12, weight: .medium, design: .monospaced))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 12)
        .frame(width: 120, height: 37)
        .background(Color.black)
        .cornerRadius(20)
    }
}

// Preview for Dynamic Island compact view - Paused
struct DynamicIslandCompactPaused_Preview: View {
    var body: some View {
        HStack {
            // Compact leading with tiny progress ring (60% complete)
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.3), lineWidth: 2)
                    .frame(width: 10, height: 10)
                Circle()
                    .trim(from: 0, to: 0.6)
                    .stroke(Color.orange, lineWidth: 2)
                    .rotationEffect(.degrees(-90))
                    .frame(width: 10, height: 10)
            }
            
            Spacer()
            
            // Compact trailing - Paused timer
            Text("3:45")
                .font(.system(size: 12, weight: .medium, design: .monospaced))
                .foregroundColor(.orange)
        }
        .padding(.horizontal, 12)
        .frame(width: 120, height: 37)
        .background(Color.black)
        .cornerRadius(20)
    }
}

// Preview for Dynamic Island expanded view - Minimal Center Only
struct DynamicIslandExpandedView_Preview: View {
    @State private var isPaused = false
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Expanded View - Minimal")
                .font(.caption2)
                .foregroundColor(.gray)
            
            // Simulating the minimal expanded Dynamic Island
            VStack {
                // Center region only - matching your implementation
                Text(isPaused ? "3:45" : "7:30")
                    .font(.system(size: 16, weight: .semibold, design: .monospaced))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
            }
            .frame(width: 200, height: 60)
            .background(Color.black)
            .cornerRadius(30)
            
            Button("Toggle Pause") {
                isPaused.toggle()
            }
            .buttonStyle(.bordered)
            .tint(.orange)
            .controlSize(.small)
        }
    }
}

// Preview for Dynamic Island minimal view (single dot)
struct DynamicIslandMinimalView_Preview: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("Minimal View")
                .font(.caption2)
                .foregroundColor(.gray)
            
            // Minimal - single progress dot
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    .frame(width: 4, height: 4)
                Circle()
                    .trim(from: 0, to: 0.45) // 45% progress
                    .stroke(Color.white, lineWidth: 1)
                    .rotationEffect(.degrees(-90))
                    .frame(width: 4, height: 4)
            }
            .frame(width: 30, height: 30)
            .background(Color.black)
            .cornerRadius(15)
        }
    }
}

struct DynamicIslandPreviews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 30) {
                Text("Dynamic Island States")
                    .font(.title2.bold())
                    .padding(.top)
                
                // Compact Views
                VStack(spacing: 15) {
                    Text("Compact Views")
                        .font(.headline)
                    
                    DynamicIslandCompactRunning_Preview()
                        .previewDisplayName("Running")
                    
                    DynamicIslandCompactPaused_Preview()
                        .previewDisplayName("Paused")
                }
                
                // Expanded View
                VStack(spacing: 15) {
                    Text("Expanded View (Center Only)")
                        .font(.headline)
                    
                    DynamicIslandExpandedView_Preview()
                }
                
                // Minimal View
                VStack(spacing: 15) {
                    Text("Minimal View")
                        .font(.headline)
                    
                    DynamicIslandMinimalView_Preview()
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.15))
        .previewLayout(.sizeThatFits)
        .previewDisplayName("All Dynamic Island States")
    }
}
#endif
