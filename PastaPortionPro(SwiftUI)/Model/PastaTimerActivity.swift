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
    let doneness: String  // "Al Dente", "Cottura", "Ben Cotto", "Custom"
}

// MARK: - Live Activity Widget
struct PastaTimerLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PastaTimerActivityAttributes.self) { context in
            // Lock Screen / Banner UI
            LockScreenLiveActivityView(context: context)
                .activityBackgroundTint(Color.white)  // 흰색 배경
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
                        Text(timerInterval: Date.now...context.state.endTime, countsDown: true)
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
                    // 타임스탬프 기반 진행률 계산
                    Circle()
                        .trim(from: 0, to: context.state.isPaused 
                            ? min(max(CGFloat(context.attributes.totalTime - context.state.remainingTime) / CGFloat(context.attributes.totalTime), 0.0), 1.0)
                            : min(max(CGFloat(context.attributes.totalTime - max(0, Int(context.state.endTime.timeIntervalSinceNow))) / CGFloat(context.attributes.totalTime), 0.0), 1.0))
                        .stroke(Color.white, lineWidth: 2)
                        .rotationEffect(.degrees(-90))
                        .frame(width: 10, height: 10)
                }
                .frame(width: 14, height: 14)  // 원이 잘리지 않도록 여유 공간 추가
                .padding(.leading, 2)  // 왼쪽 패딩 추가
            } compactTrailing: {
                // Compact trailing - Show countdown when running, static when paused
                if context.state.isPaused {
                    Text(formatTime(context.state.remainingTime))
                        .font(.system(size: 12, weight: .medium, design: .monospaced))
                        .foregroundColor(.white)
                        .frame(maxWidth: 50)  // 고정 폭으로 제한
                } else {
                    Text(timerInterval: Date.now...context.state.endTime, countsDown: true)
                        .monospacedDigit()  // 숫자 고정폭
                        .font(.system(size: 12, weight: .medium, design: .monospaced))
                        .foregroundColor(.white)
                        .frame(maxWidth: 50, alignment: .trailing)  // iOS 17 버그 해결: 최대 폭 제한
                        .minimumScaleFactor(0.8)  // 필요시 텍스트 크기 조절
                }
            } minimal: {
                // Minimal - Progress dot
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        .frame(width: 4, height: 4)
                    // 타임스탬프 기반 진행률 계산
                    Circle()
                        .trim(from: 0, to: context.state.isPaused 
                            ? min(max(CGFloat(context.attributes.totalTime - context.state.remainingTime) / CGFloat(context.attributes.totalTime), 0.0), 1.0)
                            : min(max(CGFloat(context.attributes.totalTime - max(0, Int(context.state.endTime.timeIntervalSinceNow))) / CGFloat(context.attributes.totalTime), 0.0), 1.0))
                        .stroke(Color.white, lineWidth: 1)
                        .rotationEffect(.degrees(-90))
                        .frame(width: 4, height: 4)
                }
            }
            .widgetURL(URL(string: "pastaportionpro://timer"))
            .keylineTint(Color.white.opacity(0.3))
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
                    .foregroundColor(.red)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Pasta Portion Pro")
                        .font(.headline)
                        .foregroundColor(.black)  // 검은색으로 변경
                    
                    // Doneness 표시 (익힘 정도)
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .font(.caption2)
                            .foregroundColor(.orange)  // 더 진한 오렌지
                        Text(context.attributes.doneness)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.gray)  // 회색으로 변경
                    }
                }
                
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
                        // Live Activity는 애니메이션 제한적 - 고정 원 사용
                        Circle()
                            .fill(Color.green)
                            .frame(width: 8, height: 8)
                        
                        Text("Cooking")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(Color(red: 0.0, green: 0.5, blue: 0.0))  // 더 진한 녹색
                    }
                }
            }
            
            // Timer Display
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    // Show countdown when running, static when paused
                    VStack(alignment: .leading, spacing: 4) {
                        if context.state.isPaused {
                            Text(formatTime(context.state.remainingTime))
                                .font(.system(size: 42, weight: .bold, design: .rounded))
                                .monospacedDigit()
                                .foregroundColor(.red)
                        } else {
                            Text(timerInterval: Date.now...context.state.endTime, countsDown: true)
                                .font(.system(size: 42, weight: .bold, design: .rounded))
                                .monospacedDigit()
                                .foregroundColor(.red)
                        }
                        
                        // 종료 예정 시간 표시 (일시정지 상태가 아닐 때만)
                        if !context.state.isPaused {
                            HStack(spacing: 4) {
                                Image(systemName: "clock.fill")
                                    .font(.caption)
                                    .foregroundColor(.gray)  // 회색으로 변경
                                Text("Ends at \(context.state.endTime, formatter: timeFormatter)")
                                    .font(.caption)
                                    .foregroundColor(.gray)  // 회색으로 변경
                            }
                        } else {
                            // 일시정지 상태에서는 남은 시간 표시
                            HStack(spacing: 4) {
                                Image(systemName: "pause.circle.fill")
                                    .font(.caption)
                                    .foregroundColor(.orange)
                                Text("\(formatTime(context.state.remainingTime)) remaining")
                                    .font(.caption)
                                    .foregroundColor(.orange)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // 진행률 퍼센티지
                    Group {
                        if context.state.isPaused {
                            Text("\(Double(context.attributes.totalTime - context.state.remainingTime) / Double(context.attributes.totalTime) * 100, specifier: "%.1f")%")
                                .font(.title2.bold())
                                .foregroundColor(.red)
                        } else {
                            Text("\(min(max(Double(context.attributes.totalTime - max(0, Int(context.state.endTime.timeIntervalSinceNow))) / Double(context.attributes.totalTime), 0.0), 1.0) * 100, specifier: "%.1f")%")
                                .font(.title2.bold())
                                .foregroundColor(.red)
                        }
                    }
                }
                
                // Prominent Linear Progress Bar - 현재 진행 상태 반영
                // 타임스탬프 기반 진행률 계산 (1Hz 모드에서도 정확한 업데이트)
                // 프로그레스바만 표시 (퍼센티지 텍스트 제거)
                ProgressView(value: context.state.isPaused 
                    ? min(max(Double(context.attributes.totalTime - context.state.remainingTime) / Double(context.attributes.totalTime), 0.0), 1.0)
                    : min(max(Double(context.attributes.totalTime - max(0, Int(context.state.endTime.timeIntervalSinceNow))) / Double(context.attributes.totalTime), 0.0), 1.0))
                    .progressViewStyle(LinearProgressViewStyle())
                    .tint(.red)
                    .scaleEffect(x: 1, y: 3, anchor: .center)
                    .frame(maxWidth: .infinity)
            }
            
            
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

// 시간 포맷터 - 종료 시간 표시용
private let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .short  // 예: 3:45 PM
    formatter.dateStyle = .none
    return formatter
}()

