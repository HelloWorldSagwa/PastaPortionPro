//
//  MainIntro.swift
//  PastaPortionPro(SwiftUI)
//
//  Created by SungHyun Kim on 1/24/24.
//

import SwiftUI
//import RealmSwift

//레커멘데이션 심각하게 고려해볼것. 아마도 버전 2.0부터?

struct MainIntro: View {
    
    
    // 프로필 아이콘 변경 할 수 있게
    
    //공통데이터 관련
    
    @EnvironmentObject var presentData : PresentData
    @StateObject private var dataLoader = DataLoader()
    @State private var firstMeet : Bool = true
    @State private var firstLogin : Bool = true
    
    
    var body: some View {
        
        Group{
            
            if dataLoader.isLoading{
                LoadingView()
                    .onAppear(perform: {
                        if !Settings.firstMeet {
                            firstMeet = false
                        }else{
                            firstMeet = true
                        }
                    })
                
                
            }else{
                
                if firstMeet{
                    FirstMeet(firstMeet: $firstMeet)
                    
                    
                }else if presentData.currentView == "LogIn"{
                    
                    LogIn()
                    
                    
                }else if presentData.currentView == "LoggedOn"{
                    
                    HomeView()
                    
                }else{
                    
                    Image("PPP_LOGO")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 330)  // 크기를 줄임
                        .clipped()
                    
                }
                
                
                
                
            }
            
        }
        .animation(.easeInOut, value: dataLoader.isLoading)
        .transition(.opacity)
        
        
        
            
        
        
    }
    
}


struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                MainLogoWithSlogan()
                
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .foregroundColor(.mainRed)
                    .bold()
                    .padding()
                 
            }
          
        }
    }
}

#Preview {
    MainIntro()
        .environmentObject(PresentData())
}


