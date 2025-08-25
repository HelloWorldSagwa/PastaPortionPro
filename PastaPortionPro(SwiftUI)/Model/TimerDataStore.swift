//
//  TimerDataStore.swift
//  PastaPortionPro
//
//  Created for Widget Timer Support
//

import Foundation
#if canImport(WidgetKit)
import WidgetKit
#endif

class TimerDataStore {
    static let shared = TimerDataStore()
    
    private let userDefaults = UserDefaults(suiteName: "group.com.studio5.pastaportionpro")
    
    private let startTimeKey = "timerStartTime"
    private let durationKey = "timerDuration"
    private let isRunningKey = "timerIsRunning"
    private let pausedTimeKey = "timerPausedTime"
    
    private init() {}
    
    // MARK: - Timer State Management
    
    func startTimer(duration: TimeInterval) {
        userDefaults?.set(Date(), forKey: startTimeKey)
        userDefaults?.set(duration, forKey: durationKey)
        userDefaults?.set(true, forKey: isRunningKey)
        userDefaults?.removeObject(forKey: pausedTimeKey)
        
        // Reload widget timeline
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func pauseTimer() {
        guard let startTime = userDefaults?.object(forKey: startTimeKey) as? Date,
              let duration = userDefaults?.object(forKey: durationKey) as? TimeInterval else {
            return
        }
        
        let elapsed = Date().timeIntervalSince(startTime)
        let remaining = duration - elapsed
        
        userDefaults?.set(remaining, forKey: pausedTimeKey)
        userDefaults?.set(false, forKey: isRunningKey)
        
        // Reload widget timeline
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func resumeTimer() {
        guard let pausedTime = userDefaults?.object(forKey: pausedTimeKey) as? TimeInterval else {
            return
        }
        
        userDefaults?.set(Date(), forKey: startTimeKey)
        userDefaults?.set(pausedTime, forKey: durationKey)
        userDefaults?.set(true, forKey: isRunningKey)
        userDefaults?.removeObject(forKey: pausedTimeKey)
        
        // Reload widget timeline
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func stopTimer() {
        userDefaults?.removeObject(forKey: startTimeKey)
        userDefaults?.removeObject(forKey: durationKey)
        userDefaults?.set(false, forKey: isRunningKey)
        userDefaults?.removeObject(forKey: pausedTimeKey)
        
        // Reload widget timeline
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    // MARK: - Timer State Retrieval
    
    func getRemainingTime() -> TimeInterval? {
        guard let isRunning = userDefaults?.bool(forKey: isRunningKey), isRunning,
              let startTime = userDefaults?.object(forKey: startTimeKey) as? Date,
              let duration = userDefaults?.object(forKey: durationKey) as? TimeInterval else {
            
            // Check if timer is paused
            if let pausedTime = userDefaults?.object(forKey: pausedTimeKey) as? TimeInterval {
                return pausedTime
            }
            
            return nil
        }
        
        let elapsed = Date().timeIntervalSince(startTime)
        let remaining = duration - elapsed
        
        return remaining > 0 ? remaining : 0
    }
    
    func isTimerRunning() -> Bool {
        return userDefaults?.bool(forKey: isRunningKey) ?? false
    }
    
    func getEndTime() -> Date? {
        guard let isRunning = userDefaults?.bool(forKey: isRunningKey), isRunning,
              let startTime = userDefaults?.object(forKey: startTimeKey) as? Date,
              let duration = userDefaults?.object(forKey: durationKey) as? TimeInterval else {
            return nil
        }
        
        return startTime.addingTimeInterval(duration)
    }
}