// MARK: - SwiftUI Previews
#if DEBUG
import SwiftUI

/// Dynamic Island 및 Lock Screen Live Activity 프리뷰
/// Xcode Canvas에서 다양한 상태의 다이나믹 아일랜드 UI를 미리보기
struct PastaTimerLiveActivity_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // MARK: Compact View - 타이머 실행 중 (30% 진행)
            // 다이나믹 아일랜드 컴팩트 모드: 좌측 원형 프로그레스 + 우측 시간
            HStack {
                // 좌측: 작은 원형 프로그레스 바 (30% 진행 상태)
                ZStack {
                    // 배경 원
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                        .frame(width: 10, height: 10)
                    // 진행률 표시 (30%)
                    Circle()
                        .trim(from: 0, to: 0.3)  // 30% 진행
                        .stroke(Color.white, lineWidth: 2)
                        .rotationEffect(.degrees(-90))  // 12시 방향부터 시작
                        .frame(width: 10, height: 10)
                }
                
                Spacer()
                
                // 우측: 남은 시간 표시 (실행 중)
                Text("7:30")
                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 12)
            .frame(width: 120, height: 37)  // 컴팩트 사이즈
            .background(Color.black)
            .cornerRadius(20)
            .previewDisplayName("Compact - Running (30%)")
            
            // MARK: Compact View - 일시정지 상태 (60% 진행)
            // 다이나믹 아일랜드 컴팩트 모드: 일시정지된 상태
            HStack {
                // 좌측: 작은 원형 프로그레스 바 (60% 진행 상태)
                ZStack {
                    // 배경 원
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                        .frame(width: 10, height: 10)
                    // 진행률 표시 (60%)
                    Circle()
                        .trim(from: 0, to: 0.6)  // 60% 진행
                        .stroke(Color.white, lineWidth: 2)
                        .rotationEffect(.degrees(-90))
                        .frame(width: 10, height: 10)
                }
                
                Spacer()
                
                // 우측: 남은 시간 표시 (일시정지됨)
                Text("3:45")
                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 12)
            .frame(width: 120, height: 37)
            .background(Color.black)
            .cornerRadius(20)
            .previewDisplayName("Compact - Paused (60%)")
            
            // MARK: Expanded View - 최소 디자인 (중앙 영역만)
            // 확장된 다이나믹 아일랜드: 중앙에 시간만 표시
            VStack {
                Text("5:00")
                    .font(.system(size: 16, weight: .semibold, design: .monospaced))
                    .foregroundColor(.white)
            }
            .frame(width: 200, height: 60)  // 확장 사이즈
            .background(Color.black)
            .cornerRadius(30)
            .previewDisplayName("Expanded - Center Only")
            
            // MARK: Minimal View - 작은 점 표시 (45% 진행)
            // 최소화 모드: 작은 점으로만 진행률 표시
            ZStack {
                // 배경 점
                Circle()
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    .frame(width: 4, height: 4)
                // 진행률 표시 (45%)
                Circle()
                    .trim(from: 0, to: 0.45)  // 45% 진행
                    .stroke(Color.white, lineWidth: 1)
                    .rotationEffect(.degrees(-90))
                    .frame(width: 4, height: 4)
            }
            .frame(width: 30, height: 30)  // 미니멀 사이즈
            .background(Color.black)
            .cornerRadius(15)
            .previewDisplayName("Minimal (45%)")
        }
        .previewLayout(.sizeThatFits)
        .padding()
        .background(Color.gray.opacity(0.2))
    }
}
#endif

