//
//  PastaTimerWidget.swift
//  PastaTimerWidget
//
//  Widget Extension for PastaPortionPro
//

import WidgetKit
import SwiftUI

// MARK: - Timeline Entry

struct TimerEntry: TimelineEntry {
    let date: Date
    let remainingTime: TimeInterval?
    let isRunning: Bool
    let endTime: Date?
}

// MARK: - Timeline Provider

struct TimerProvider: TimelineProvider {
    let dataStore = TimerDataStore.shared
    
    func placeholder(in context: Context) -> TimerEntry {
        TimerEntry(date: Date(), remainingTime: 480, isRunning: false, endTime: nil)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (TimerEntry) -> Void) {
        let entry = TimerEntry(
            date: Date(),
            remainingTime: dataStore.getRemainingTime(),
            isRunning: dataStore.isTimerRunning(),
            endTime: dataStore.getEndTime()
        )
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<TimerEntry>) -> Void) {
        var entries: [TimerEntry] = []
        let currentDate = Date()
        
        // Create timeline entries for the next hour, updating every second if timer is running
        if dataStore.isTimerRunning() {
            for secondOffset in 0..<60 {
                let entryDate = currentDate.addingTimeInterval(Double(secondOffset))
                let entry = TimerEntry(
                    date: entryDate,
                    remainingTime: dataStore.getRemainingTime(),
                    isRunning: true,
                    endTime: dataStore.getEndTime()
                )
                entries.append(entry)
            }
        } else {
            // If timer is not running, just show current state
            let entry = TimerEntry(
                date: currentDate,
                remainingTime: dataStore.getRemainingTime(),
                isRunning: false,
                endTime: nil
            )
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

// MARK: - Widget View

struct PastaTimerWidgetView: View {
    var entry: TimerEntry
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color("mainRed").opacity(0.1), Color.white]),
                startPoint: .top,
                endPoint: .bottom
            )
            
            VStack(spacing: 8) {
                // App Logo/Title
                HStack {
                    Image(systemName: "timer.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(Color("mainRed"))
                    Text("Pasta Timer")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                // Timer Display
                if let endTime = entry.endTime, entry.isRunning {
                    // Show countdown timer
                    Text(endTime, style: .timer)
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(Color("mainRed"))
                        .multilineTextAlignment(.center)
                } else if let remainingTime = entry.remainingTime, !entry.isRunning {
                    // Show paused time
                    Text(formatTime(remainingTime))
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    Text("PAUSED")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.gray)
                } else {
                    // No timer active
                    Image(systemName: "timer")
                        .font(.system(size: 40))
                        .foregroundColor(.gray.opacity(0.5))
                    Text("No Timer")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Status indicator
                if entry.isRunning {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 6, height: 6)
                        Text("Cooking")
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
        }
    }
    
    func formatTime(_ seconds: TimeInterval) -> String {
        let minutes = Int(seconds) / 60
        let remainingSeconds = Int(seconds) % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}

// MARK: - Widget Configuration

@main
struct PastaTimerWidget: Widget {
    let kind: String = "PastaTimerWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TimerProvider()) { entry in
            PastaTimerWidgetView(entry: entry)
        }
        .configurationDisplayName("Pasta Timer")
        .description("Track your pasta cooking time")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - Preview

struct PastaTimerWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PastaTimerWidgetView(entry: TimerEntry(
                date: Date(),
                remainingTime: 480,
                isRunning: true,
                endTime: Date().addingTimeInterval(480)
            ))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            PastaTimerWidgetView(entry: TimerEntry(
                date: Date(),
                remainingTime: 240,
                isRunning: false,
                endTime: nil
            ))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        }
    }
}