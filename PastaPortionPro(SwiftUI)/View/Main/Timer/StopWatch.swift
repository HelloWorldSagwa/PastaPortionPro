//
//  StopWatch.swift
//  PastaPortionPro(SwiftUI)
//
//  Created by SungHyun Kim on 5/3/24.
//

import SwiftUI
import RealmSwift
import UserNotifications
import AVFoundation
import WidgetKit
import ActivityKit
import StoreKit



// 1. WatchScreen과 WatchCircle의 minutes를 seconds로 전환 - 처리
// 2. seconds가 0이 되었을 때 알림 표시 및 알림 : 한번만 울리게 변경 - 처리
// 3. 2min alert연동 필수임. - 소리만 처리, notificaionts 미처리
// 4. Custom화면 연동 - Realm, Settings - 처리
// 5. Start 화면 연동 - 처리
// 6. ratings화면 데이터 연결 - 처리
// 7. 타이머 가동 되면 타이머를 제외한 모든 화면 이용불가하게 만들것 - 처리
// 8. 슬라이드할 때 미세한 차이 발견 - 자연스럽고 스무스하게 처리
// 9. 프로그램이 background상태로 들어갔을 때 liveWidget 활성화 필요하나 이를 제외한 모든 기능 활성화 시킴. - livewidget제외 처리
// 10. 히스토리나 홈탭을 타고와서 포션을 누르고, 시간을 변경할 경우 -> 새로운 히스토리로 교체
// 11. 포션하고 다른화면 갔다오면 0분으로 표시되는 버그 발생 




struct StopWatch: View {
    
    @Binding var selectedTab : String
    @State var seconds : Float = 480
    @State var sliderSeconds : Float = 480
    @State var minMinutes : Float = 3
    @State var maxMinutes : Float = 20
    
    
    
    var body: some View {
        
        VStack{
            TopStack()
            Divider()
            
            
            WatchScreen(seconds: $seconds, minMinutes: $minMinutes, maxMinutes: $maxMinutes, sliderSeconds: $sliderSeconds, selectedTab: $selectedTab)
            
                .onChange(of: sliderSeconds, perform: { value in
                    seconds = value
                })
                
            
        }
        
    }
}

#Preview {
    StopWatch(selectedTab: .constant("Timer"))
}


struct WatchCircle: View {
    @Binding var seconds : Float
    @Binding var maxMinutes : Float
    
    // 아이폰 크기에 따른 원 크기 조정
    var globalSizeWidthCircle : CGFloat {
        return UIScreen.main.bounds.width * 0.7
    }
    var globlaSizeheight : CGFloat {
        return UIScreen.main.bounds.height * 0.9
    }
    var circleLineWidth : CGFloat = 30
    
    private var maxSeconds : Float{
        get{
            return maxMinutes * 60
        }
    }

    var body: some View {
        ZStack{

            
            Circle()
                .stroke(lineWidth: circleLineWidth)
                .shadow(radius: 3)
                .foregroundColor(.white)
//                .frame(width: globalSizeWidthCircle)
                .zIndex(0.0)
            
            Circle()
                .stroke(lineWidth: circleLineWidth - 10)
                .foregroundColor(.mainGray)
//                .frame(width: globalSizeWidthCircle)
                .zIndex(1.0)
            
            Circle()
                .trim(
                    
                    from: 0,
                    
                    to: CGFloat(seconds / maxSeconds)
  

                )
                .stroke(lineWidth: circleLineWidth - 10)
                .foregroundColor(.mainRed)
               
                .rotationEffect(.degrees(-90))
                .zIndex(2.0)
                .shadow(radius: 1)
            
           
        }
        .padding(-5)
        .frame(width: globalSizeWidthCircle)
        
    }
}

struct WatchSlider: View {
    
    
    @Binding var sliderSeconds : Float
    @Binding var minMinutes : Float
    var minSeconds : Float{
        get{
            minMinutes * 60
        }
    }
    
    @Binding var maxMinutes : Float
    var maxSeconds : Float{
        get{
            maxMinutes * 60
        }
    }
    

        
    var body: some View {
       
        HStack{
            Doneness()
            Slider(value: $sliderSeconds, in: minSeconds...maxSeconds, step: 30)
                .tint(.mainRed)
                
                
                
        }

           
    }
}



struct WatchScreen: View {
    @Binding var seconds : Float
    @Binding var minMinutes : Float
    @Binding var maxMinutes : Float
    @Binding var selectedTab : String
    
    
    @State private var adjustSeconds : Float = 30
    @StateObject private var reviewManager = ReviewRequestManager.shared
    @State private var showReviewRequest = false
    
    var maxSeconds : Float{
        get{
            maxMinutes * 60
        }
    }
    
    @State var secondsForReset : Float = 0
    @State var timer : Timer? = nil
    
    // DB저장관련
    @ObservedResults(UserHistory.self) var userHistory
    