// MARK: - Live Activity Manager
class PastaTimerActivityManager {
    static let shared = PastaTimerActivityManager()
    private var currentActivity: Activity<PastaTimerActivityAttributes>?
    private var initialEndTime: Date?  // 초기 종료 시간 저장
    
    private init() {}
    
    func startActivity(pastaName: String, totalSeconds: Int, doneness: String = "Custom") {
        print("\n========== START ACTIVITY ==========")
        print("📥 INPUT:")
        print("   - pastaName: \(pastaName)")
        print("   - totalSeconds: \(totalSeconds)")
        print("   - doneness: \(doneness)")
        print("   - Time: \(Date())")
        
        // Check if activities are enabled
        let authInfo = ActivityAuthorizationInfo()
        print("\n🔐 AUTHORIZATION:")
        print("   - areActivitiesEnabled: \(authInfo.areActivitiesEnabled)")
        print("   - frequentPushesEnabled: \(authInfo.frequentPushesEnabled)")
        
        guard authInfo.areActivitiesEnabled else {
            print("❌ Live Activities are not enabled in Settings")
            print("   Please enable: Settings → PastaPortionPro → Live Activities")
            return
        }
        
        // Stop existing activity if any
        stopActivity()
        
        let attributes = PastaTimerActivityAttributes(
            pastaName: pastaName,
            totalTime: totalSeconds,
            doneness: doneness
        )
        
        let endTime = Date().addingTimeInterval(TimeInterval(totalSeconds))
        self.initialEndTime = endTime  // 초기 종료 시간 저장
        
        let initialState = PastaTimerActivityAttributes.ContentState(
            endTime: endTime,
            isPaused: false,
            remainingTime: totalSeconds
        )
        
        do {
            let activityContent = ActivityContent(
                state: initialState,
                staleDate: endTime,
                relevanceScore: 100  // High priority
            )
            
            let activity = try Activity.request(
                attributes: attributes,
                content: activityContent,
                pushType: nil
            )
            self.currentActivity = activity
            
            print("\n📤 OUTPUT:")
            print("   - Activity ID: \(activity.id)")
            print("   - Pasta: \(pastaName)")
            print("   - Total Duration: \(totalSeconds)s")
            print("   - Initial Progress: 0%")
            print("   - End Time: \(endTime)")
            print("   - Activity State: \(activity.activityState)")
            print("   - Initial remainingTime: \(initialState.remainingTime)")
            print("✅ RESULT: Live Activity started successfully")
            
            // Check all active activities
            Task {
                let activities = Activity<PastaTimerActivityAttributes>.activities
                print("📍 Total Active Activities: \(activities.count)")
                for activity in activities {
                    print("   - Activity ID: \(activity.id)")
                    print("   - State: \(activity.activityState)")
                    print("   - Content State: \(activity.content.state)")
                }
            }
        } catch {
            print("❌ Failed to start Live Activity: \(error)")
            print("   Error details: \(error.localizedDescription)")
        }
    }
    
