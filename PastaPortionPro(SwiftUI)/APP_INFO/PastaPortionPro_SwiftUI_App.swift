//
//  PastaPortionPro_SwiftUI_App.swift
//  PastaPortionPro(SwiftUI)
//
//  Created by SungHyun Kim on 2023/07/28.
//

import SwiftUI
import FirebaseCore
import FirebaseAnalytics

@main
struct PastaPortionPro_App: App {
    
    
    //    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate             // Firebase 추가 - v.1.1.0
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var presentData = PresentData()
    @Environment(\.scenePhase) var scenePhase
    
    
    var body: some Scene {
        WindowGroup {
            MainIntro()
                .environmentObject(presentData)
                .onChange(of: scenePhase){ newValue in
                    
                    if newValue == .background{
                        // 앱이 활성화 상태일때
                        Settings.backgroundTime = Date()
                    }else if newValue == .active{
                        UIApplication.shared.applicationIconBadgeNumber = 0 // 앱을 켜면 항상 뱃지는 0으로 초기화
                    }
                    
                }
                .onAppear(perform: {
                    
                    Settings.deactivateAllViews = false // 앱실행시 밑에 탭바 살림
                    
                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()// 앱실행시 노티피케이션 삭제
                    
                    // v1.3 부터 프리미엄 액세스로 전체 변경
                    Settings.premiumAccess = true
                    
                })
            
            
        }
        
    }
}




class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()             // Firebase 추가 - v.1.1.0
        
        Analytics.setAnalyticsCollectionEnabled(true)
        
        if let app = FirebaseApp.app() {
            print(app.options)
            // Firebase is configured, use `app.options` to get access to options.
        } else {
            // Firebase is not configured.
        }
        
        return true
    }
    // 앱이 활성화될 때 배지 숫자 초기화
    
}