    // 백그라운드 관련
    
    @Environment(\.scenePhase) var scenePhase // 백그라운드 전환
    let manager = NotificationManager.instance
    
    // 툴팁박스
    @State var is2minutesButtonTapped : Bool = false
    @State var isToolTipButtonTapped : Bool = false
    
    // 커스텀 버튼
    @State private var isCustomButtonTapped : Bool = false
    
    // 슬라이더 영역
    @Binding var sliderSeconds : Float
    
    // 스타트 버튼 영역
    @State private var isStartButtonTapped = false
    @State private var isPuaseButtonTapped = false
    @State private var backgroundTaskID: UIBackgroundTaskIdentifier = .invalid
    
    
    // 파스타 종류
    @State var selectedDoneness = "Chewy"
    var doneness = ["Chewy" : "Al Dente", "Tender" : "Cottura", "Soft" : "Ben Cotto"]
    var donenessKey = ["Custom", "Chewy", "Tender", "Soft"]
    
    // 2분 전 알림
    @State private var twoMinutesPreAlarm : Bool = false
    
    
    // 파스타 종료
    @State private var isTimerCompleted = false
    
    // 경고
    @State private var portionWarning = false
    
    
    // 초기화
    init(seconds: Binding<Float>, minMinutes: Binding<Float>, maxMinutes: Binding<Float>, sliderSeconds: Binding<Float>, selectedTab: Binding<String>){
        
        self._seconds = seconds
        self._minMinutes = minMinutes
        self._maxMinutes = maxMinutes
        self._sliderSeconds = sliderSeconds
        self._selectedTab = selectedTab
        
        resetSegmentedControlStyle()
    }

    
    var body: some View {
  
        VStack{
            
            
            ZStack{
                
                if oldPhoneSupport(){
                    WatchCircle(seconds: $seconds, maxMinutes: $maxMinutes)
                }

                VStack(spacing: 0){
                    
    
                    if selectedDoneness == "Custom"{
                        
                        Button(action: {
                            
                            isCustomButtonTapped = true
                            
                        }, label: {
                            
                            VStack(spacing : 5){
                                
                                HStack{
                                    Text("Custom")
                                        
                                        .bold()
                                        .font(.system(size: 25))
                                        .foregroundColor(.gray)
                                    
                                    Circle()
                                        .overlay{
                                            Text("Tap")
                                                .bold()
                                                .foregroundColor(.mainRed)
                                                .font(.system(size: 13))
                                               
                                        }
                                        .frame(width: 30)
                                        .foregroundColor(.white)
                                        .shadow(radius: 1)
             
                                }
                                
                                Divider()
                                
                            }
                            .frame(width: 150)
                            
                        })

                        .sheet(isPresented: $isCustomButtonTapped) {
                            StopWatchCustom(seconds: $seconds)
                                .presentationDetents([.medium, .large])
                        }
                        
                    }else{
                        VStack(spacing : 5){
                            
                            Text(doneness[selectedDoneness] ?? "Al Dente")
                                
                                .bold()
                                .font(.system(size: 25))
                                .foregroundColor(.gray)
                            Divider()
                            
                        }
                        .frame(width: 150)
                        
                    }
                    
                    // 시계표시
                    Text(timeFormatted(Double(seconds))) // 시간을 나타내는 데이터타입은 Double이다.
                        .font(.system(size: 90))
                        .bold()
                    
                    // 타이머 처음 표시
                        .onAppear(perform: {
                            // 리뷰 요청 체크 (1.3 이전 사용자)
                            reviewManager.checkAndRequestReview()
                            
                            if Settings.historyID != "" || Settings.newHistoryID != ""{
                                if seconds == 0 {
                                    seconds = 480
                                }else{
 
                                    if Settings.userMinutes == 0 {
                                        seconds = 480
                                    } else{
                            
                                        seconds = Settings.userMinutes * 60
                                    }

                                }
                                
                            }else{
                                print("걸림3")
                                seconds = 480
                            }
                            
                            
                            isTimerCompleted = false // 파스타 완성 끄기
                            
                            
                        })
                    
                    // 익은정도(DONENESS) 구분
                        .onChange(of: sliderSeconds, perform: { value in
                            
                            if value <= 600{
                                
                                selectedDoneness = "Chewy"
                                
                            }else if value <= 900{
                                
                                selectedDoneness = "Tender"
                                
                            }else if value > 900{
                                
                                selectedDoneness = "Soft"
                                
                            }
                            
                        })
                    
                    // 소리 재생부분
                        .onChange(of: seconds, perform: { value in
                            
                            if value == 120 && is2minutesButtonTapped == true{
                                twoMinutesPreAlarm = true
                                AudioServicesPlaySystemSound(1321) //분 알림
                                
                            }else if value == 0 && isStartButtonTapped == true{
                                //초기 데이터 짤 대 갑자기 팝업이 뜸.. -> 해결
                            
                                isStartButtonTapped = false
                                seconds = 480
                                isTimerCompleted = true
                                timer?.invalidate()
                                AudioServicesPlaySystemSound(1327)
                                
                                Settings.deactivateAllViews = false
                            }
                        })
                    
                    // 백그라운드 처리
                        .onChange(of: scenePhase){ newValue in
                            print("\n🔄 Scene Phase Changed to: \(newValue)")
                            
                            if isStartButtonTapped {
                                if newValue == .background {
                                    // 백그라운드로 갈 때 - 현재 시간 저장 (inactive는 무시)
                                    Settings.backgroundTime = Date()
                                    print("📱 App going to background")
                                    print("   - Timer is: \(isPuaseButtonTapped ? "PAUSED" : "RUNNING")")
                                    print("   - Current seconds: \(seconds)")
                                    print("   - Background time saved: \(Settings.backgroundTime)")
                                    print("   - Timer object: \(timer != nil ? "EXISTS" : "NIL")")
                                } else if newValue == .active {
                                    // 앱이 활성화 상태일때
                                    print("📱 App became active")
                                    
                                    // backgroundTime이 유효한지 확인 (1시간 이내)
                                    let timeSinceBackground = Date().timeIntervalSince(Settings.backgroundTime)
                                    print("   - Time since background: \(String(format: "%.1f", timeSinceBackground))s")
                                    print("   - Timer is: \(isPuaseButtonTapped ? "PAUSED" : "RUNNING")")
                                    print("   - Timer object: \(timer != nil ? "EXISTS" : "NIL")")
                                    
                                    if timeSinceBackground > 3600 {
                                        // 1시간 이상 경과했다면 무시 (이전 세션의 값일 가능성)
                                        print("   ⚠️ Background time too old, ignoring")
                                    } else if !isPuaseButtonTapped && timeSinceBackground > 1 {
                                        // 일시정지 상태가 아니고 1초 이상 차이가 있을 때만 계산
                                        let elapsedTime = Float(round(timeSinceBackground))
                                        print("   ⏰ Adjusting for background time: \(elapsedTime)s")
                                        
                                        // 타이머를 일시적으로 중지하고 시간 조정
                                        timer?.invalidate()
                                        
                                        if seconds <= elapsedTime {
                                            seconds = 0
                                            print("   → Timer reached 0")
                                        } else {
                                            seconds -= elapsedTime
                                            print("   → New seconds: \(seconds)")
                                            
                                            // 타이머 재시작
                                            print("   → Restarting timer...")
                                            timerStart(isResuming: true)
                                        }
                                    } else if isPuaseButtonTapped {
                                        print("   ⏸️ Timer is paused, no adjustment needed")
                                    } else {
                                        print("   ✅ No significant time elapsed, continuing normally")
                                    }
                                    
                                    // Dynamic Island와 동기화
                                    #if canImport(ActivityKit)
                                    if #available(iOS 16.1, *) {
                                        print("   → Syncing Live Activity: \(Int(seconds))s, isPaused: \(isPuaseButtonTapped)")
                                        PastaTimerActivityManager.shared.updateActivity(remainingSeconds: Int(seconds), isPaused: isPuaseButtonTapped)
                                    }
                                    #endif
                                } else if newValue == .inactive {
                                    print("📱 App became inactive (transitioning)")
                                }
                            } else {
                                print("   Timer not started, ignoring scene change")
                            }
                           
                            
                        }
                    
                        .sheet(isPresented: $twoMinutesPreAlarm) {
                            StopWatchTwoMinutesAlert()
                                .presentationDetents([.medium, .large])
                        }
                        .sheet(isPresented: $isTimerCompleted) {
                            PastaCompleted()
                                .presentationDetents([.large, .large])
                        }
                    
                    Divider()
                        .frame(width: 150)


                } // VStack
            } // ZStack
            .padding(.vertical, 30)
            
            // 상단 스톱워치 원
            
            Spacer()
            Picker("Choose doneness", selection: $selectedDoneness) {
                ForEach(donenessKey, id: \.self) { value in
//                    Text(value)
                    Text(NSLocalizedString(value, comment: ""))
                }
            }
            .onChange(of: selectedDoneness, perform: { value in
                
                if value == "Chewy"{
                    sliderSeconds = 480
                }else if value == "Tender"{
                    sliderSeconds = 720
                }else if value == "Soft"{
                    sliderSeconds = 900.1 // Tender와 간극조절
                }else if value == "Custom"{
                    
                    let calculate = Calculate()
                    seconds = (calculate.userProfileById.first?.customMinutes ?? 8) * 60
                    
                    
                }
            })
            .pickerStyle(.segmented)
            .disabled(isStartButtonTapped)
            // 피커
            
            Spacer()
            VStack(spacing: 20){
               
                Divider()
                WatchSlider(sliderSeconds: $sliderSeconds, minMinutes: $minMinutes, maxMinutes: $maxMinutes)
                Divider()
                TwoMinutesAlert(is2minutesButtonTapped: $is2minutesButtonTapped)
                Divider()
              
                
                
            }
            .padding(.vertical)
            .disabled(isStartButtonTapped)
            Spacer()

            //            AdView(height: 60)
            
            
            
            
            if isStartButtonTapped{
                
               
                
                HStack(spacing: 0){
                
                    // pause
                    Button(action: {
                        

                        if isPuaseButtonTapped == false{
                            
                            
                            self.timer?.invalidate() // 타이머중단
                            manager.cancelAllNotifications() // 노티피케이션 취소
                            isPuaseButtonTapped = true
                            // isStartButtonTapped는 true로 유지 (타이머가 활성 상태임을 나타냄)
                            
                            print("⏸️ Pause button pressed at \(seconds) seconds")
                            print("   Timer invalidated but isStartButtonTapped remains true")
                            
                            // Pause Live Activity immediately
                            #if canImport(ActivityKit)
                            if #available(iOS 16.1, *) {
                                print("📱 Pausing Live Activity with \(Int(seconds))s remaining")
                                PastaTimerActivityManager.shared.updateActivity(remainingSeconds: Int(seconds), isPaused: true)
                            } else {
                                print("⚠️ iOS 16.1+ required for Live Activity")
                            }
                            #else
                            print("⚠️ ActivityKit not imported")
                            #endif
                            
                        }else{
                            
                            
                            isPuaseButtonTapped = false
                            // isStartButtonTapped는 이미 true이므로 유지
                            
                            print("🔄 Resume button pressed, current seconds: \(seconds)")
                            print("   isStartButtonTapped remains true, isPuaseButtonTapped: false")
                            
                            // Resume Live Activity with current seconds
                            #if canImport(ActivityKit)
                            if #available(iOS 16.1, *) {
                                print("📱 Calling updateActivity with seconds: \(Int(seconds)), isPaused: false")
                                PastaTimerActivityManager.shared.updateActivity(remainingSeconds: Int(seconds), isPaused: false)
                            }
                            #endif
                            
                            timerStart(isResuming: true)  // 재개 플래그 추가
                            startNotification() // 노티피케이션 시작
                         
                        }

                        
                    }, label: {
                        Image(systemName: isPuaseButtonTapped ?  "play.fill" : "pause.fill")
                            .modifier(StyledButtonWithoutFontSizeModifier()).font(.system(size: 25))
                    })
                 
                    
                    Spacer()
                    
                    // reset, refresh
                    Button(action: {
                        self.timer?.invalidate()
                        timer = nil
                        seconds = secondsForReset
                        manager.cancelAllNotifications()
                        Settings.deactivateAllViews = false
                        isStartButtonTapped = false
                        
                        // 백그라운드 작업 종료
                        endBackgroundTask()
                        
                        // Stop Live Activity when reset
                        #if canImport(ActivityKit)
                        if #available(iOS 16.1, *) {
                            PastaTimerActivityManager.shared.stopActivity()
                        }
                        #endif
                        
                        UIApplication.shared.isIdleTimerDisabled = false // 잠금화면 전환 켜짐
                        
                    }, label: {
                        Image(systemName: "arrow.clockwise")
                            .modifier(StyledButtonWithoutFontSizeModifier()).font(.system(size: 25))
                    })
          
                    
                }

