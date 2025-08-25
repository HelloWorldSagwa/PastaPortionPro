//
//  HomeView.swift
//  PastaPortionPro(SwiftUI)
//
//  Created by SungHyun Kim on 2023/09/02.
//

import SwiftUI
import UserNotifications


// 설정 옵션
// 1. Home : 최초 탭은 무엇으로 할것인가?
// 2. History : 평균과 모스트는 닫을까 말까?
// 3. Portion : Custom옵션 버튼 위치 조절 모달 팝업 창 띄우고, 설정창은.. 커스텀을 먼저 보여줄거냐?
// 4. Timer : Customㅇ르 먼저 보여줄거냐? 아니냐?

/*
 
 *** 1.3.0 변경사항 ***
 1. 광고 제거 - 유료전환
 2. 아이폰16 지원
 3. 앱 평가 추천 기능 추가
 
 
 
 */


struct HomeView: View {
    
    @State private var selectedTab : String = "Home"
    @EnvironmentObject var presentData : PresentData
    @AppStorage("deactivateAllViews") private var deactivateAllViews: Bool = Settings.deactivateAllViews
    
    // 웰컴시트
    @State var firstLogin : Bool = false

    
    var body: some View {
        
        
        //---------------탭뷰 시작---------------//
        
        TabView(selection: $selectedTab){
            
            HomeViewTabHome(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: deactivateAllViews ? "" : "house.circle")
                    Text(deactivateAllViews ? "" : "Home")
                }
                .tag("Home")
            
            History(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: deactivateAllViews ? "" : "chart.bar.doc.horizontal.fill")
                    Text(deactivateAllViews ? "" : "History")
                }
                .tag(Settings.deactivateAllViews ? "" : "History")
            
            HomeViewTabPortion(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: deactivateAllViews ? "" : "circle.circle")
                    Text(deactivateAllViews ? "" : "Portion")
                }
                .tag("Portion")
            
            StopWatch(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: deactivateAllViews ? "" : "timer.circle")
                    Text( deactivateAllViews ? "" : "Timer")
                }
                .tag("Timer")
            
            HomeViewTabSettings(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: deactivateAllViews ? "" : "person.circle.fill")
                    Text(deactivateAllViews ? "" : "MY")
                    
                    //                    Image(systemName: "person.circle.fill")
                    //                    Text("MY")
                }
                .tag("Settings")
        }
        
        
        
        .onChange(of: selectedTab){ newValue in
            
            if newValue == "Timer" || deactivateAllViews {
                selectedTab = "Timer"
            }
            
            if newValue == "Home" && newValue == "History"{
                // 관련 데이터 초기화
                dataRefresh() // PPPBrain
            }
            

            
            // 애드몹 관련 -> 1.3.0 삭제
//            if Settings.premiumAccess || deactivateAllViews {
//                if admobCount > 0{
//                    admobCount = 0
//                }
//            }else{

                
                // 타이머 선택시 포션 선택시 지체없이 바로 실행 : 첫번째 로그인 때는 봐줌
//                if !Settings.firstLogin && selectedTab == "Portion"{
//                    interstitialAdManager.loadInterstitialAd() // v1.2.0에서 광고 로드는 한번만
//                    interstitialAdManager.displayInterstitialAd()
//                    admobCount = 0
//                }
//                
                
                // 애드몹 최대 탭 횟수에 도달했을 경우 - v1.2.0에서 삭제
//                admobCount += 1
//                if admobCount == admobCountRange {
//                    
//                    print("admobCountRange :", admobCountRange)
//                    
//                    interstitialAdManager.displayInterstitialAd()
//                    admobCount = 0
//                }
                
//            }
            
            
            
        }
        
        .onAppear{
            
            
            
            // 노티피케이션 권한요청
            // Request permission for notifications
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) { granted, error in
                if granted {
                    print("We have permission")
                } else {
                    print("Permission denied")
                }
            }
            
            
            // 로그인후 첫화면은 무조건 포션을 찍게
            
            
            // 로그인 직후 팝업화면 제어
            if Settings.firstLogin{
                selectedTab = "Portion"
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    firstLogin = true
                }
            }else{
                firstLogin = Settings.firstLogin
            }
            
            UITabBar.appearance().backgroundColor = UIColor(Color.white).withAlphaComponent(0.5)
            print("onAppear 부모뷰 감지 : \(selectedTab)")
            
            
        }
        .sheet(isPresented: $firstLogin) { // Moved sheet here
            
            Welcome()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        
        .accentColor(.mainRed)
        .navigationBarBackButtonHidden(true)
        
        
        //---------------탭뷰 끝---------------//
        
    }
    
    
    
    
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(PresentData())
        
    }
}
