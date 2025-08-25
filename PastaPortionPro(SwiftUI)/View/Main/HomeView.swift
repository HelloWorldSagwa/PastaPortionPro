//
//  HomeView.swift
//  PastaPortionPro(SwiftUI)
//
//  Created by SungHyun Kim on 2023/09/02.
//

import SwiftUI
import UserNotifications


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