//                .frame(width: UIScreen.main.bounds.width)
                
            }else{
                
                // start
                HStack{

                    Button(action: {
                        if Settings.newHistoryID == "" && Settings.historyID == ""{
                            portionWarning = true
                        } else{
                            
                            let realm = try! Realm()

                                if Settings.newHistoryID != "" && Settings.historyID == ""{   // 새로운 히스토리일때
                                    let newUserHistory = realm.objects(UserHistory.self)
                                    let addNewUserHistory = newUserHistory.where{
                                        try! $0._id == ObjectId(string: Settings.newHistoryID)
                                    }
                                    
                                    
                                    try! realm.write{
                                        addNewUserHistory.first?.cookMinutes = seconds / 60
                                        addNewUserHistory.first?.count += 1
                                        addNewUserHistory.first?.cookDate = Date()
                                    }
                                    
                                    Settings.completeId = Settings.newHistoryID // 파스타 별점관련
                                    
                                } else{                      // 새로운 히스토리가 아닐 때
                                    
                                    
                                    if seconds == Settings.userMinutes * 60 {   // 새로운 히스토리가 아니지만 타이머가 기존의 저장 값과 같을 때
                                        
                                        let userHistory = realm.objects(UserHistory.self)
                                        let addUserHistory = userHistory.where{
                                            try! $0._id == ObjectId(string: Settings.historyID)
                                        }
                                        
                                        try! realm.write{
                                            
                                            
                                            addUserHistory.first?.count += 1
                                            addUserHistory.first?.cookDate = Date()
                                        }
                                        
                                        Settings.completeId = Settings.historyID // 파스타 별점관련
                                        
                                    }else{                                     // 새로운 히스토리가 아니지만 타이머가 기존의 저장값과 같지 않을 때
                                        
                                        // DB 저장 관련
                                        let newUserHistory = UserHistory()
                                        
                                        newUserHistory.userID = try! ObjectId(string: Settings._id)
                                        newUserHistory.kcal = Settings.userCalories
                                        newUserHistory.cookDate = Date()
                                        newUserHistory.pastaPoint = Settings.userPastaPoint
                                        newUserHistory.cookMinutes = seconds / 60
                                        newUserHistory.count += 1
                                        $userHistory.append(newUserHistory)
                                        
                                        
                                        // UserDefaults관련
                                        Settings.newHistoryID = newUserHistory._id.stringValue  // 새로운 히스토리 이력추가
                                        
                                        Settings.completeId = newUserHistory._id.stringValue // 파스타 별점관련
                                        
                                    }
                                    
                                
                                
                            }
                            
                            Settings.newHistoryID = ""
                            Settings.historyID = ""
                            
                            stopWatchStart()                    // 스탑워치 작동관련
                            Settings.deactivateAllViews = true // 스탑와치 버튼 시작시 나머지 화면 비활성화
                            
                        }
                       
                       

                        
                    }, label: {
                        
                            Text("Start")
                            .modifier(StyledButtonModifier())
  
                    })
                    .sheet(isPresented: $portionWarning) {
                        PortionWarning(selectedTab: $selectedTab)
                            .presentationDetents([.medium])
                            .presentationDragIndicator(.visible)
                    }

               
                }
               
                
            }

        }
        .padding(.horizontal, 20)
        .overlay {
            // 리뷰 요청 뷰 (알림 표시용)
            ReviewRequestView()
        }
        
        
    }
    
     
    
    
    // 포션을 먼저 하도록 강제할것
    // 히스토리를 물고 왔을 때, 시간이 다르면 새로운 히스토리로 기록되게 함
    private func saveToNewUserHistory(){
        
        
        // DB 저장 관련
        
        let newUserHistory = UserHistory()
        
        newUserHistory.userID = try! ObjectId(string: Settings._id) // 유저정보 저장
        newUserHistory.count += 1                                   // 카운트 저장
        newUserHistory.kcal = Settings.userCalories
        newUserHistory.cookDate = Date()
        newUserHistory.pastaPoint = Settings.userPastaPoint
        newUserHistory.cookMinutes = seconds / 60
        
        $userHistory.append(newUserHistory)


    }
    
    
    
    // Start 버튼 탭할 때
    private func stopWatchDataSaveByHistoryId(){
        let realm = try! Realm()
        @ObservedResults(UserHistory.self) var userHistory
        
        let userHistoryByHistoryId = userHistory.where{
            try! $0._id == ObjectId(string: Settings.historyID)
        }
        
        try! realm.write{
            
            userHistoryByHistoryId.first?.cookMinutes = seconds / 60
            userHistoryByHistoryId.first?.count += 1
            userHistoryByHistoryId.first?.cookDate = Date()
            
        }

    }
    
    
    // 노피티케이션 작동함수
    private func startNotification(){
        manager.requestAuthorization()
        manager.scheduleNotification(seconds: seconds, title : "Pasta Ready!", body:  "Time to Check Your Pasta. Perfect Doneness Awaits!")
        if is2minutesButtonTapped{
            let twoMinutesBefore = seconds - 120 // 2분전 정의
            manager.scheduleNotification(seconds: twoMinutesBefore, title : "Check the Doneness!", body:  "2 Minutes Until Pasta Is Ready")
            print("2minutes alert activated")
        }
    }
    // Start 버튼 탭할 때 - 순수 작동관련
    private func stopWatchStart(){
        
        secondsForReset = round(seconds)// 처음 설정 시간 저장 (시간 초기화)
        seconds = round(seconds)
        
        // backgroundTime 초기화 - 이전 세션의 값이 남아있을 수 있음
        Settings.backgroundTime = Date()
        
        isStartButtonTapped = true      // 타이머버튼 동작감지
        timerStart()                    // 타이머 시작
      
        startNotification()
        
        UIApplication.shared.isIdleTimerDisabled = true // 잠금화면 전환 끔
        
        // 백그라운드 작업 시작
        startBackgroundTask()
        
        
    }
    

    // 시간 포맷 변환 함수
      private func timeFormatted(_ totalSeconds: TimeInterval) -> String {
          let minutes: Int = Int(totalSeconds / 60)
          let seconds: Int = Int(totalSeconds) % 60

          return String(format: "%d:%02d", minutes, seconds)
      }
    
    
    // 백그라운드 작업 시작
    private func startBackgroundTask() {
        print("🔋 Starting background task for timer")
        
        backgroundTaskID = UIApplication.shared.beginBackgroundTask(withName: "PastaTimer") {
            // 시간 초과시 호출됨
            print("⚠️ Background task expired")
            self.endBackgroundTask()
        }
        
        if backgroundTaskID != .invalid {
            print("✅ Background task started successfully")
            print("   - Task ID: \(backgroundTaskID)")
            print("   - Background time remaining: \(UIApplication.shared.backgroundTimeRemaining)s")
        }
    }
    
    // 백그라운드 작업 종료
    private func endBackgroundTask() {
        if backgroundTaskID != .invalid {
            print("🔋 Ending background task")
            UIApplication.shared.endBackgroundTask(backgroundTaskID)
            backgroundTaskID = .invalid
        }
    }
    
    private func timerStart(isResuming: Bool = false){
        
        timer?.invalidate()
        
        // pause 상태가 아닐 때만 타이머 시작
        if isStartButtonTapped && !isPuaseButtonTapped {
            print("🚀 Timer \(isResuming ? "resumed" : "started") with \(seconds) seconds")
            
            // Only start new Live Activity if not resuming
            if !isResuming {
                // Start Live Activity for Dynamic Island and Lock Screen
                // NOTE: PastaTimerActivity.swift must be added to project target first
                // Uncomment below when file is added to Xcode project
                
                #if canImport(ActivityKit)
                if #available(iOS 16.1, *) {
                    // 파스타 이름은 일단 기본값 사용 (나중에 실제 파스타 이름 연결 필요)
                    let pastaName = "Pasta"
                    
                    // Doneness 텍스트 결정 (Custom이면 "Custom", 아니면 실제 이름)
                    let donenessText: String
                    if isCustomButtonTapped || selectedDoneness == "Custom" {
                        donenessText = "Custom"
                    } else {
                        // doneness dictionary에서 실제 이름 가져오기
                        donenessText = doneness[selectedDoneness] ?? "Custom"
                    }
                    
                    print("🍝 Starting Live Activity - Pasta: \(pastaName), Doneness: \(donenessText), Total: \(Int(seconds))s")
                    PastaTimerActivityManager.shared.startActivity(
                        pastaName: pastaName,
                        totalSeconds: Int(seconds),
                        doneness: donenessText
                    )
                } else {
                    print("⚠️ Live Activity requires iOS 16.1+")
                }
                #endif
            }
            
            
            // 백그라운드에서도 작동하는 타이머 생성
            let newTimer = Timer(timeInterval: 1.0, repeats: true) { timer in
                // 타이머가 유효한지 확인
                guard timer.isValid else {
                    print("❌ Timer is invalid, stopping")
                    return
                }
                
                if self.seconds > 0{
                    self.seconds -= 1
                    let progress = ((self.secondsForReset - self.seconds) / self.secondsForReset) * 100
                    print("\n⏱️ TIMER TICK:")
                    print("   - Remaining: \(Int(self.seconds))s")
                    print("   - Total: \(Int(self.secondsForReset))s")
                    print("   - Progress: \(String(format: "%.1f", progress))%")
                    print("   - Time: \(self.timeFormatted(TimeInterval(self.seconds)))")
                    print("   - Timer valid: \(timer.isValid)")
                    
                    // Update Live Activity every second for accurate progress bar
                    #if canImport(ActivityKit)
                    if #available(iOS 16.1, *) {
                        print("   → Updating Live Activity...")
                        PastaTimerActivityManager.shared.updateActivity(remainingSeconds: Int(self.seconds), isPaused: false)
                    } else {
                        print("   ⚠️ iOS 16.1+ required for Live Activity")
                    }
                    #else
                    print("   ⚠️ ActivityKit not imported")
                    #endif
                    
                    // 0초가 되면 즉시 종료 (1 -> 0 전환 시점)
                    if self.seconds == 0 {
                        timer.invalidate()
                        print("✅ Timer reached 0 - stopping immediately")
                        
                        // 백그라운드 작업 종료
                        self.endBackgroundTask()
                        
                        // Stop Live Activity immediately when reaching 0
                        #if canImport(ActivityKit)
                        if #available(iOS 16.1, *) {
                            PastaTimerActivityManager.shared.stopActivity()
                        }
                        #endif
                    }
                }else{
                    // 이미 0초 이하인 경우 (fallback)
                    timer.invalidate()
                    print("✅ Timer completed (already at 0)")
                    
                    // Stop Live Activity
                    #if canImport(ActivityKit)
                    if #available(iOS 16.1, *) {
                        PastaTimerActivityManager.shared.stopActivity()
                    }
                    #endif
                }
            }
            
            // 타이머를 저장하고 RunLoop에 추가
            self.timer = newTimer
            
            // RunLoop의 common 모드에 추가하여 백그라운드/저전력 모드에서도 작동
            RunLoop.current.add(newTimer, forMode: .common)
            RunLoop.main.add(newTimer, forMode: .default)
            
            print("✅ Timer added to RunLoop (common & default modes)")
            print("   - Timer tolerance: 0.1s for battery optimization")
            
            // 타이머 허용 오차 설정 (배터리 최적화)
            newTimer.tolerance = 0.1
            
        } else if isPuaseButtonTapped {
            // pause 상태일 때만 이 블록 실행
            timer?.invalidate()
            print("⏸️ Timer is in paused state at \(seconds) seconds")
            
            // Pause Live Activity with current remaining time
            #if canImport(ActivityKit)
            if #available(iOS 16.1, *) {
                // First update with current seconds, then pause
                PastaTimerActivityManager.shared.updateActivity(remainingSeconds: Int(seconds), isPaused: true)
            }
            #endif
        } else {
            // 타이머가 시작되지 않은 상태
            print("⚠️ Timer not started yet (isStartButtonTapped: \(isStartButtonTapped))")
        }
        
    }
    
   
}