    func updateActivity(remainingSeconds: Int, isPaused: Bool = false) {
        print("\n========== UPDATE ACTIVITY ==========")
        print("📥 INPUT:")
        print("   - remainingSeconds: \(remainingSeconds)")
        print("   - isPaused: \(isPaused)")
        print("   - Time: \(Date())")
        
        guard let activity = currentActivity else { 
            print("❌ ERROR: No active Live Activity to update")
            print("======================================\n")
            return 
        }
        
        // 이전 상태와 비교해서 실제로 변경되었는지 확인
        let previousRemainingTime = activity.content.state.remainingTime
        let previousIsPaused = activity.content.state.isPaused
        
        print("📊 COMPARISON:")
        print("   - Previous remainingTime: \(previousRemainingTime)")
        print("   - New remainingTime: \(remainingSeconds)")
        print("   - Previous isPaused: \(previousIsPaused)")
        print("   - New isPaused: \(isPaused)")
        
        // 중요: remainingTime 업데이트는 5초마다만 필요 (프로그레스바는 타임스탬프로 자동 업데이트)
        // 단, pause 상태 변경은 즉시 반영
        if !isPaused && previousIsPaused == isPaused && abs(previousRemainingTime - remainingSeconds) < 5 {
            print("⏭️ RESULT: Skipping update - minor time change, timestamp handles progress")
            print("======================================\n")
            return
        }
        
        // endTime 계산: 타임스탬프 기반 접근
        let endTime: Date
        if isPaused {
            // 일시정지: 현재 시간 + 남은 시간
            endTime = Date().addingTimeInterval(TimeInterval(remainingSeconds))
        } else {
            // 실행 중: 현재 시간 + 남은 시간으로 재계산 (1Hz 복귀 시 정확한 시간)
            endTime = Date().addingTimeInterval(TimeInterval(remainingSeconds))
        }
        
        let updatedState = PastaTimerActivityAttributes.ContentState(
            endTime: endTime,
            isPaused: isPaused,
            remainingTime: remainingSeconds  // 프로그레스바용 실제 남은 시간
        )
        
        let updatedContent = ActivityContent(
            state: updatedState,
            staleDate: isPaused ? nil : endTime.addingTimeInterval(60),  // 1분 여유 추가
            relevanceScore: Double(100 - remainingSeconds/10)  // 시간이 적을수록 중요도 높임
        )
        
        Task { @MainActor in
            await activity.update(updatedContent)
            
            // 항상 로그 출력 (디버깅용)
            let totalTime = activity.attributes.totalTime
            let progress = Double(totalTime - remainingSeconds) / Double(totalTime) * 100
            
            print("📤 OUTPUT:")
            print("   - Total Time: \(totalTime)s")
            print("   - Remaining: \(remainingSeconds)s")
            print("   - Progress: \(String(format: "%.1f", progress))%")
            print("   - isPaused: \(isPaused)")
            print("   - endTime: \(endTime)")
            print("   - relevanceScore: \(Double(100 - remainingSeconds/10))")
            print("   - Activity ID: \(activity.id)")
            print("   - Activity State: \(activity.activityState)")
            print("✅ RESULT: Update sent successfully")
            print("======================================\n")
        }
    }
    
    func pauseActivity() {
        guard let activity = currentActivity else { 
            print("⚠️ No active Live Activity to pause")
            return 
        }
        
        Task {
            let state = activity.content.state
            // Calculate remaining time from endTime if not already paused
            let remaining = state.isPaused ? state.remainingTime : max(0, Int(state.endTime.timeIntervalSinceNow))
            let pausedState = PastaTimerActivityAttributes.ContentState(
                endTime: Date(),  // Set to current date when paused
                isPaused: true,
                remainingTime: remaining
            )
            let updatedContent = ActivityContent(
                state: pausedState,
                staleDate: nil  // No stale date when paused
            )
            await activity.update(updatedContent)
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
            guard state.isPaused else {
                print("⚠️ Activity is not paused")
                return
            }
            let newEndTime = Date().addingTimeInterval(TimeInterval(state.remainingTime))
            let resumedState = PastaTimerActivityAttributes.ContentState(
                endTime: newEndTime,
                isPaused: false,
                remainingTime: state.remainingTime
            )
            let updatedContent = ActivityContent(
                state: resumedState,
                staleDate: newEndTime
            )
            await activity.update(updatedContent)
            print("▶️ Resumed Live Activity with new end time: \(newEndTime)")
        }
    }
    
    func stopActivity() {
        print("🔴 stopActivity() called")
        
        guard let activity = currentActivity else { 
            print("⚠️ No active Live Activity to stop")
            return 
        }
        
        print("🔴 Found activity to stop: \(activity.id)")
        
        Task { @MainActor in
            // First, end the activity with immediate dismissal
            let finalState = PastaTimerActivityAttributes.ContentState(
                endTime: Date(),
                isPaused: false,
                remainingTime: 0
            )
            
            let finalContent = ActivityContent(
                state: finalState,
                staleDate: Date()
            )
            
            await activity.end(finalContent, dismissalPolicy: .immediate)
            print("🛑 Activity.end() called for: \(activity.id)")
            
            // Clear the reference
            self.currentActivity = nil
            self.initialEndTime = nil  // 초기 종료 시간도 리셋
            print("🛑 currentActivity and initialEndTime set to nil")
            
            // Also try to end ALL activities just in case
            for otherActivity in Activity<PastaTimerActivityAttributes>.activities {
                if otherActivity.id != activity.id {
                    print("🧹 Cleaning up additional activity: \(otherActivity.id)")
                    await otherActivity.end(nil, dismissalPolicy: .immediate)
                }
            }
            
            print("✅ All Live Activities should be stopped now")
        }
    }
}