struct TwoMinutesAlert: View {
    
    @Binding var is2minutesButtonTapped : Bool
    @State var isToolTipButtonTapped : Bool = false
    @AppStorage("twoMinutesHelp") private var twoMinutesHelp: Bool = true
    
    var body: some View {
        HStack{

            Button(action: {
                twoMinutesHelp = false
                isToolTipButtonTapped.toggle()

            }, label: {
               
                    RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                        .foregroundColor(.white)
                        .shadow(radius: 1)
                        .frame(width: 30, height: 30)
                        
                        .overlay{
                            Image(systemName: "2.brakesignal")
                                .font(.system(size: 15))
                                .bold()
                                .foregroundColor(.mainRed)
                            
                            Circle()
                                .frame(width: 8)
                                .foregroundColor(twoMinutesHelp ? .mainRed.opacity(0.8) : .clear)
                                .offset(CGSize(width: 14.0, height: -14.0))
                            
                        }
                    
               
            })
            .sheet(isPresented: $isToolTipButtonTapped) {
                StopWatchToolTips()
                    .presentationDetents([.medium, .large])
            }
            
            Text("2 Minutes Alert")
                .foregroundColor(.black)
                .font(.system(size: 16))
            
            Rectangle()
                .foregroundColor(.gray.opacity(0.5))
                .frame(height: 1)
           
            
            Button(action: {
                
                is2minutesButtonTapped.toggle()
                
            }, label: {
                
                if Settings.deactivateAllViews{
                    Image(systemName: is2minutesButtonTapped ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(.mainRed.opacity(0.4))
                }else{
                    Image(systemName: is2minutesButtonTapped ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(.mainRed)
                }
                
            })
          
        }
        .font(.system(size: 20))
        .bold()
        .foregroundColor(.black)
    }
}

struct Doneness: View {
    
    @State var is2minutesButtonTapped : Bool = true
    @State var isToolTipButtonTapped : Bool = false
    @AppStorage("donenessHelp") private var donenessHelp: Bool = true
    
    var body: some View {
        HStack{

            Button(action: {
                donenessHelp = false // 한번 클릭하면 사라지게
                isToolTipButtonTapped.toggle()

            }, label: {
               
                    RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                        .foregroundColor(.white)
                        .shadow(radius: 1)
                        .frame(width: 30, height: 30)
                        
                        .overlay{
                            Image(systemName: "timer")
                                .font(.system(size: 15))
                                .bold()
                                .foregroundColor(.mainRed)
                            
                            Circle()
                                .frame(width: 8)
                                .foregroundColor(donenessHelp ? .mainRed.opacity(0.8) : .clear)
                                .offset(CGSize(width: 14.0, height: -14.0))
                            
                        }
                    
               
            })
            .sheet(isPresented: $isToolTipButtonTapped) {
                StopWatchDoneness()
                    .presentationDetents([.medium, .large])
            }
            
            Text("Doneness")
                .foregroundColor(.black)
                .font(.system(size: 16))
          
        }
        .font(.system(size: 20))
        .bold()
        .foregroundColor(.black)
    }
}


private struct TopStack : View {
   
    @State var logoSize : CGFloat = 40
    @State var title : String = "Funny Cat"
    @EnvironmentObject var presentData : PresentData
    @State var isPresented : Bool = false
   
   var body: some View {
       HStack{
           Button(action: {
               
               // 에러시에만 활성화 할것
//                              Settings.deactivateAllViews.toggle()
               
               
               
           }, label: {
               
               TopStackLogo()

           })
           
           Spacer()
           
           HStack(spacing: -10){

               Text("\(Settings.userEmoji) \(Settings.userName)")
                   .font(.system(size: 20))
                   .bold()
                   .foregroundColor(.black)
                   .padding()

           }
           .shadow(radius: 2)
           .offset(CGSize(width: -1.0, height: 0.0))
           
           Spacer()
           
           Button(action: {
               
//              isPresented = true
               
           }, label: {
               Image(systemName: "gearshape.fill")
                   .resizable()
                   .scaledToFit()
                   .frame(width: logoSize * 0.65)
                   .foregroundColor(.clear)
                   .padding(.trailing)
           })
           .sheet(isPresented: $isPresented) {
//               PortionOption()
//                   .presentationDetents([.medium, .large])
           }
           
       }
       .padding(.vertical, -10)
   }
}

// MARK: - Review Request Manager for 1.3
class ReviewRequestManager: ObservableObject {
    static let shared = ReviewRequestManager()
    
    @Published var showEmotionCheck = false
    @Published var showReviewRequest = false
    @Published var showFeedbackForm = false
    
    private init() {}
    
    // 1.3 이전 사용자 체크 및 리뷰 요청
    func checkAndRequestReview() {
        // 이미 1.3에서 요청했는지 확인
        let hasRequestedReview = UserDefaults.standard.bool(forKey: "hasRequestedReviewFor1.3")
        
        if hasRequestedReview {
            return // 이미 요청했으면 종료
        }
        
        // UserDefaults에서 이전 버전 확인
        let lastVersion = UserDefaults.standard.string(forKey: "lastAppVersion") ?? "1.0"
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.3"
        
        // 처음 실행이거나 1.3 이전 버전 사용자면 즉시 리뷰 요청
        if lastVersion < "1.3" {
            DispatchQueue.main.async {
                self.showEmotionCheck = true
                UserDefaults.standard.set(true, forKey: "hasRequestedReviewFor1.3")
                UserDefaults.standard.set(currentVersion, forKey: "lastAppVersion")
            }
        }
    }
    
    // 리뷰 응답 로깅 (UserDefaults 사용)
    func logReviewResponse(response: String) {
        UserDefaults.standard.set(response, forKey: "reviewResponse1.3")
        UserDefaults.standard.set(Date(), forKey: "reviewResponseDate1.3")
    }
}

// SwiftUI Views for Review Request
struct ReviewRequestView: View {
    @StateObject private var manager = ReviewRequestManager.shared
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        EmptyView()
            .alert("🍝 오래 기다리셨죠?", isPresented: $manager.showEmotionCheck) {
                Button("😊 최고예요!", role: .none) {
                    manager.showEmotionCheck = false
                    manager.showReviewRequest = true
                    manager.logReviewResponse(response: "positive")
                }
                Button("😐 글쎄요", role: .none) {
                    manager.showEmotionCheck = false
                    manager.showFeedbackForm = true
                    manager.logReviewResponse(response: "negative")
                }
            } message: {
                Text("""
                Dynamic Island 드디어 추가!
                이제 더 편하게 요리하세요
                
                어떠신가요?
                """)
            }
            .alert("좋아해주셔서 기뻐요! 😊", isPresented: $manager.showReviewRequest) {
                Button("⭐ 리뷰 쓰기", role: .none) {
                    requestAppStoreReview()
                    manager.logReviewResponse(response: "wrote_review")
                }
                Button("나중에", role: .cancel) {
                    manager.logReviewResponse(response: "review_later")
                }
            } message: {
                Text("""
                파스타 러버들이
                이 앱을 찾을 수 있게
                리뷰 하나만 부탁드릴게요
                
                (정말 짧게 써도 OK!)
                """)
            }
            .alert("아쉬우셨군요 😔", isPresented: $manager.showFeedbackForm) {
                Button("📧 이메일로 피드백 보내기", role: .none) {
                    sendFeedbackEmail()
                    manager.logReviewResponse(response: "sent_email")
                }
                Button("닫기", role: .cancel) {
                    manager.logReviewResponse(response: "feedback_dismissed")
                }
            } message: {
                Text("""
                어떤 점이 불편하신지
                알려주시면 개선하겠습니다
                """)
            }
    }
    
    private func requestAppStoreReview() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    private func sendFeedbackEmail() {
        let email = "studiofiveteam@gmail.com"
        let subject = "[PastaPortionPro 1.3] 피드백"
        let body = """
        앱 버전: 1.3
        기기: \(UIDevice.current.model)
        iOS: \(UIDevice.current.systemVersion)
        
        피드백:
        
        """
        
        // URL 인코딩
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        // mailto URL 생성
        if let url = URL(string: "mailto:\(email)?subject=\(subjectEncoded)&body=\(bodyEncoded)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                // 이메일 앱이 없으면 클립보드에 복사
                UIPasteboard.general.string = email
                print("Email address copied to clipboard: \(email)")
            }
        }
    }
}
